package org.tamina.html.component;

import haxe.rtti.Meta;
import js.Browser;
import js.RegExp;
import js.html.Element;
import js.html.Event;
import js.html.HtmlElement;

import msignal.Signal;

import org.tamina.display.CSSDisplayValue;
import org.tamina.html.component.HTMLComponentEvent.HTMLComponentEventType;
import org.tamina.i18n.LocalizationManager;
import org.tamina.utils.HTMLUtils;

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
 * Another usefull feature is Skin Part support. This metadata is used to reference an element from his view.
 * You don’t need to do it yourself anymore, A macro will automatically do it while compiling.<br>
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
 * This metadata is used to link an HTML file as the view part of your component. In the previous exemple,
 * TestComponent.html is used to describe the view structure.
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

    /**
     * Whether or not the display object has been created.
     * @property created
     * @type Bool
     */
    public var created(default, null):Bool;

    private var _visible:Bool;
    private var _tempElement:Element;
    private var _useExternalContent:Bool;
    private var _defaultDisplayStyle:CSSDisplayValue;

    private var _skinParts:Array<HTMLComponent>;
    private var _skinPartsWaiting:Array<HTMLComponent>;
    private var _skinPartsAttached:Bool = false;

    private function new() {
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
        updateSkinPartsStatus();

        created = true;

        if (_skinPartsAttached) {
            creationCompleteCallback();
        }
    }

    /**
     * Called when component creation is complete
     * @method creationCompleteCallback
     */
    public function creationCompleteCallback():Void {
        this.dispatchEvent(new HTMLComponentEvent(HTMLComponentEventType.CREATION_COMPLETE));
    }

    /**
     * Called when the element is attached to the document
     * @method attachedCallback
     */
    public function attachedCallback():Void {
        // trace('attachedCallback----------------> ' +  this.localName);
        if (!initialized) {
            this.dispatchEvent(new HTMLComponentEvent(HTMLComponentEventType.INITIALIZE));
        }
        initialized = true;
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
     * @param   attrName {String} A string representing the attribute's name
     * @param   oldVal {String} A string representing the old value.
     * @param   newVal {String} A string representing the new value.
     */
    public function attributeChangedCallback(attrName:String, oldVal:String, newVal:String):Void {
        // trace('attributeChangedCallback---------------->'+attrName);
    }

    private function initDefaultValues():Void {
        _visible = true;
        _useExternalContent = false;
        _defaultDisplayStyle = UNDEFINED;
    }

    private function get_visible():Bool {
        return _visible;
    }

    private function set_visible(value:Bool):Bool {
        _visible = value;

        if (_defaultDisplayStyle == UNDEFINED || _defaultDisplayStyle == NONE || _defaultDisplayStyle == null) {
            _defaultDisplayStyle = this.style.display;

            if (_defaultDisplayStyle == UNDEFINED || _defaultDisplayStyle == NONE) {
                _defaultDisplayStyle = BLOCK;
            }
        }

        if (_visible) {
            this.style.display = _defaultDisplayStyle;
        } else {
            this.style.display = NONE;
        }

        return _visible;
    }

    private function getContent():String {
        return untyped this.getView();
    }

    private function parseContent(?useExternalContent:Bool = true):Void {
        var content = "";

        if (this.childElementCount == 0 || !useExternalContent) {
            content = translateContent(getContent());
            _tempElement = Browser.document.createDivElement();
        } else {
            _useExternalContent = true;
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
        _skinParts = new Array<HTMLComponent>();

        for (i in 0...metaFields.length) {
            var field = Reflect.field(meta, metaFields[i]);

            if (Reflect.hasField(field, "skinpart")) {
                var element = HTMLUtils.getElementByAttribute(target, 'data-id', metaFields[i]);
                Reflect.setField(this, metaFields[i], element);

                if (element == null) {
                    trace("skinpart is null: " + metaFields[i] + " from " + this.nodeName);
                }
                _skinParts.push(cast element);
            }
        }
    }

    private function updateSkinPartsStatus():Void {
        _skinPartsWaiting = new Array<HTMLComponent>();

        for (skinPart in _skinParts) {
            if (HTMLApplication.isCustomElement(skinPart.nodeName) && skinPart.initialized != true) {
                _skinPartsWaiting.push(skinPart);
            }
        }

        _skinPartsAttached = _skinPartsWaiting.length == 0;

        if (!_skinPartsAttached) {
            for (skinPart in _skinPartsWaiting) {
                skinPart.addEventListener(
                    HTMLComponentEventType.INITIALIZE,
                    skinPartReadyHandler.bind(skinPart)
                );
            }
        }
    }

    private function skinPartReadyHandler(skinPart:HTMLComponent):Void {
        _skinPartsWaiting.remove(skinPart);

        _skinPartsAttached = _skinPartsWaiting.length == 0;
        if (_skinPartsAttached) {
            creationCompleteCallback();
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
        if (!_useExternalContent) {
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
