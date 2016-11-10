TAMINA [![NPM version][npm-image]][npm-url]
========

TAMINA IS A FAST, SMALL, AND FEATURE-RICH HAXE LIBRARY

It makes things like Web Components, Custom Elements, Event handling, Proxy, Assets Loading, i18n, and XHR much simpler.

Inspired by [AngularJS](https://angularjs.org/) and [Flex frameworks](http://flex.apache.org/), Tamina is a low level toolset for building large scaled web applications. It is fully extensible and works well with other libraries. Every feature can be modified or replaced to suit your unique development workflow and feature needs

# Installation

Using npm:
```
$ npm -i taminahx
```


Using haxelib:
```
$ haxelib install taminahx
```

# Features

## Html Applications and web components
Tamina defines a default, or Application, container that lets you start adding content to your application without explicitly defining another container.
```javascript
package ;
 
import org.tamina.html.component.HTMLApplication;
 
class Main extends HTMLApplication{
 
    private static var _instance:Main;
 
    public function new():Void {
        super();
        loadComponents();
    }
 
    public static function main():Void {
 
        _instance = new Main();
    }
 
}
```

[more info](http://happy-technologies.com/custom-elements-and-component-developement-en/)

## JS Typing enhancement
Tamina give a set of new class and abstract to enhance javascript types, like Url, [Scheme](http://tamina.io/doc/classes/Scheme.html), [Event](http://tamina.io/doc/classes/Event[T].html), [HTTPMethod](http://tamina.io/doc/classes/HTTPMethod.html), and [MimeType](http://tamina.io/doc/classes/MimeType.html)

## Saas support
You can use Saas style in your web components

## i18n
You can manage your translation using the [LocalizationManager](http://tamina.io/doc/classes/LocalizationManager.html).
```html
<div>
     <a href="#" class="btn btn-prev">
     {{ title }}
     </a>
</div>
```

```javascript
var myTitle = LocalizationManager.instance.getString("title");
```

# Documentation

Full documentation is available here : http://tamina.io/doc/modules/Tamina.html

[npm-image]: https://badge.fury.io/js/taminahx.svg
[npm-url]: https://npmjs.org/package/taminahx
