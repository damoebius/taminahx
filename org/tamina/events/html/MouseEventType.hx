package org.tamina.events.html;

/**
 * Mouse API Events
 * <br>
 * The MouseEvent interface represents events that occur due to the user interacting with a pointing device (such as a mouse). Common events using this interface include click, dblclick, mouseup, mousedown.
 * @class MouseEventType
 * @static
 */
class MouseEventType {

    /**
     * The click event is fired when a pointing device button (usually a mouse button) is pressed and released on a single element.
     * @property CLICK
     * @type String
     * @static
     * @readOnly
     */
    static public inline var CLICK:String='click';

    /**
     * The mousemove event is fired when a pointing device (usually a mouse) is moved while over an element.
     * @property MOUSE_MOVE
     * @type String
     * @static
     * @readOnly
     */
    static public inline var MOUSE_MOVE:String='mousemove';

    /**
     * The mousedown event is fired when a pointing device button (usually a mouse button) is pressed on an element.
     * @property MOUSE_DOWN
     * @type String
     * @static
     * @readOnly
     */
    static public inline var MOUSE_DOWN:String='mousedown';

    /**
     * The mouseup event is fired when a pointing device button (usually a mouse button) is released over an element.
     * @property MOUSE_UP
     * @type String
     * @static
     * @readOnly
     */
    static public inline var MOUSE_UP:String='mouseup';

    /**
     * The mouseout event is fired when a pointing device (usually a mouse) is moved off the element that has the listener attached or off one of its children.
     * @property MOUSE_OUT
     * @type String
     * @static
     * @readOnly
     */
    static public inline var MOUSE_OUT:String='mouseout';

    /**
     * The mouseover event is fired when a pointing device is moved onto the element that has the listener attached or onto one of its children.
     * @property MOUSE_OVER
     * @type String
     * @static
     * @readOnly
     */
    static public inline var MOUSE_OVER:String='mouseover';

    /**
     * The scroll event is fired when the document view or an element has been scrolled.
     * @property SCROLL
     * @type String
     * @static
     * @readOnly
     */
    static public inline var SCROLL:String='scroll';
}
