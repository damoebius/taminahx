package org.tamina.html.component;

import js.html.HTMLElement;
import org.tamina.i18n.LocalizationManager;
import js.RegExp;
import org.tamina.utils.HTMLUtils;
import haxe.rtti.Meta;
import js.Browser;
import js.html.Element;

@:autoBuild(org.tamina.html.component.HTMLComponentFactory.build())
class HTMLComponent extends HTMLElement {

    public var visible(get, set):Bool;

    private var _visible:Bool = true;
    private var _tempElement:Element;
    private var _useExternalContent:Bool=false;
    private var _defaultDisplayStyle:String="";

    private function new() {
    }

    public static function createInstance<T>(type:Class<T>):T {
        var className:String = Type.getClassName(type);
        className = className.toLowerCase().split('.').join('-');

        return cast Browser.document.createElement(className);
    }

    public function createdCallback() {
        trace('createdCallback---------------->');
       // this();
        parseContent();
        initContent();
        displayContent();
    }

    public function attachedCallback() {
        trace('attachedCallback---------------->');
    }

    public function detachedCallback() {
        trace('detachedCallback---------------->');
    }

    public function attributeChangedCallback(attrName:String, oldVal:String, newVal:String) {
        trace('attributeChangedCallback---------------->'+attrName);
    }

    public function get_visible():Bool {
        return _visible;
    }

    public function set_visible(value:Bool):Bool {
        _visible = value;
        if(_defaultDisplayStyle == ""){
            _defaultDisplayStyle = this.style.display;
            if(_defaultDisplayStyle == ""){
                _defaultDisplayStyle = "block";
            }
        }
        if (_visible) {
            this.style.display = _defaultDisplayStyle;
        } else {
            this.style.display = 'none';
        }
        return _visible;
    }

    private function getContent():String {
        return untyped this.getView();
    }

    private function parseContent(useExternalContent:Bool=true):Void {
        if (this.childElementCount == 0 || !useExternalContent) {
            _tempElement = Browser.document.createDivElement();
            _tempElement.innerHTML = getContent();
        } else {
            _useExternalContent=true;
            _tempElement = this;
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
        var numChildren = _tempElement.children.length;
        if(!_useExternalContent){
            while (numChildren > 0) {
                numChildren--;
                var item:Element = cast _tempElement.children.item(0);
                this.appendChild(item);
            }
        }
    }
}
