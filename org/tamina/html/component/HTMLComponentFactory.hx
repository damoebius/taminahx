package org.tamina.html.component;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr.Field;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import sys.io.File;

using Lambda;

class HTMLComponentFactory {

    private static var _registeredXTags:Array<String> = null;

    public static function build():Array<Field> {
        var cls = Context.getLocalClass().get();
        var className = cls.pack.join('.') + '.' + cls.name;

        var p = Context.resolvePath(getViewPath(cls));
        var content = File.getContent(p);
        var pos = Context.currentPos();
        var fields = Context.getBuildFields();

        fields.push({
            name: "getView",
            doc: null,
            meta: [],
            access: [APublic],
            kind: FFun({
                args: [],
                params: [],
                ret: null,
                expr: macro {
                    return $v{content};
                }
            }),
            pos: pos
        });

        // Default xtag is built from full path (package name + class name), using dashes instead of dots
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

        // Do not allow multiple class to define the same xtag
        if (_registeredXTags == null) {
            _registeredXTags = new Array<String>();
        } else {
            if (Lambda.has(_registeredXTags, xtagExpr)) {
                Context.fatalError(
                    'Cannot register a custom component named "$xtagExpr": this xtag has already been registered',
                    cls.pos
                );
            }
        }
        _registeredXTags.push(xtagExpr);

        // Print custom components info (xtag + haxe class) if DEBUG_COMPONENTS is defined
        var debugComponents = Compiler.getDefine("DEBUG_COMPONENTS");
        if (debugComponents != null) {
            if (isCustomXTag) {
                Context.warning('Registering custom component **$xtagExpr** from the class **$className**', cls.pos);
            } else {
                Context.warning('Registering custom component **$xtagExpr**', cls.pos);
            }
        }

        fields.push({
            name: '__registered',
            pos: cls.pos,
            access: [AStatic],
            kind: FVar(macro : Bool, macro @:pos(cls.pos) {
                org.tamina.html.component.HTMLApplication.componentsXTagList.set($v{xtagExpr}, $v{className});
                return true;
            })
        });

        // Create static function 'createInstance' on target Class
        fields.push({
            name: 'createInstance',
            pos: cls.pos,
            access: [AStatic, APublic],
            kind: FFun({
                params: [],
                args: [],
                ret: TypeTools.toComplexType(Context.getLocalType()),
                expr: macro {
                    return cast js.Browser.document.createElement($v{xtagExpr});
                }
            })
        });

        return fields;
    }

    private static function getViewPath(cls:ClassType):String {
        if (cls.meta.has("view")) {
            var fileNameExpr = Lambda.filter(cls.meta.get(), function(meta) return meta.name == "view").pop().params[0];

            // Use current path + filename for the html file if @view's first argument is empty
            if (ExprTools.getValue(fileNameExpr) == "") {
                return cls.pack.join("/") + "/" + cls.name + ".html";

            } else {
                return ExprTools.getValue(fileNameExpr);
            }
        } else {
            return Context.error("Please specify @view metadata.", cls.pos);
        }
    }

    @:deprecated
    // Not used any more?
    private static function updateField(name:String, value:String):Field {
        var result:Field = null;
        var fields = Context.getBuildFields();

        for (i in 0...fields.length) {
            var f = fields[i];

            if (f.name == name) {
                switch (f.kind) {
                    case FVar(t, e):
                    f.kind = FVar(t, Context.makeExpr(value, f.pos));

                    default:
                    throw "invalid";
                }

                break;
            }
        }
        return result;
    }
}
