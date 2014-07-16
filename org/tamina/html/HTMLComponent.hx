package org.tamina.html;

import js.Browser;
import js.html.Element;
@:autoBuild(org.tamina.html.HTMLComponentFactory.build())
class HTMLComponent {

    public inline static var CONTENT_TAG:String='content';

    public var parent:Element;

    public var visible(get,set):Bool;

    private var _visible:Bool=true;
    private var _tempElement:Element;

    public function new(?parent:Element):Void {
        if (parent != null) {
            this.parent = parent;
            parseContent();
            initContent();
            displayContent();
        }
    }

    public function get_visible():Bool{
        return _visible;
    }
    public function set_visible(value:Bool):Bool{
        _visible = value;
        if(_visible){
            parent.style.display='block';
        } else {
            parent.style.display='none';
        }
        return _visible;
    }

    private function  parseContent():Void{
        _tempElement = Browser.document.createDivElement();
        _tempElement.innerHTML = getContent();
    }

    private function  initContent():Void{

    }

    private function  displayContent():Void{
        var content = _tempElement.getElementsByTagName(CONTENT_TAG)[0];
        if(content == null){
            content = _tempElement.firstChild;
        }
        parent.appendChild(content);
    }

    private function getContent():String{
        return untyped this.view;
    }

}
