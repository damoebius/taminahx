package org.tamina.view;

import createjs.easeljs.Container;
import createjs.easeljs.DisplayObject;

class Group<T : (DisplayObject) > extends Container {

    public function new() {
        super();
    }

    public function addElement(element:T):Void {
        this.addChild(element);
    }

    public function addElementAt(element:T, index:Float):Void {
        this.addChildAt(element,index);
    }

    public function getElementAt(index:Int):T {
        return cast getChildAt(index);
    }
}
