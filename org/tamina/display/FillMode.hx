package org.tamina.display;

/**
 * FillMode
 * The FillMode  class defines an enumeration of the resize modes that determine how a BitmapImage fills in the dimensions specified by the layout system.
 * @class FillMode
 * @module Tamina
 * @enum
 */

@:enum abstract FillMode(String) from String to String {

    /**
 * @property CLIP
 *  The bitmap ends at the edge of the region.
 * @type FillMode
 * @static
 * @readOnly
 */
    var CLIP:String = 'clip';

/**
 * @property REPEAT
 *  The bitmap is repeated to fill the region.
 * @type FillMode
 * @static
 * @readOnly
 */
    var REPEAT:String = 'repeat';

    /**
 * @property SCALE
 *  The bitmap fill stretches to fill the region.
 * @type FillMode
 * @static
 * @readOnly
 */
    var SCALE:String = 'scale';
}
