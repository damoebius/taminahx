package org.tamina.display;

@:enum abstract BackgroundSizing(Int) from Int to Int {
    var AUTO:Int = 0x100;
    var COVER:Int = 0x200;
    var CONTAIN:Int = 0x300;
}
