package org.tamina.macro;

class MacroTools {

    public static macro function match(value, pattern:Expr):Expr {
        return macro switch ($value) {
            case $pattern: true;
            case _: false;
        }
    }

}
