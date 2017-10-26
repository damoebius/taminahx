package org.tamina.utils;
import js.Error;

/**
* @class ColorUtils
**/
class ColorUtils {

    /**
    * @method invert
    * @param {String} color in hex format
    * @return {String}
    **/
    public static function invert(color:String):String {
        if (color.length != 7) {
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

        for (i in 0...6) {
            if (!Math.isNaN(splitnum[i])) {
                resultnum += simplenum[splitnum[i]];
            } else if (complexnum[splitnum[i]]) {
                resultnum += complexnum[splitnum[i]];
            } else {
                throw new Error("Hex colors must only include hex numbers 0-9, and A-F");
            }
        }

        return '#' + resultnum;
    }
}
