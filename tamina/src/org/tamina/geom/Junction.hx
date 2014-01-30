package org.tamina.geom;
class Junction extends Point {

    public var links:Array<Junction>;

    public function new(x:Float = 0, y:Float = 0) {
        super(x,y);
        links = new Array<Junction>();
    }

}
