package org.tamina.log;

import js.html.DivElement;
import js.Browser;
import haxe.PosInfos;
import mconsole.LogLevel;
import mconsole.Printer;

/**
 * The DivPrinter class is used by mconsole.Console to output logs into a DIV Element. This DIV must have the id='debugDiv' attribute <br>
 *
 * @module Tamina
 * @class DivPrinter
 * @extends mconsole.Printer
 */
class DivPrinter implements Printer {
    public function new() {
    }

    public function print(level:LogLevel, params:Array<Dynamic>, indent:Int, pos:PosInfos):Void
    {
        var div:DivElement =  cast Browser.document.getElementById('debugDiv');
        if (div != null) {
            div.innerHTML += Std.string(level) + "@" + pos.className + "." + pos.methodName + ":" + params.join(", ") + '<br/>';
        }
    }
}
