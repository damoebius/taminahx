package org.tamina.html.component;

import org.tamina.html.component.HTMLComponentEvent.HTMLComponentEventType;
import js.html.Event;
import js.html.HtmlElement;
import org.tamina.i18n.LocalizationManager;
import js.RegExp;
import org.tamina.utils.HTMLUtils;
import haxe.rtti.Meta;
import js.Browser;
import js.html.Element;

@:autoBuild(org.tamina.html.component.HTMLComponentFactory.build())

/**
 * HTMLComponent is the base class to build Custom Elements.<br>
 * ## x-tag
 * HTMLComponent now extends HTMLElement. That means we can deal with components in an easier way (like DOM elements).<br>
 * The other change is it officially supports Custom Elements. It’s now possible to instantiate HTMLComponent in their view.
 *
 *     <html-view-othertestcomponent data-id="_otherComponent"></html-view-othertestcomponent>
 *
 * The tag name is made from your component namespace and classname. In the previous example, our component is *html.view.OtherTestComponent*<br>
 * ## Life cycle
 * Our component life cycle is the same as Custom Elements.
*
* public function  createdCallback() //Called after the element is created.
*
* public function  attachedCallback() //Called when the element is attached to the document
*
* public function  detachedCallback() //Called when the element is detached from the document.
*
* public function  attributeChangedCallback(attrName:String, oldVal:String, newVal:String) //Called when one of attributes of the element is changed.
*
* You can override them if you need it.<br>
* ## Skin Parts
* Another usefull feature is Skin Part support. This metadata is used to reference an element from his view. You don’t need to do it yourself anymore, A macro will automatically do it while compiling.<br>
* This technique was inspired by Flex4 Spark components architecture.
*
*     \@view('html/view/TestComponent.html')
*     class TestComponent extends HTMLComponent {
*
*         \@skinpart("")
*         private var _otherComponent:OtherTestComponent;
*
*         override public function attachedCallback() {
*             _otherComponent.displayHellWorld();
*         }
*
*     }
*
* ## View
* This metadata is used to link an HTML file as the view part of your component. In the previous exemple, TestComponent.html is used to describe the view structure.
*
*      <div>
*         \{{title}}
*     </div>
*
*     <html-view-othertestcomponent data-id="_otherComponent"></html-view-othertestcomponent>
 * more info : http://happy-technologies.com/custom-elements-and-component-developement-en/
 * @class HTMLComponent
 * @extends js.html.HTMLElement
 */
class HTMLComponent extends HtmlElement {

/**
     * Whether or not the display object is visible.
     * @property visible
     * @type Bool
     */
    public var visible(get, set):Bool;

/**
     * Whether or not the display object is initialized.
     * @property initialized
     * @type Bool
     */
    public var initialized(default, null):Bool;

    private var _visible:Bool;
    private var _tempElement:Element;
    private var _useExternalContent:Bool;
    private var _defaultDisplayStyle:String;

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
        // trace('createdCallback----------------> ' + this.localName);
        initDefaultValues();
        parseContent();
        initContent();
        displayContent();

        this.dispatchEvent( new HTMLComponentEvent(HTMLComponentEventType.CREATION_COMPLETE));
    }

/**
	 * Called when the element is attached to the document
	 * @method attachedCallback
	 */
    public function attachedCallback():Void {
        // trace('attachedCallback----------------> ' +  this.localName);
        initialized = true;
        this.dispatchEvent( new HTMLComponentEvent(HTMLComponentEventType.INITIALIZE));
    }

/**
	 * Called when the element is detached from the document.
	 * @method detachedCallback
	 */
    public function detachedCallback():Void {
        // trace('detachedCallback---------------->');
    }

/**
	 * Called when one of attributes of the element is changed.
	 * @method attributeChangedCallback
	 * @param	attrName {String} A string representing the attribute's name
	 * @param	oldVal {String} A string representing the old value.
	 * @param	newVal {String} A string representing the new value.
	 */
    public function attributeChangedCallback(attrName:String, oldVal:String, newVal:String):Void {
        // trace('attributeChangedCallback---------------->'+attrName);
    }

    private function initDefaultValues():Void {
        _visible = true;
        _useExternalContent = false;
        _defaultDisplayStyle = "";
    }

    private function get_visible():Bool {
        return _visible;
    }

    private function set_visible(value:Bool):Bool {
        _visible = value;
        if(_defaultDisplayStyle == "" || _defaultDisplayStyle == "none" || _defaultDisplayStyle == null){
            _defaultDisplayStyle = this.style.display;
            if(_defaultDisplayStyle == "" || _defaultDisplayStyle == "none"){
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
        var content = "";
        if (this.childElementCount == 0 || !useExternalContent) {
            content = translateContent(getContent());
            _tempElement = Browser.document.createDivElement();
        } else {
            _useExternalContent=true;
            _tempElement = this;
            content = translateContent(this.innerHTML);
        }
        _tempElement.innerHTML = content;
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

    private function translateContent(source:String):String {
        var content = source;
        var stringToTranslate = new RegExp('\\{\\{(?!\\}\\})(.+)\\}\\}', 'gim');
        var results:Array<Array<String>> = new Array<Array<String>>();
        var result:Array<String> = new Array<String>();
        var i = 0;

        while ((result = stringToTranslate.exec(content)) != null) {
            results[i] = result;
            i++;
        }

        result = new Array<String>();
        for (result in results) {
            var totalString = result[0];
            var key = StringTools.trim(result[1]);
            content = StringTools.replace(content, totalString, LocalizationManager.instance.getString(key));
        }

        return content;
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

/**
 * Dispatched when the component has finished its construction and has all initialization properties set, at the end of createdCallback
 * See the {{#crossLink "HTMLComponentEventType"}}{{/crossLink}} class for a listing of event properties.
 * @event HTMLComponentEventType.CREATION_COMPLETE
 */

/**
 * Dispatched when the component has finished its construction, property processing, measuring, layout, and drawing, at the end of attachedCallback
 * See the {{#crossLink "HTMLComponentEventType"}}{{/crossLink}} class for a listing of event properties.
 * @event HTMLComponentEventType.INITIALIZE
 */