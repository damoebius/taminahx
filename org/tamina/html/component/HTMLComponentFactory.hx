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

    public static function build(rootClassName:String):Array<Field> {
        var fields = Context.getBuildFields();
        var cls = Context.getLocalClass().get();
        var className = cls.pack.join('.') + '.' + cls.name;

        // Inject fields
        fields = injectViewGetter(cls, rootClassName, fields);

        // Check fields
        checkConstructor(fields);
        checkConnectedCallback(fields);
        checkDisconnectedCallback(fields);
        checkAttributeChangedCallback(fields);
        // checkAdoptedCallback(fields);

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

    private static function injectViewGetter(cls:ClassType, rootClassName:String, fields:Array<Field>):Array<Field> {
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
                case FFun(f):
                if (f.args.length > 0) {
                    Context.error('Custom Elements: constructor cannot have arguments.', constructor.pos);
                }

                default:
            }

            // Constructor should have super() as first instruction
            BuildTools.ensureSuperIsFirstInstruction(constructor, 'Custom Elements: constructor must call super(). first');

            // The component should not try to alter its html in its constructor
            // TODO: block or redirect to _tempVirtualDOM
        }
    }

    private static function checkConnectedCallback(fields:Array<Field>):Void {
        var callback:Field = BuildTools.getFieldByName(fields, "connectedCallback");

        if (callback != null) {
            if (!BuildTools.hasSuperCall(callback)) {
                Context.error('Custom Elements: connectedCallback must call super.connectedCallback()', callback.pos);
            }
        }
    }

    private static function checkDisconnectedCallback(fields:Array<Field>):Void {
        var callback:Field = BuildTools.getFieldByName(fields, "disconnectedCallback");

        if (callback != null) {
            if (!BuildTools.hasSuperCall(callback)) {
                Context.error('Custom Elements: disconnectedCallback must call super.disconnectedCallback()', callback.pos);
            }
        }
    }

    private static function checkAttributeChangedCallback(fields:Array<Field>):Void {
        var callback:Field = BuildTools.getFieldByName(fields, "attributeChangedCallback");

        if (callback != null) {
            if (!BuildTools.hasSuperCall(callback)) {
                Context.error('Custom Elements: attributeChangedCallback must call super.attributeChangedCallback()', callback.pos);
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
