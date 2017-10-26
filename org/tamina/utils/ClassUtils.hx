package org.tamina.utils;
import js.Browser;

/**
* @class ClassUtils
**/
class ClassUtils {

    /**
    * Expose an object or a function in the window global env
    * @method expose
    * @static
    * @param {Dynamic} instance
    * @param {String} rootInstanceName
    **/
    public static function expose(instance:Dynamic,rootInstanceName:String):Void{
        Reflect.setField(Browser.window,rootInstanceName,instance);
    }
}
