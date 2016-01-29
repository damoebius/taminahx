package org.tamina.display;

/**
 * Pre builded ColorMatrix
 * @class ColorMatrix
 * @static
 */
class ColorMatrix {

/**
 * @property BANDW_MATRIX
 * @type Float[]
 * @static
 * @readOnly
 */
    static public var BANDW_MATRIX(get,null):Array<Float>;

/**
 * @property NEGATIVE_MATRIX
 * @type Float[]
 * @static
 * @readOnly
 */
    static public var NEGATIVE_MATRIX(get,null):Array<Float>;

/**
 * @property SEPIA_MATRIX
 * @type Float[]
 * @static
 * @readOnly
 */
    static public var SEPIA_MATRIX(get,null):Array<Float>;


    static private function get_BANDW_MATRIX():Array<Float>{
        return  [
        0.2225, 0.7169, 0.0606, 0, 0,
        0.2225, 0.7169, 0.0606, 0, 0,
        0.2225, 0.7169, 0.0606, 0, 0,
        0, 0, 0, 1, 0
        ];
    }

    static private function get_NEGATIVE_MATRIX():Array<Float>{
        return  [
        -1, 0, 0, 0, 255,
        0, -1, 0, 0, 255,
        0, 0, -1, 0, 255,
        0, 0, 0, 1, 0
        ];
    }
    static private function get_SEPIA_MATRIX():Array<Float>{
        return  [
        0.3930000066757202, 0.7689999938011169, 0.1889999955892563, 0, 0,
        0.3490000069141388, 0.6859999895095825, 0.1679999977350235, 0, 0,
        0.2720000147819519, 0.5339999794960022, 0.1309999972581863, 0, 0,
        0, 0, 0, 1, 0,
        0, 0, 0, 0, 1
        ];
    }



}
