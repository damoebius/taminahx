package org.tamina.events.html;

/**
 * Input API Events
 * @class InputEventType
 * @static
 */
class InputEventType {

    /**
     * The DOM input event is fired synchronously when the value of an input or textarea element is changed. Additionally, it fires on contenteditable editors when its contents are changed. In this case, the event target is the editing host element. If there are two or more elements which have contenteditable as true, "editing host" is the nearest ancestor element whose parent isn't editable. Similarly, it's also fired on root element of designMode editors.
     * @property INPUT
     * @type String
     * @static
     * @readOnly
     */
    static public inline var INPUT:String='input';

    /**
     * The change event is fired for input, select, and textarea elements when a change to the element's value is committed by the user. Unlike the input event, the change event is not necessarily fired for each change to an element's value.
     * @property CHANGE
     * @type String
     * @static
     * @readOnly
     */
    static public inline var CHANGE:String='change';
}
