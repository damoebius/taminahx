package org.tamina.log;

typedef L = QuickLogger;

class QuickLogger {

    public static var level:LogLevel = LogLevel.INFO;

    private static var _startProfilingDate:Date;

    public static function info(message:String, ?source:Dynamic):Void {
        if (level <= LogLevel.INFO) {
            log(LogLevel.INFO,message) ;
        }
    }

    public static function debug(message:String, ?source:Dynamic):Void {
        if (level <= LogLevel.DEBUG) {
            log(LogLevel.DEBUG,message);
        }
    }

    public static function warn(message:String, ?source:Dynamic):Void {
        if (level <= LogLevel.WARN) {
            log(LogLevel.WARN, message);
        }
    }

    public static function error(message:String, ?source:Dynamic):Void {
        if (level <= LogLevel.ERROR) {
            log(LogLevel.ERROR, message);
        }

    }

    public static function profile(start:Bool=false):Void {
        if (_startProfilingDate != null && !start) {
            debug('profling result : ' + ( Date.now().getTime() - _startProfilingDate.getTime() ) + ' ms');
        }
        _startProfilingDate = Date.now();
    }

    private static function log(level:LogLevel,message:String):Void{
        var prefix = Date.now().toString();


        #if (js && !nodejs)
        var console = js.Browser.console;
        #else
        var console  = nodejs.Console ;
         #end
        switch(level){
            case LogLevel.INFO: console.info(prefix +  " [INFO] " + message);
            case LogLevel.DEBUG: console.debug(prefix +  " [DEBUG] " + message);
            case LogLevel.WARN: console.warn(prefix +  " [WARN] " + message);
            case LogLevel.ERROR: console.error(prefix +  " [ERROR] " + message);
            case LogLevel.NONE: console.log(prefix +  " [NONE] " + message);
        }
    }


}