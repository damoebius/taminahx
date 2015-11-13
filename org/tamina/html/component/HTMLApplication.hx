package org.tamina.html.component;

import js.Browser;
class HTMLApplication {

    public static var componentsClassList:Array<String> = [];

    public function new() {

    }

    public function loadComponents():Void{
        for(className in HTMLApplication.componentsClassList){
            var componentName = className.toLowerCase().split('.').join('-');
            var componentClass = Type.resolveClass(className);
            Browser.document.registerElement(componentName, cast componentClass);
        }
    }
}
