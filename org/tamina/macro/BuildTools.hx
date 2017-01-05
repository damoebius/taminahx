package org.tamina.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.TypeTools;

class BuildTools {

    public static function getFieldByName(fields:Array<Field>, fieldName:String):Field {
        var result:Array<Field> = fields.filter(function(field) {
            return field.name == fieldName;
        });

        if (result.length > 0) return result[0];
        return null;
    }

    public static function ensureSuperIsFirstInstruction(field:Field, errMessage:String):Void {
        switch (field.kind) {
            case FFun({expr: {expr: EBlock(exprs), pos: _}, args: _, params: _, ret: _}):
                var superIsFirst:Bool = isSuperCall(exprs[0]);

                if (!superIsFirst) {
                    Context.fatalError(errMessage, field.pos);
                }

            default:
        }
    }

    public static function hasSuperCall(field:Field):Bool {
        switch (field.kind) {
            case FFun({expr: {expr: EBlock(exprs), pos: _}, args: _, params: _, ret: _}):
                var hasSuper:Bool = false;

                for (expr in exprs) {
                    hasSuper = isSuperCall(expr);

                    if (hasSuper) break;
                }

                return hasSuper;

            default:
            return false;
        }
    }

    public static function isSuperCall(expr:Expr):Bool {
        switch (expr.expr) {
            case ECall({expr: EConst(CIdent(ident)), pos: _}, _): // For constructors
            if (ident == "super") return true;
            
            case ECall({expr: EField({expr: EConst(CIdent(ident)), pos: _}, _), pos: _}, _): // For Methods
            if (ident == "super") return true;

            default:
        }

        return false;
    }

}
