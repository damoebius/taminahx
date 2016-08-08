package org.tamina.events.html;

/**
 * Focus API Events
 * @class FocusEventType
 * @static
 */
class FocusEventType {

    /**
     * The focus event is fired when an element has received focus. The main difference between this event and focusin is that only the latter bubbles.
     * @property FOCUS
     * @type String
     * @static
     * @readOnly
     */
    static public inline var FOCUS:String='focus';

    /**
     * The blur event is fired when an element has lost focus. The main difference between this event and focusout is that only the latter bubbles.
     * @property BLUR
     * @type String
     * @static
     * @readOnly
     */
    static public inline var BLUR:String='blur';
}
