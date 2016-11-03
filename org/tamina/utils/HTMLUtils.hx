package org.tamina.utils;

import js.Browser;
import js.html.DOMElement;
import js.html.HtmlElement;
import js.html.Event;
import js.html.Node;
import js.html.Element;
import js.html.TouchEvent;

import org.tamina.geom.Point;

/**
 * A class that provides useful tools to manipulate HTML components
 *
 * @class HTMLUtils
 */
class HTMLUtils {
    /**
     * Same as JavaScript's method from the Document object, but can be used on Element objects
     *
     * @method getElementById
     *
     * @param {Element} parent The parent element to search in
     * @param {String} id The id to search for
     *
     * @return {Element} The found element
     */
    public static function getElementById(parent:Element, id:String):Element {
        var result:Element = null;
        if (parent.children != null) {
            for (i in 0...parent.children.length) {
                var el:Element = cast parent.children.item(i);
                var elId = getAttribute(el, 'id');
                if (elId == id) {
                    result = el;
                    break;
                } else {
                    result = getElementById(el, id);
                }
            }
        }
        return result;
    }

    /**
     * Find a child element from its parent by attribute value
     *
     * @method getElementByAttribute
     *
     * @param {Element} parent The parent element to search in
     * @param {String} attribute The attribute name to search for
     * @param {String} value The attribute value to search for
     *
     * @return {Element} The found element
     */

    public static function getElementByAttribute(parent:Element, attribute:String, value:String):Element {
        var result:Element = null;
        if (parent.children != null) {
            for (i in 0...parent.children.length) {
                if (result == null) {
                    var el:Element = cast parent.children.item(i);
                    var elId = getAttribute(el, attribute);
                    if (elId == value) {
                        result = el;
                        return result;
                    } else {
                        result = getElementByAttribute(el, attribute, value);
                    }
                } else {
                    return result;
                }
            }
        }
        return result;
    }

    /**
     * Retrieves an element's attribute by name
     *
     * @method getAttribute
     *
     * @param {Element} element The element to search the attribute in
     * @param {String} name The attribute
     *
     * @return {String} The attribute value
     */

    public static function getAttribute(element:Element, name:String):String {
        var result:String = '';
        for (i in 0...element.attributes.length) {
            var att = element.attributes.item(i);
            if (att.name == name) {
                result = att.value;
                break;
            }
        }
        return result;
    }

    /**
     * Returns the path (an array containing the event target and all of its parents) of a javascript event
     *
     * @method getEventPath
     *
     * @param {Event} event The JavaScript event
     *
     * @return {Array<Element>} The event path
     */

    public static function getEventPath(event:Event):Array<Element> {
        var result = new Array<Element>();

        if (event.target != null && Std.is(event.target, Element)) {
            result = recursivelyFindParent(cast event.target);
        }

        return result;
    }

    /**
     * Returns an array containing the given element and all of its parents
     *
     * @method recursivelyFindParent
     *
     * @param {Element} element The element to find parents from
     *
     * @return {Array<Element>} The event path
     */

    public static function recursivelyFindParent(element:Element):Array<Element> {
        var result = new Array<Element>();

        result.push(element);

        if (element.nodeName.toLowerCase() != 'body' && element.parentNode != null) {
            result = result.concat(recursivelyFindParent(cast element.parentNode));
        }

        return result;
    }

    public static function removeElement(element:DOMElement):Bool {
        var result = true;
        if (element.remove != null) {
            element.remove();
        } else if (element.parentElement != null && element.parentElement.contains(element)) {
            element.parentElement.removeChild(element);
        } else {
            result = false;
        }
        return result;
    }

    public static function getElementOffset(element:Element):{top:Int, left:Int} {
        var result = {top:0, left:0};
        var rect = element.getBoundingClientRect();
        var body = Browser.document.body;
        var win = Browser.window;

        result.top = Math.round(rect.top + win.pageYOffset - element.clientTop);
        result.left = Math.round(rect.left + win.pageXOffset - element.clientLeft);
        return result;
    }

    public static function getTouchPosition(element:Element, evt:TouchEvent):Point {
        var offset = getElementOffset(element);
        var touch = evt.touches.item(0);
        return new Point(touch.pageX - offset.left, touch.pageY - offset.top);
    }

    public static function isTouchSupported():Bool {
        var result = untyped __js__("!!(('ontouchstart' in window)
            || (window.navigator['msPointerEnabled'] && window.navigator['msMaxTouchPoints'] > 0)
            || (window.navigator['pointerEnabled'] && window.navigator['maxTouchPoints'] > 0))");
        return result;
    }

    public static function getBrowserType(?agent:String = null):BrowserType {
        if (agent == null) agent = Browser.navigator.userAgent;
        var result = BrowserType.Unknown;

        if (~/WebKit/.match(agent)) {

            if (~/Chrome/.match(agent)) {
                result = BrowserType.Chrome;

                var isAndroid = agent.indexOf('Mozilla/5.0') > -1 && agent.indexOf('Android ') > -1 && agent.indexOf('AppleWebKit') > -1;
                if (isAndroid) {
                    result = BrowserType.Android;
                }
            } else if (~/Safari/.match(agent)) {
                result = BrowserType.Safari;
            } else {
                result = BrowserType.Opera;
            }

        } else if (~/Opera/.match(agent)) {
            result = BrowserType.Opera;

        } else if (~/Mozilla/.match(agent)) {
            var isIE = agent.indexOf('MSIE ') > -1 || agent.indexOf('Trident/') > -1  || agent.indexOf('Edge/') > -1;
            var isAndroid = agent.indexOf('Mozilla/5.0') > -1 && agent.indexOf('Android ') > -1 && agent.indexOf('AppleWebKit') > -1;

            if (isIE) {
                result = BrowserType.IE;
            } else if (isAndroid) {
                result = BrowserType.Android;
            } else {
                result = BrowserType.FireFox;
            }

        } else {
            result = BrowserType.IE;
        }

        return result;
    }

    public static function getIEVersion(?ua:String = null):Int {
        if (ua == null) ua = Browser.navigator.userAgent;

        var ieRegex = ~/MSIE\s([0-9]+)/;
        var tridentRegex = ~/Trident\/.*rv:([0-9]+)/;
        var edgeRegex = ~/Edge\/([0-9]+)/;

        var regexArray = [ieRegex, tridentRegex, edgeRegex];
        for (regex in regexArray) {
            if (regex.match(ua)) {
                return Std.parseInt(regex.matched(1));
            }
        }

        return -1;
    }

    public static function getChromeVersion(?ua:String = null):Int {
        if (ua == null) ua = Browser.navigator.userAgent;

        var chromeRegex = ~/Chrome\/([0-9]+)/;

        if (chromeRegex.match(ua)) {
            return Std.parseInt(chromeRegex.matched(1));
        }

        return -1;
    }

    public static function getFirefoxVersion(?ua:String = null):Int {
        if (ua == null) ua = Browser.navigator.userAgent;

        var firefoxRegex = ~/Firefox\/([0-9]+)/;

        if (firefoxRegex.match(ua)) {
            return Std.parseInt(firefoxRegex.matched(1));
        }

        return -1;
    }

    public static function getSafariVersion(?ua:String = null):Int {
        if (ua == null) ua = Browser.navigator.userAgent;

        var safariRegex = ~/Version\/([0-9]+)/;

        if (safariRegex.match(ua)) {
            return Std.parseInt(safariRegex.matched(1));
        }

        return -1;
    }

}

enum BrowserType {
    Chrome;
    Android;
    Safari;
    WebKitOther;
    FireFox;
    Opera;
    IE;
    Unknown;
}
