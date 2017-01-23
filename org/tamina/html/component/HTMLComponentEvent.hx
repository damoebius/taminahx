package org.tamina.html.component;

import js.Browser;
import js.html.Event;
import js.html.EventInit;

/**
* The HTMLComponentEvent class defines events that are associated with the HTMLComponent class.
*
*     var myComponent:TestComponent = HTMLComponent.createInstance(TestComponent);
*
*     myComponent.addEventListener(HTMLComponentEventType.CREATION_COMPLETE, myComponent_creationCompleteHandler);
*
* @class HTMLComponentEvent
* @extends js.html.Event
* @module Tamina
*/
@:native("Event")
extern class HTMLComponentEvent extends Event {
    public function new(type:HTMLComponentEventType, ?eventInitDict:EventInit):Void;
}

class HTMLComponentEventFactory{
    public static function createEvent(type:HTMLComponentEventType, ?bubbles:Bool = true):HTMLComponentEvent{
        var result:HTMLComponentEvent = cast Browser.document.createEvent('Event');
        result.initEvent(type,bubbles,true);
        return result;
    }
}

/**
* Enum for HTMLComponentEvent types
* @class HTMLComponentEventType
*/
@:enum abstract HTMLComponentEventType(String) from String to String {

    /** Dispatched when the component has finished its construction and has all initialization properties set.
     *
     * @property CREATION_COMPLETE
     * @type HTMLComponentEventType
     * @static
     * @readOnly
     */
    public var CREATION_COMPLETE = "creationComplete";

    /** Dispatched when the component has finished its construction, property processing, measuring, layout, and drawing.
     *
     * @property INITIALIZE
     * @type HTMLComponentEventType
     * @static
     * @readOnly
     */
    public var INITIALIZE = "initialize";

}
