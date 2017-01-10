package org.tamina.html.component;

import js.Browser;

/**
 * HTMLApplication.
 * <br>
 * Tamina defines a default, or Application, container that lets you start adding content to your application without explicitly defining another container.<br>
 * more info : http://happy-technologies.com/custom-elements-and-component-developement-en/
 *
 *     package ;
 *
 *     import org.tamina.html.component.HTMLApplication;
 *
 *     class Main extends HTMLApplication {
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
 *     }
 *
 * ## Polyfills
 * Browsers don’t support Custom Elements very well.<br>
 * ![Compatibility](http://happy-technologies.com/wp-content/uploads/2015/12/ce1-1024x256.jpg "Compatibility")<br>
 * To make them compatible we used [webcomponent.js](https://github.com/WebComponents/webcomponentsjs "webcomponent.js")<br>
 * An optimized and minified version of 15Kb is available on our CDN:
 * [cdn](http://storage.sakuradesigner.microclimat.com/apps/html5/js/CustomElements.min.js "here").
 * @class HTMLApplication
 */
class HTMLApplication {

    public static var componentsXTagList(get, null):Dynamic<String> = null;

    private static function get_componentsXTagList():Dynamic<String> {
        if (componentsXTagList == null) {
            componentsXTagList = {};
        }

        return componentsXTagList;
    }

    /**
    * @constructor
    * @method new
    * @example
    *
    *     package ;
    *
    *     import org.tamina.html.component.HTMLApplication;
    *
    *     class Main extends HTMLApplication{
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
    *     }
    */
    public function new() {}

    /**
     * HTMLApplication has a loadComponents() function that registers ALL components used by the application.
     * Thanks to macros, components are automatically registered while compiling.
     * So there’s no need to do it manually or with the Reflexion API at runtime.
     *
     * @method loadComponents
     */
    public inline function loadComponents():Void {
        var customElements = untyped Browser.window.customElements;

        for (tag in Reflect.fields(componentsXTagList)) {
            var componentClass = Type.resolveClass(Reflect.field(componentsXTagList, tag));
            customElements.define(tag, componentClass);
        }

        // Issue a warning for any custom element present on the DOM without being defined
        var unknownCustomElements = Browser.document.querySelectorAll(":not(:defined)");
        for (el in unknownCustomElements) {
            Browser.console.warn("Custom element not defined: " + el.nodeName);
        }
    }

    public static function createInstance<T>(type:Class<T>):T {
        var className:String = Type.getClassName(type);
        var tag = getTagByClassName(className);
        return cast Browser.document.createElement(tag);
    }

    public static function isCustomElement(nodeName:String):Bool {
        return Reflect.hasField(componentsXTagList, nodeName.toLowerCase());
    }

    private static function getTagByClassName(className:String):String {
        var result:String = "";

        for (tag in Reflect.fields(componentsXTagList)) {
            var value = Reflect.field(componentsXTagList, tag);
            if (value == className) {
                result = tag;
                break;
            }
        }

        return result;
    }
}
