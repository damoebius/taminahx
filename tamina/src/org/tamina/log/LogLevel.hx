package org.tamina.log;
@:enum abstract LogLevel(Int) from Int to Int {

    var INFO = 0;
    var DEBUG = 1;
    var WARN = 2;
    var ERROR = 3;

    @:op(A<=B) public function compareMinusOrEqual(target:Int):Bool{ return this <= target;}

}
