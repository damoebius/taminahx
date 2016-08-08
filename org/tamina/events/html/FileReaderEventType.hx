package org.tamina.events.html;

/**
 * FileReader API Events
 * <br>
 * DOM Events are sent to notify code of interesting things that have taken place.
 * @class FileReaderEventType
 * @static
 */
class FileReaderEventType {

    /**
     * The loadend event is fired when progression has stopped (after "error", "abort" or "load" have been dispatched).
     * @property LOAD_END
     * @type String
     * @static
     * @readOnly
     */
    static public inline var LOAD_END:String='loadend';
}
