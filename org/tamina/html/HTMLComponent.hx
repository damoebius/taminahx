package org.tamina.html;

import org.tamina.i18n.LocalizationManager;
import js.RegExp;
import org.tamina.utils.HTMLUtils;
import haxe.rtti.Meta;
import js.Browser;
import js.html.Element;
@:autoBuild(org.tamina.html.HTMLComponentFactory.build())
class HTMLComponent {

    public inline static var CONTENT_TAG:String = 'content';

    public var parent:Element;
    public var element:Element;

    public var visible(get, set):Bool;

    private var _visible:Bool = true;
    private var _tempElement:Element;
    private var _useExternalContent:Bool=false;

    public function new(?parent:Element):Void {
        if (parent != null) {
            this.parent = parent;
            parseContent();
            initContent();
            displayContent();
        }
    }


    public function get_visible():Bool {
        return _visible;
    }

    public function set_visible(value:Bool):Bool {
        _visible = value;
        if (_visible) {
            parent.style.display = 'block';
        } else {
            parent.style.display = 'none';
        }
        return _visible;
    }

    public function addToElement(parent:Element):Void{
        this.parent = parent;
        parseContent(false);
        initContent();
        displayContent();
    }
    private function parseContent(useExternalContent:Bool=true):Void {
        if (parent.childElementCount == 0 || !useExternalContent) {
            _tempElement = Browser.document.createDivElement();
            _tempElement.innerHTML = getContent();
        } else {
            _useExternalContent=true;
            _tempElement = parent;
        }
        translateContent(_tempElement);
        initSkinParts(_tempElement);
    }

    private function initSkinParts(target:Element):Void {
        var meta = Meta.getFields(Type.getClass(this));
        var metaFields = Reflect.fields(meta);
        var classFields = Reflect.fields(this);
        for (i in 0...metaFields.length) {
            var field = Reflect.field(meta, metaFields[i]);
            if (field.skinpart != null) {
                var element = HTMLUtils.getElementByAttribute(target, 'data-id', metaFields[i]);
                Reflect.setField(this, metaFields[i], element);
            }
        }
    }

    private function translateContent(target:Element):Void {
        var html = target.innerHTML;
        var stringToTranslate = new RegExp('\\{\\{(?!\\}\\})(.+)\\}\\}', 'gim');
        var results:Array<Array<String>> = new Array<Array<String>>();
        var result:Array<String> = new Array<String>();
        var i = 0;

        while ((result = stringToTranslate.exec(html)) != null) {
            results[i] = result;
            i++;
        }

        result = new Array<String>();
        for (result in results) {
            var totalString = result[0];
            var key = StringTools.trim(result[1]);
            html = StringTools.replace(html, totalString, LocalizationManager.instance.getString(key));
        }

        target.innerHTML = html;
    }

    private function initContent():Void {

    }

    private function displayContent():Void {
        element = _tempElement;
        var numChildren = _tempElement.children.length;
        if (numChildren == 1) {
            element = _tempElement.firstElementChild;
        } else {
            element = parent;
        }
        if(!_useExternalContent){
            while (numChildren > 0) {
                numChildren--;
                var item:Element = cast _tempElement.children.item(0);
                parent.appendChild(item);
            }
        }
    }

    private function getContent():String {
        return untyped this.view;
    }

}
