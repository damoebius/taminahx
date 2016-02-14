package org.tamina.html.component;

import js.Browser;

/**
 * HTMLApplication. Tamina defines a default, or Application, container that lets you start adding content to your application without explicitly defining another container.
 * more info : http://happy-technologies.com/custom-elements-and-component-developement-en/
 * @class HTMLApplication
 */
class HTMLApplication {

    public static var componentsClassList:Array<String> = [];

/**
    * @constructor
    * @method new
    * @example
    *   package ;
    *
    *   import org.tamina.html.component.HTMLApplication;
    *
    *   class Main extends HTMLApplication{
    *
    *       private static var _instance:Main;
    *
    *       public function new():Void {
    *           super();
    *           loadComponents();
    *       }
    *
    *       public static function main():Void {
    *
    *           _instance = new Main();
    *       }
    *
    *   }
    */
    public function new() {

    }

/**
	 * HTMLApplication has a loadComponents() function that registers ALL components used by the application. Thanks to macros, components are automatically registered while compiling. So there’s no need to do it manually or with the Reflexion API at runtime.
	 * @method loadComponents
	 */
    public function loadComponents():Void{
        for(className in HTMLApplication.componentsClassList){
            var componentName = className.toLowerCase().split('.').join('-');
            var componentClass = Type.resolveClass(className);
            Browser.document.registerElement(componentName, cast componentClass);
        }
    }
}
