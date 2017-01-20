package org.tamina.html.component;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import sys.FileSystem;
import sys.io.File;

import org.tamina.macro.BuildTools;

using Lambda;

class HTMLComponentFactory {

    private static var _hasBuiltXTags:Bool = false;
    private static var _registeredOnGenerate:Bool = false;

    private static var _registeredXTags:Array<String> = null;
    private static var _xtagsClasses:Map<String, String>;

    public static function buildComponent():Array<Field> {
        var fields = Context.getBuildFields();
        var cls = Context.getLocalClass().get();
        var className = cls.pack.join('.') + '.' + cls.name;

        // Inject fields
        fields = injectViewGetter(cls, fields);

        // Check fields
        checkConstructor(fields);
        checkCallback("connectedCallback", fields);
        checkCallback("disconnectedCallback", fields);
        checkCallback("adoptedCallback", fields);
        checkCallback("attributeChangedCallback", fields);
        checkCallback("creationCompleteCallback", fields);

        // Register component
        var xtagExpr = registerXTag(cls);

        // Post-compilation stuff
        if (!_registeredOnGenerate) {
            _registeredOnGenerate = true;
            Context.onGenerate(populateXTags);
        }

        return fields;
    }

    private static function populateXTags(types:Array<Type>):Void {
        if (!_hasBuiltXTags) {
            _hasBuiltXTags = true;

            // Include native shim
            Compiler.includeFile("native-shim.js", Top);

            if (_registeredXTags != null) {
                var topScript:Array<String> = [
                    'var XTags = {};',
                    'var CustomElements = {};'
                ];

                for (tag in _registeredXTags) {
                    var className:String = _xtagsClasses.get(tag);
                    topScript.push('XTags["$className"] = "$tag";');
                    topScript.push('CustomElements["$tag"] = "$className";');
                }

                // Write script to temp file
                var file = File.write("top-script.js");
                file.writeString(topScript.join('\n'));
                file.close();

                // Include custom scripts
                Compiler.includeFile("top-script.js", Closure);

                // Remove temp file after compilation
                Context.onAfterGenerate(function() {
                    FileSystem.deleteFile("top-script.js");
                });
            }
        }
    }

    private static function injectViewGetter(cls:ClassType, fields:Array<Field>):Array<Field> {
        var pos = Context.currentPos();
        var viewPath = getViewPath(cls);

        if (viewPath != null) {
            var content = File.getContent(Context.resolvePath(viewPath));

            // Try to add the method at the end of the class
            // To avoid having methods above attributes
            if (fields.length > 0) {
                pos = fields[fields.length - 1].pos;
            }

            // Add field
            fields.push({
                name: "getView",
                doc: null,
                meta: [],
                access: [APublic, AOverride],
                kind: FFun({
                    args: [],
                    params: [],
                    ret: null,
                    expr: macro { return $v{content}; }
                }),
                pos: pos
            });
        }

        return fields;
    }

    private static function checkConstructor(fields:Array<Field>):Void {
        var constructor:Field = BuildTools.getFieldByName(fields, "new");

        if (constructor != null) {
            // Constructor should be private
            if (constructor.access.has(Access.APublic)) {
                Context.warning('Custom elements: constructor should be private.', constructor.pos);
            }

            // Constructor should not have arguments
            switch (constructor.kind) {
                case FFun(f) if (f.args.length > 0):
                Context.error('Custom Elements: constructor cannot have arguments.', constructor.pos);

                default:
            }

            // Enforce custom elements v1 specs
            // See https://html.spec.whatwg.org/multipage/scripting.html#custom-element-conformance

            // A parameter-less call to super() must be the first statement in the constructor body,
            // to establish the correct prototype chain and this value before any further code is run.
            if (!BuildTools.superIsFirstInstruction(constructor)) {
                Context.error('Custom Elements: constructor must call super() first.', constructor.pos);
            }

            // A return statement must not appear anywhere inside the constructor body,
            // unless it is a simple early-return (return or return this).
            // Nothing to do; haxe already checks this.

            // The constructor must not use the document.write() or document.open() methods.
            // TODO (nearly impossible?)

            // The element's attributes and children must not be inspected,
            // as in the non-upgrade case none will be present,
            // and relying on upgrades makes the element less usable.
            // TODO (nearly impossible?)

            // The element must not gain any attributes or children,
            // as this violates the expectations of consumers who use the createElement or createElementNS methods.
            // TODO (nearly impossible?)
        }
    }

