package org.tamina.events;
class XMLHttpRequestEvent {


    private static function get_PROGRESS():String { return "progress"; }

    static public var PROGRESS(get_PROGRESS, null):String;

    private static function get_LOAD():String { return "load"; }

    static public var LOAD(get_LOAD, null):String;

    private static function get_ERROR():String { return "error"; }

    static public var ERROR(get_ERROR, null):String;

}
