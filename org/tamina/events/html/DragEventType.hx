package org.tamina.events.html;

/**
 * Drag API Events
 * @class DragEventType
 * @static
 */
class DragEventType {

    /**
     * This event is fired when an element or text selection is being dragged.
     * @property DRAG
     * @type String
     * @static
     * @readOnly
     */
    static public inline var DRAG:String='drag';

    /**
     * This event is fired when a drag operation is being ended (by releasing a mouse button or hitting the escape key).
     * @property DRAG_END
     * @type String
     * @static
     * @readOnly
     */
    static public inline var DRAG_END:String='dragend';

    /**
     * This event is fired when a dragged element or text selection enters a valid drop target.
     * @property DRAG_ENTER
     * @type String
     * @static
     * @readOnly
     */
    static public inline var DRAG_ENTER:String='dragenter';

    /**
     * This event is fired when an element is no longer the drag operation's immediate selection target.
     * @property DRAG_EXIT
     * @type String
     * @static
     * @readOnly
     */
    static public inline var DRAG_EXIT:String='dragexit';

    /**
     * This event is fired when a dragged element or text selection leaves a valid drop target.
     * @property DRAG_LEAVE
     * @type String
     * @static
     * @readOnly
     */
    static public inline var DRAG_LEAVE:String='dragleave';

    /**
     * This event is fired when an element or text selection is being dragged over a valid drop target (every few hundred milliseconds).
     * @property DRAG_OVER
     * @type String
     * @static
     * @readOnly
     */
    static public inline var DRAG_OVER:String='dragover';

    /**
     * This event is fired when the user starts dragging an element or text selection.
     * @property DRAG_START
     * @type String
     * @static
     * @readOnly
     */
    static public inline var DRAG_START:String='dragstart';

    /**
     * This event is fired when an element or text selection is dropped on a valid drop target.
     * @property DROP
     * @type String
     * @static
     * @readOnly
     */
    static public inline var DROP:String='drop';
}
