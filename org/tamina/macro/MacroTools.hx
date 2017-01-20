package org.tamina.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;
import haxe.macro.TypeTools;

class MacroTools {

    public static macro function match(value, pattern:Expr):Expr {
        return macro switch ($value) {
            case $pattern: true;
            case _: false;
        }
    }

}
