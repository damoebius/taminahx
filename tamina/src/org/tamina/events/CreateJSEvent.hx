package org.tamina.events;


class CreateJSEvent {

    private static function get_BITMAP_LOAD():String { return "load"; }

    static public var BITMAP_LOAD(get_BITMAP_LOAD, null):String;

    private static function get_MOUSE_UP():String { return "pressup"; }

    static public var MOUSE_UP(get_MOUSE_UP, null):String;

    private static function get_MOUSE_MOVE():String { return "pressmove"; }

    static public var MOUSE_MOVE(get_MOUSE_MOVE, null):String;

    private static function get_MOUSE_DOWN():String { return "mousedown"; }

    static public var MOUSE_DOWN(get_MOUSE_DOWN, null):String;

    private static function get_TICKER_TICK():String { return "tick"; }

    static public var TICKER_TICK(get_TICKER_TICK, null):String;

    private static function get_STAGE_MOUSE_UP():String { return "stagemouseup"; }

    static public var STAGE_MOUSE_UP(get_STAGE_MOUSE_UP, null):String;

    private static function get_STAGE_MOUSE_MOVE():String { return "stagemousemove"; }

    static public var STAGE_MOUSE_MOVE(get_STAGE_MOUSE_MOVE, null):String;
}
