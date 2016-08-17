package org.tamina.utils;

import js.html.Event;
import js.html.Node;
import js.html.Element;

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
}
