package org.tamina.utils;
import js.Browser;
class ClassUtils {

    public static function expose(instance:Dynamic,rootInstanceName:String):Void{
        //untyped __js__("window."+rootInstanceName+" = " + instance);
        Reflect.setField(Browser.window,rootInstanceName,instance);
    }
}
