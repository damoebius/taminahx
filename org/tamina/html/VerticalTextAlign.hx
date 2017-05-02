package org.tamina.html;

/**
* Enum for Vertical Text Align values
* @class VerticalTextAlign
*/
@:enum abstract VerticalTextAlign(String) from String to String {
/** Align the top of the element and its descendants with the top of the entire line.
     * @property TOP
     * @type String
     * @static
     * @readOnly
		 */

    public var TOP = "top";

/** Align the bottom of the element and its descendants with the bottom of the entire line.
     * @property BOTTOM
     * @type String
     * @static
     * @readOnly
		 */

    public var BOTTOM = "bottom";


/** Specifies center alignment within the container.
		 *
     * @property CENTER
     * @type String
     * @static
     * @readOnly
		 */

    public var CENTER = "center";


}
