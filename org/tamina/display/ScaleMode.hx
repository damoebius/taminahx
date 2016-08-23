package org.tamina.display;

/**
 * ScaleMode
 * The ScaleMode class defines an enumeration for the scale modes that determine how a Image scales image content when fillMode is set to FillMode.SCALE.
 * @class ScaleMode
 * @module Tamina
 * @enum
 */

@:enum abstract ScaleMode(String) from String to String {

    /**
	 * @property LETTERBOX
	 *  The bitmap fill is scaled while maintaining the aspect ratio of the original content.
	 * @type ScaleMode
	 * @static
	 * @readOnly
	 */
    var LETTERBOX:String = 'letterbox';

	/**
	 * @property STRETCH
	 *  The bitmap fill stretches to fill the region.
	 * @type ScaleMode
	 * @static
	 * @readOnly
	 */
    var STRETCH:String = 'stretch';

    /**
	 * @property ZOOM
	 *  The bitmap fill is scaled and cropped such that the aspect ratio of the original content is maintained and no letterbox or pillar box is displayed.
	 * @type ScaleMode
	 * @static
	 * @readOnly
	 */
    var ZOOM:String = 'zoom';
}