    private static function checkCallback(callbackName:String, fields:Array<Field>):Void {
        var callback:Field = BuildTools.getFieldByName(fields, callbackName);

        if (callback != null) {
            // Callback should be private
            if (callback.access.has(Access.APublic)) {
                Context.warning('Custom elements: $callbackName should be private.', callback.pos);
            }

            // Callback must call parent at some point
            if (!BuildTools.hasSuperCall(callback)) {
                Context.error('Custom Elements: $callbackName must call super.$callbackName().', callback.pos);
            }
        }
    }

    private static function registerXTag(cls:ClassType):String {
        // Default xtag is built from full path (package name + class name), using dashes instead of dots
        var className = cls.pack.join('.') + '.' + cls.name;
        var xtagExpr = className.toLowerCase().split('.').join('-');
        var isCustomXTag:Bool = false;

        // Custom xtag expression can be defined with @view's second argument
        if (cls.meta.has("view")) {
            var viewParams = cls.meta.extract("view").pop().params;

            if (viewParams.length > 1) {
                var xtag:String = ExprTools.getValue(viewParams[1]);
                isCustomXTag = true;
                
                // Use xtag prefix if defined
                var xtagPrefix = Compiler.getDefine("XTAG_PREFIX");
                if (xtagPrefix != null) {
                    xtag = xtagPrefix + "-" + xtag;
                }

                // Fail if no dash found (custom components names must contain at least one dash)
                if (xtag.indexOf("-") > -1) {
                    xtagExpr = xtag;
                } else {
                    Context.fatalError(
                        'Cannot register a custom component named "$xtag".\n'
                        + 'Custom components names must contain at least one dash. '
                        + 'You can prefix all your custom tags by compiling with -D XTAG_PREFIX=myprefix',
                        cls.pos
                    );
                }
            }
        }

        saveXTag(xtagExpr, className, cls.pos);

        // Print custom components info (xtag + haxe class) if DEBUG_COMPONENTS is defined
        #if DEBUG_COMPONENTS
            if (isCustomXTag) {
                Context.warning('Registering custom component **$xtagExpr** from the class **$className**', cls.pos);
            } else {
                Context.warning('Registering custom component **$xtagExpr**', cls.pos);
            }
        #end

        return xtagExpr;
    }

    private static function saveXTag(xtagExpr:String, className:String, pos:Position):Void {
        // Do not allow multiple class to define the same xtag
        if (_registeredXTags == null) {
            _registeredXTags = new Array<String>();
        } else {
            if (Lambda.has(_registeredXTags, xtagExpr)) {
                Context.fatalError(
                    'Cannot register a custom component named "$xtagExpr": this xtag has already been registered',
                    pos
                );
            }
        }

        if (_xtagsClasses == null) {
            _xtagsClasses = new Map<String, String>();
        }

        _registeredXTags.push(xtagExpr);
        _xtagsClasses.set(xtagExpr, className);
    }

    private static function getViewPath(cls:ClassType):String {
        if (cls.meta.has("view")) {
            var fileNameExpr = Lambda.filter(cls.meta.get(), function(meta) return meta.name == "view").pop().params[0];
            var fileName:String = ExprTools.getValue(fileNameExpr);

            // No html view for this component
            if (fileName == "null") {
                return null;

            // Use current path + filename for the html file if @view's first argument is empty
            } else if (fileName == "") {
                return cls.pack.join("/") + "/" + cls.name + ".html";

            // Use current path if @view's first argument starts with "./"
            } else if (fileName.indexOf("./") == 0) {
                return cls.pack.join("/") + "/" + fileName;

            } else {
                return fileName;
            }
        } else {
            return Context.error("Please specify @view metadata.", cls.pos);
        }
    }

}
