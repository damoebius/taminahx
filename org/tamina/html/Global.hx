package org.tamina.html;
import js.Browser;

/**
 * Global object give an accès to Window element
 * @class Global
 * @module Tamina
 */
class Global {

    private static var _instance:Global;

    private var _global:Dynamic;

    /**
    * @method getInstance
    * @static
    * @return {Global} a reference to Window Element
    */
    public static function getInstance():Global{
       if(_instance == null){
            _instance = new Global();
       }
        return _instance;
    }

    private function new(){
        _global = Browser.window;
    }

    /**
    * Call a dynamic function and return the result
    * @method call
    * @param hostFunction {String} the name of the function to call
    * @param args Array<{Dynamic}>  arguments list
    * @return {Dynamic} the call result
    * @example
     *      Global.getInstance().call('myFunction',[1,false]);
     *
    */
    public function call(hostFunction:String, args : Array<Dynamic>):Dynamic{
        return Reflect.callMethod(_global, Reflect.field(_global, hostFunction), args);
    }
}
