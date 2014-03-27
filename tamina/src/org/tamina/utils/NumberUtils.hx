/*
* SakuraEditor
* Visit http://storage.sakuradesigner.microclimat.com/apps/api/ for documentation, updates and examples.
*
* Copyright (c) 2014 microclimat, inc.
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/
package org.tamina.utils;

/**
* This is the description for my class.
* @author d.mouton
* @class NumberUtils
* @constructor
*/
class NumberUtils {

    inline public static function toFixed(x:Float, decimalPlaces:Int):String {
        if (Math.isNaN(x))
            return "NaN";
        else {
            var t = exp(10, decimalPlaces);
            var s = Std.string(Std.int(x * t) / t);
            var i = s.indexOf(".");
            if (i != -1) {
                for (i in s.substr(i + 1).length...decimalPlaces)
                    s += "0";
            }
            else {
                s += ".";
                for (i in 0...decimalPlaces)
                    s += "0";
            }
            return s;
        }
    }

/**
		 * Arroudi à un nombre de chiffre apres la virgule
		 * @param numIn
		 * @param decimalPlaces
		 * @return
		 *
		 */

    inline public static function roundDec(numIn:Float, decimalPlaces:Int):Float {
        var nExp = Math.pow(10, decimalPlaces);
        var nRetVal = Math.round(numIn * nExp) / nExp;
        return nRetVal;
    }

    inline public static function exp(a:Int, n:Int):Int {
        var t = 1;
        var r = 0;
        while (true) {
            if (n & 1 != 0) t = a * t;
            n >>= 1;
            if (n == 0) {
                r = t;
                break;
            }
            else
                a *= a;
        }
        return r;
    }

}
