package org.tamina.events.html;

/**
     * Touch API Events
     * <br>
     * The TouchEvent interface represents an event sent when the state of contacts with a touch-sensitive surface changes. This surface can be a touch screen or trackpad, for example. The event can describe one or more points of contact with the screen and includes support for detecting movement, addition and removal of contact points, and so forth.
     * @class TouchEventType
     * @static
     */
class TouchEventType {

/**
     * The touchcancel event is fired when a touch point has been disrupted in an implementation-specific manner (for example, too many touch points are created).
     * @property CANCEL
     * @type String
     * @static
     * @readOnly
     */
    static public inline var CANCEL:String='touchcancel';

/**
     * The touchend event is fired when a touch point is removed from the touch surface.
     * @property END
     * @type String
     * @static
     * @readOnly
     */
    static public inline var END:String='touchend';

/**
     * The touchenter event is fired when a touch point is moved onto the interactive area of an element.
     * @property ENTER
     * @type String
     * @static
     * @readOnly
     */
    static public inline var ENTER:String='touchenter';

/**
     * The touchleave event is fired when a touch point is moved off the interactive area of an element.
     * @property LEAVE
     * @type String
     * @static
     * @readOnly
     */
    static public inline var LEAVE:String='touchleave';

/**
     * The touchmove event is fired when a touch point is moved along the touch surface.
     * @property MOVE
     * @type String
     * @static
     * @readOnly
     */
    static public inline var MOVE:String='touchmove';

/**
     * The touchstart event is fired when a touch point is placed on the touch surface.
     * @property START
     * @type String
     * @static
     * @readOnly
     */
    static public inline var START:String='touchstart';
}
