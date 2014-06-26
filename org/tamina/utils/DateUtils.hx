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
* @class DateUtils
* @constructor
*/
class DateUtils {

/**
     * Convertie une date en chaine au format HHhMM
     * @param pDate
     * @return
     */
    public static function hourToFrenchString(pDate:Date):String {
        var result:String = "";
        var hours:String = Std.string(pDate.getHours());
        if (pDate.getHours() < 10) {
            hours = "0" + hours;
        }
        var minutes:String = Std.string(pDate.getMinutes());
        if (pDate.getMinutes() < 10) {
            minutes = "0" + minutes;
        }
        result = hours + "h" + minutes;
        return result;
    }

/**
		 *Retourne une date au format jj/mm/aaaa
		 * @param maDate
		 * @return
		 *
		 */

    public static function toFrenchString(pDate:Date):String {
        var month:String = Std.string( pDate.getMonth() + 1 );
        if (pDate.getMonth() < 9) {
            month = "0" + month;
        }
        var day:String = Std.string(pDate.getDate());
        if (pDate.getDate() < 10) {
            day = "0" + day;
        }
        return day + "/" + month + "/" + pDate.getFullYear();

    }
}
