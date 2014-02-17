package org.tamina.geom;
class Junction extends Point {

    public var links:Array<Junction>;
    public var id:String;

    public function new(x:Float = 0, y:Float = 0, id:String="") {
        super(x,y);
        this.links = new Array<Junction>();
        this.id = id;
    }

}
