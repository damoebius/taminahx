package org.tamina.utils;
import js.Error;
class ColorUtils {
/**
       * convert a color number to hex value
       * ex 1677845 -> #FF5500
     */
    public static function decColor2hex( color:Float ):String {
/*var colArr =  color.toString(16).toUpperCase().split('');
        var numChars = colArr.length;
        for (a in 0...(6 - numChars)) {
            colArr.unshift("0");
        }
        return('#' + colArr.join('')); */
        return ('#000000');
    }

    public static function invert( color:String ):String {
        if ( color.length != 7 ) {
            throw new Error("Hex color must be six hex numbers in length.");
        }

        var hexnum = color.toUpperCase().substr(1);
        var splitnum:Array<Int> = cast hexnum.split("");
        var resultnum = "";
        var simplenum = "FEDCBA9876".split("");
        var complexnum:Dynamic = {};
        complexnum.A = "5";
        complexnum.B = "4";
        complexnum.C = "3";
        complexnum.D = "2";
        complexnum.E = "1";
        complexnum.F = "0";

        for ( i in 0...6 ) {
            if ( !Math.isNaN(splitnum[i]) ) {
                resultnum += simplenum[splitnum[i]];
            } else if ( complexnum[splitnum[i]] ) {
                resultnum += complexnum[splitnum[i]];
            } else {
                throw new Error("Hex colors must only include hex numbers 0-9, and A-F");
            }
        }

        return '#' + resultnum;
    }
}
