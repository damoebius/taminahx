package org.tamina.geom;

/**
 * Point object
 * @class Point
 */
class Point {

/**
 * @property x
 * @type Float
 */
    public var x:Float;

/**
 * @property y
 * @type Float
 */
    public var y:Float;

/**
    * @constructor
    * @method new
    * @param [x] {Float}
    * @param [y] {Float}
    */
    public function new(x:Float = 0, y:Float = 0) {
        this.x = x;
        this.y = y;
    }
}
