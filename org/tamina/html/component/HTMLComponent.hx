package org.tamina.html.component;

import haxe.rtti.Meta;
import js.Browser;
import js.RegExp;
import js.html.Element;
import js.html.Event;
import js.html.HtmlElement;

import msignal.Signal;

import org.tamina.display.CSSDisplayValue;
import org.tamina.html.component.HTMLComponentEvent;
import org.tamina.i18n.LocalizationManager;
import org.tamina.utils.HTMLUtils;

using StringTools;

#if !NO_HTMLCOMPONENT_KEEPSUB
@:keepSub
#end
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
 *         \@skinpart
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

    /**
     * Fires when the display object and its children have been created.
     * @property creationComplete
     * @type Bool
     */
    public var creationComplete(default, null):Bool;

    private var _visible:Bool;
    private var _tempVirtualDOM:Element;
    private var _useExternalContent:Bool;
    private var _defaultDisplayStyle:CSSDisplayValue;

    private var _skinParts:Array<HTMLComponent>;
    private var _skinPartsWaiting:Array<HTMLComponent>;
    private var _skinPartsAttached:Bool = false;

    /**
     * Only attributes in this array will trigger attributeChangedCallback
     */
    @:native("observedAttributes")
    private var _observedAttributes:Array<String>;

    /**
     * An instance of the element is created or upgraded [1].
     * Useful for initializing state, settings up event listeners, or creating shadow dom.
     * See the spec [2] for restrictions on what you can do in the constructor.
     *
     * In general, work should be deferred to firstConnectionCallback or connectedCallback
     * as much as possible — especially work involving fetching resources or rendering.
     * However, note that connectedCallback can be called more than once, 
     * so any initialization work that is truly one-time should go into firstConnectionCallback.
     * 
     * In general, the constructor should be used to set up initial state and default values, 
     * and to set up event listeners and possibly a shadow root.
     *
     * [1]: https://developers.google.com/web/fundamentals/getting-started/primers/customelements#upgrades
     * [2]: https://html.spec.whatwg.org/multipage/scripting.html#custom-element-conformance
     */
    private function new() {
        _observedAttributes = new Array<String>();

        initDefaultValues();
        parseContent();
        updateSkinPartsStatus();

        created = true;

        if (_skinPartsAttached) {
            creationCompleteCallback();
        }
    }

    /**
     * Called by connectedCallback the first time this component is connected.
     * Useful for running setup code that needs access to the DOM of the element
     * and/or its children.
     * Generally, you should try to delay work until this time.
     *
     * @method firstConnectionCallback
     */
    private function firstConnectionCallback():Void {}

    /**
     * Called every time the element is inserted into the DOM.
     * Useful for running setup code, such as fetching resources or rendering.
     *
     * Note: most of the constructor's restrictions apply here until you call super.connectedCallback()
     *
     * @method connectedCallback
     */
    private function connectedCallback():Void {
        #if DEBUG_COMPONENTS
        trace('connectedCallback----------------> ' +  this.localName);
        #end

        if (!initialized) {
            displayContent();
            firstConnectionCallback();
            dispatchEvent(HTMLComponentEventFactory.createEvent(HTMLComponentEventType.INITIALIZE));
        }
    }
    
    /**
     * Called every time the element is removed from the DOM.
     * Useful for running clean up code (removing event listeners, etc.).
     *
     * @method disconnectedCallback
     */
    private function disconnectedCallback():Void {
        #if DEBUG_COMPONENTS
        trace('disconnectedCallback----------------> ' +  this.localName);
        #end
    }

    /**
     * The custom element has been moved into a new document (e.g. someone called document.adoptNode(el)).
     *
     * @method adoptedCallback
     */
    private function adoptedCallback():Void {
    }

    /**
     * Called when an attribute was added, removed, updated, or replaced.
     * Also called for initial values when an element is created by the parser, or upgraded.
     * Note: only attributes listed in the observedAttributes property will receive this callback.
     *
     * Note: Reaction callbacks are synchronous.
     * If someone calls el.setAttribute(...) on your element, the browser will immediately call attributeChangedCallback().
     *
     * @method attributeChangedCallback
     * @param   attrName {String} The attribute's name
     * @param   oldVal {String} The old value
     * @param   newVal {String} The new value
     */
    private function attributeChangedCallback(attrName:String, oldVal:String, newVal:String):Void {
        #if DEBUG_COMPONENTS
        trace('attributeChangedCallback----------------> ' +  this.localName);
        trace(attrName + ": " + oldVal + " => " + newVal);
        #end
    }

    /**
     * Called when component creation is complete
     *
     * @method creationCompleteCallback
     */
    private function creationCompleteCallback():Void {
        creationComplete = true;
        dispatchEvent(HTMLComponentEventFactory.createEvent(HTMLComponentEventType.CREATION_COMPLETE));
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


    // ==============================================
    // Internal functions
    // ==============================================

    private function getView():String { return ""; }

    private inline function parseContent(?useExternalContent:Bool = true):Void {
        var content = "";
        _tempVirtualDOM = Browser.document.createDivElement();

        if (this.innerHTML.trim() == "" || !useExternalContent) {
            content = translateContent(getView());
        } else {
            _useExternalContent = true;
            content = translateContent(this.innerHTML);
        }

        _tempVirtualDOM.innerHTML = content;
        initSkinParts(_tempVirtualDOM);
    }

    private inline function initSkinParts(target:Element):Void {
        var c:Class<HTMLComponent> = Type.getClass(this);
        _skinParts = new Array<HTMLComponent>();

        while (c != HTMLComponent && c != null) {
            var meta = Meta.getFields(c);
            var metaFields = Reflect.fields(meta);

            for (i in 0...metaFields.length) {
                var field = Reflect.field(meta, metaFields[i]);

                if (Reflect.hasField(field, "skinpart")) {
                    var element = HTMLUtils.getElementByAttribute(target, 'data-id', metaFields[i]);
                    Reflect.setField(this, metaFields[i], element);

                    if (element == null) {
                        Browser.console.error("Skinpart is null: " + metaFields[i] + " from " + Type.getClassName(c));
                    } else {
                        _skinParts.push(cast element);
                    }
                }
            }

            c = cast Type.getSuperClass(c);
        }
    }

    private inline function updateSkinPartsStatus():Void {
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

    private inline function skinPartReadyHandler(skinPart:HTMLComponent):Void {
        _skinPartsWaiting.remove(skinPart);
        _skinPartsAttached = _skinPartsWaiting.length == 0;

        if (!creationComplete && _skinPartsAttached) {
            creationCompleteCallback();
        }
    }

    private inline function translateContent(source:String):String {
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

    private inline function displayContent():Void {
        if (!initialized) {
            initialized = true;

            var numChildren = _tempVirtualDOM.childNodes.length;

            if (!_useExternalContent) {
                while (numChildren > 0) {
                    numChildren--;
                    var item:Element = cast _tempVirtualDOM.childNodes.item(0);
                    appendChild(item);
                }
            }
        }
    }
}
