package org.tamina.utils;
class ColorUtils {
    /**
       * convert a color number to hex value
       * ex 1677845 -> #FF5500
     */
    public static function decColor2hex(color:Float):String {
        var colArr = color.toString(16).toUpperCase().split('');
        var numChars = colArr.length;
        for (a in 0...(6 - numChars)) {
            colArr.unshift("0");
        }
        return('#' + colArr.join(''));
    }
}
