package org.tamina.html;
import js.Browser;
class Global {

    private static var _instance:Global;

    private var _global:Dynamic;

    public static function getInstance():Global{
       if(_instance == null){
            _instance = new Global();
       }
        return _instance;
    }

    private function new(){
        _global = Browser.window;
    }

    public function call(hostFunction:String, args : Array<Dynamic>):Void{
        Reflect.callMethod(_global, Reflect.field(_global, hostFunction), args);
    }
}
