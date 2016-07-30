package org.tamina.html.component;

import haxe.macro.TypeTools;
import haxe.macro.Context;
import haxe.macro.Expr.Field;
import haxe.macro.Type;

using Lambda;

class HTMLComponentFactory {
    public static function build():Array<Field>{
        var cls = Context.getLocalClass().get();
        var className = cls.pack.join('.') + '.' + cls.name;
       //registerComponent(className);
        //Context.error("Debug : " + htmlApplicationClass.name, Context.currentPos());
        var p = Context.resolvePath(getViewPath(cls));
        var content = sys.io.File.getContent(p);
        var pos = Context.currentPos();
        var fields = Context.getBuildFields();
        fields.push({
            name : "getView",
            doc : null,
            meta : [],
            access : [APublic],
            kind : FFun({
                args:[],
                ret:null,
                expr:macro {
                    return $v{content};
                },
                params:[]
            }),
            pos : pos
        });

        var xtagExpr = className.toLowerCase().split('.').join('-');
        if (cls.meta.has("view")) {
            var viewParams = cls.meta.extract("view").pop().params;

            if (viewParams.length > 1) {
                var xtag:String = haxe.macro.ExprTools.getValue(viewParams[1]);
                var xtagPrefix = haxe.macro.Compiler.getDefine("xtagPrefix");
                if (xtagPrefix != null) {
                    xtag = xtagPrefix + "-" + xtag;
                }
                
                if (xtag.indexOf("-") > -1) {
                    xtagExpr = xtag;
                } else {
                    Context.fatalError('Cannot register a custom component named "$xtag".\nCustom components names must contain at least one dash. You can prefix all your custom tags by compiling with -D xtagPrefix=myprefix', Context.currentPos());
                }
            }
        }

        fields.push({
            name: '__registered',
            pos: cls.pos,
            access: [AStatic],
            kind: FVar(macro : Bool, macro @:pos(cls.pos) {
            org.tamina.html.component.HTMLApplication.componentsTagList.set($v{xtagExpr}, $v{className});
            true;
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

    static function getViewPath(cls:ClassType):String
    {
        if (cls.meta.has("view"))
        {
            var fileNameExpr = Lambda.filter(cls.meta.get(), function(meta) return meta.name == "view").pop().params[0];

            if (haxe.macro.ExprTools.getValue(fileNameExpr) == "") {
                return cls.pack.join("/") + "/" + cls.name + ".html";
            } else {
                var fileName:String = haxe.macro.ExprTools.getValue(fileNameExpr);
                return fileName;
            }
        } else {
            return Context.error("Please specify @view metadata.", Context.currentPos());
        }
    }

    static function updateField(name:String,value:String):Field{
        var result:Field=null;
        var fields = Context.getBuildFields();
        for(i in 0...fields.length){
            var f = fields[i];
            if(f.name == name){
                switch( f.kind ){
                    case FVar(t,e) : f.kind = FVar(t, Context.makeExpr( value, f.pos ));
                    default : throw "invalid" ;
                }
                break;
            }
        }
        return result;
    }
}
