package org.tamina.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.TypeTools;

import org.tamina.macro.MacroTools.match;

class BuildTools {

    public static function getFieldByName(fields:Array<Field>, fieldName:String):Field {
        var result:Array<Field> = fields.filter(function(field) {
            return field.name == fieldName;
        });

        if (result.length > 0) return result[0];
        return null;
    }

    public static function superIsFirstInstruction(field:Field):Bool {
        return match(field.kind, FFun({expr: {expr: EBlock(isSuperCall(extractFirstExpr(_)) => true), pos: _}, args: _, params: _, ret: _}));
    }

    public static function hasSuperCall(field:Field):Bool {
        return match(field.kind, FFun({expr: {expr: EBlock(exprArrContainsSuper(_) => true), pos: _}, args: _, params: _, ret: _}));
    }

    public static function isSuperCall(expr:Expr):Bool {
        return match(expr.expr, ECall({expr: EConst(CIdent("super")) | EField({expr: EConst(CIdent("super")), pos: _}, _), pos: _}, _));
    }

    public static function extractFirstExpr(exprs:Array<Expr>):Expr {
        if (exprs.length == 0) return null;
        return exprs[0];
    }

    public static function exprArrContainsSuper(exprs:Array<Expr>):Bool {
        var containsSuper:Bool = false;

        for (expr in exprs) {
            containsSuper = isSuperCall(expr);
            if (containsSuper) break;
        }

        return containsSuper;
    }

}
