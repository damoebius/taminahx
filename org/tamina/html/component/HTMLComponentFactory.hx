package org.tamina.html.component;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import sys.io.File;

import org.tamina.macro.BuildTools;

using Lambda;

class HTMLComponentFactory {

    private static var _registeredXTags:Array<String> = null;

    public static function build():Array<Field> {
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
        var xtagExpr = getXTag(cls);
        fields.push({
            name: '__registered',
            pos: cls.pos,
            access: [AStatic],
            kind: FVar(macro : Bool, macro @:pos(cls.pos) {
                org.tamina.html.component.HTMLApplication.componentsXTagList.set($v{xtagExpr}.toLowerCase(), $v{className});
                true;
            })
        });

        return fields;
    }

    private static function injectViewGetter(cls:ClassType, fields:Array<Field>):Array<Field> {
        var pos = Context.currentPos();
        var content = File.getContent(Context.resolvePath(getViewPath(cls)));

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

    private static function getXTag(cls:ClassType):String {
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

        registerXTag(xtagExpr, cls.pos);

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

    private static function registerXTag(xtagExpr:String, pos:Position):Void {
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

        _registeredXTags.push(xtagExpr);
    }

    private static function getViewPath(cls:ClassType):String {
        if (cls.meta.has("view")) {
            var fileNameExpr = Lambda.filter(cls.meta.get(), function(meta) return meta.name == "view").pop().params[0];
            var fileName:String = ExprTools.getValue(fileNameExpr);

            // Use current path + filename for the html file if @view's first argument is empty
            if (fileName == "") {
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
