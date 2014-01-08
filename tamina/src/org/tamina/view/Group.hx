package org.tamina.view;

import createjs.easeljs.Sprite;
import createjs.easeljs.DisplayObject;

class Group<T : (DisplayObject) > extends Sprite {

    public function new() {
        super();
    }

    public function addElement(element:T):Void {
        this.addChild(element);
    }

    public function getElementAt(index:Int):T {
        return cast getChildAt(index);
    }
}
