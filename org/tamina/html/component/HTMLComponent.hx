package org.tamina.html.component;

import js.html.HTMLElement;
import org.tamina.i18n.LocalizationManager;
import js.RegExp;
import org.tamina.utils.HTMLUtils;
import haxe.rtti.Meta;
import js.Browser;
import js.html.Element;

@:autoBuild(org.tamina.html.component.HTMLComponentFactory.build())

/**
 * HTMLComponent is the base class to build Custom Elements.
 * more info : http://happy-technologies.com/custom-elements-and-component-developement-en/
 * @class HTMLComponent
 * @extends HTMLElement
 */
class HTMLComponent extends HTMLElement {

    /**
     * Whether or not the display object is visible.
     * @property visible
     * @type Bool
     */
    public var visible(get, set):Bool;

    private var _visible:Bool = true;
    private var _tempElement:Element;
    private var _useExternalContent:Bool=false;
    private var _defaultDisplayStyle:String="";

    private function new() {
    }

    /**
	 * To instantiate dynamically a component from your application, like an itemRenderer for example, you can use a Factory available in HTMLComponent.
	 * @method createInstance
	 * @static
	 * @param	type {Class<T>} A string representing the event type to listen for.
	 * @return listener {T} The function that's called when an event of the specified type occurs.
	 * @example
	 *      var myComponent = HTMLComponent.createInstance(TestComponent);
	 *      Browser.document.body.appendChild(myComponent);
	 */
    public static function createInstance<T>(type:Class<T>):T {
        var className:String = Type.getClassName(type);
        className = className.toLowerCase().split('.').join('-');

        return cast Browser.document.createElement(className);
    }

    /**
	 * Called after the element is created.
	 * @method createdCallback
	 */
    public function createdCallback():Void {
        trace('createdCallback---------------->');
       // this();
        parseContent();
        initContent();
        displayContent();
    }

/**
	 * Called when the element is attached to the document
	 * @method attachedCallback
	 */
    public function attachedCallback():Void {
        trace('attachedCallback---------------->');
    }

/**
	 * Called when the element is detached from the document.
	 * @method detachedCallback
	 */
    public function detachedCallback():Void {
        trace('detachedCallback---------------->');
    }

/**
	 * Called when one of attributes of the element is changed.
	 * @method attributeChangedCallback
	 * @param	attrName {String} A string representing the attribute's name
	 * @param	oldVal {String} A string representing the old value.
	 * @param	newVal {String} A string representing the new value.
	 */
    public function attributeChangedCallback(attrName:String, oldVal:String, newVal:String):Void {
        trace('attributeChangedCallback---------------->'+attrName);
    }

    private function get_visible():Bool {
        return _visible;
    }

    private function set_visible(value:Bool):Bool {
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
