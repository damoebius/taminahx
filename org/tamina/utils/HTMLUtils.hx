package org.tamina.utils;

import org.tamina.log.QuickLogger;
import js.html.Exception;
import js.html.Event;
import js.html.Node;
import js.html.Element;
class HTMLUtils {
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

    public static function getEventPath(event:Event):Array<Element> {
        var ret = new Array<Element>();

        if (event.target != null) {
            var element:Element = null;

            try {
                element = cast(event.target, Element);
            } catch (e:Exception) {
                QuickLogger.error('Event target is not a JS element');
            }

            if (element != null) {
                ret = recursivelyFindParent(element);
            }
        }

        return ret;
    }

    public static function recursivelyFindParent(element:Element):Array<Element> {
        var ret = new Array<Element>();

        ret.push(element);

        if (element.nodeName.toLowerCase() != 'body' && element.parentNode != null) {
            ret = ret.concat(recursivelyFindParent(cast element.parentNode));
        }

        return ret;
    }
}
