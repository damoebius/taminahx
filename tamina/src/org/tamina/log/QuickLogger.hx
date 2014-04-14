package org.tamina.log;

import mconsole.Console;

/**
 * ...
 * @author David Mouton
 */

class QuickLogger {

    public static var level:LogLevel = LogLevel.INFO;

    private static var _startProfilingDate:Date;

    public static function info(message:String, ?source:Dynamic):Void {
        if (level <= LogLevel.INFO) {
            Console.info(Date.now().toString() + ' [ INFO ] ' + message);
        }
    }

    public static function debug(message:String, ?source:Dynamic):Void {
        if (level <= LogLevel.DEBUG) {
            Console.debug(Date.now().toString() + ' [ DEBUG ] ' + message);
        }
    }

    public static function warn(message:String, ?source:Dynamic):Void {
        if (level <= LogLevel.WARN) {
            Console.warn(Date.now().toString() + ' [ WARN ] ' + message);
        }
    }

    public static function error(message:String, ?source:Dynamic):Void {
        if (level <= LogLevel.ERROR) {
            Console.error(Date.now().toString() + ' [ ERROR ] ' + message);
        }

    }

    public static function profile():Void {
        if (_startProfilingDate != null) {
            debug('profling result : ' + ( Date.now().getTime() - _startProfilingDate.getTime() ) + ' ms');
        }
        _startProfilingDate = Date.now();
    }


}