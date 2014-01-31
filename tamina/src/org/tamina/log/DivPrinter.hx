package org.tamina.log;

import js.html.DivElement;
import js.Browser;
import haxe.PosInfos;
import mconsole.LogLevel;
import mconsole.Printer;

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
