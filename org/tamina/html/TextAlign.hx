package org.tamina.html;

/**
* Enum for TextAlign values
* @class TextAlign
*/
@:enum abstract TextAlign(String) from String to String {
/** Specifies start edge alignment - text is aligned to match the writing order. Equivalent to setting 
		 * left in left-to-right text, or right in right-to-left text.
		 *
     * @property START
     * @type String
     * @static
     * @readOnly
		 */

    public var START = "start";

/** Specifies end edge alignment - text is aligned opposite from the writing order. Equivalent to 
		 *  specifying right in left-to-right text, or left in right-to-left text. 
		 *
     * @property END
     * @type String
     * @static
     * @readOnly
		 */

    public var END = "end";

/** Specifies left edge alignment. 
		 *
     * @property LEFT
     * @type String
     * @static
     * @readOnly
		 */

    public var LEFT = "left";

/** Specifies right edge alignment. 
		 *
     * @property RIGHT
     * @type String
     * @static
     * @readOnly
		 */

    public var RIGHT = "right";

/** Specifies center alignment within the container.
		 *
     * @property CENTER
     * @type String
     * @static
     * @readOnly
		 */

    public var CENTER = "center";

/** Specifies that text is justified within the lines so they fill the container space.
		 *
     * @property JUSTIFY
     * @type String
     * @static
     * @readOnly
		 */

    public var JUSTIFY = "justify";

}
