package org.tamina.geom;

/**
 * Junction object. Useful to make a 2D mesh
 * @class Junction
 * @extends Point
 */
class Junction extends Point {

/**
 * @property links
 * @type Array<{Junction}>
 */
    public var links:Array<Junction>;

/**
 * @property id
 * @type String
 */
    public var id:String;

/**
    * @constructor
    * @method new
    * @param [x] {Float}
    * @param [y] {Float}
    * @param [id] {String}
    */
    public function new(x:Float = 0, y:Float = 0, id:String="") {
        super(x,y);
        this.links = new Array<Junction>();
        this.id = id;
    }

}
