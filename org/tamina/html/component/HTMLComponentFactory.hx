package org.tamina.html.component;

import haxe.macro.Context;
import haxe.macro.Expr.Field;
import haxe.macro.Type;

using Lambda;

class HTMLComponentFactory {
    macro public static function build():Array<Field>{
        var cls = Context.getLocalClass().get();
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
        return fields;
    }

    static function getViewPath(cls:ClassType):String
    {
        if (cls.meta.has("view"))
        {
            var fileNameExpr = Lambda.filter(cls.meta.get(), function(meta) return meta.name == "view").pop().params[0];
            var fileName:String = haxe.macro.ExprTools.getValue(fileNameExpr);
            return fileName;
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
