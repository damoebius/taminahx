<img align="left" src="http://tamina.io/tamina-white.png">TAMINA [![NPM version][npm-image]][npm-url]
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
```haxe
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
HTMLApplication has a loadComponents() function that registers ALL components used by the application. Thanks to macros, components are automatically registered while compiling. So there’s no need to do it manually or with the Reflexion API at runtime.

## HTMLComponent

### x-tag

Since the last article about HTMLComponent, some things changed. HTMLComponent now extends HTMLElement. That means we can deal with components in an easier way (like DOM elements).

The other change is it officially supports Custom Elements. It’s now possible to instantiate HTMLComponent in their view.
```html
<div>
    Hello
</div>
 
<html-view-othertestcomponent data-id="_otherComponent"></html-view-othertestcomponent>

```

### Life cycle

Our component life cycle is the same as Custom Elements.

* `public function createdCallback() // Called after the element is created.`

* `public function attachedCallback() // Called when the element is attached to the document.`

* `public function detachedCallback() // Called when the element is detached from the document.`

* `public function attributeChangedCallback(attrName:String, oldVal:String, newVal:String) // Called when one of attributes of the element is changed.`

You can override them if you need it.

### Skin Parts

Another usefull feature is Skin Part support. This metadata is used to reference an element from his view. You don’t need to do it yourself anymore, A macro will automatically do it while compiling.
This technique was inspired by Flex4 Spark components architecture.
```haxe
@view('html/view/TestComponent.html')
class TestComponent extends HTMLComponent {
 
    @skinpart("")
    private var _otherComponent:OtherTestComponent;
 
    override public function attachedCallback() {
        _otherComponent.displayHellWorld();
    }
 
}
```

### Instance Factory

To instantiate dynamically a component from your application, like an itemRenderer for example, you can use a Factory available in HTMLComponent.
```haxe
public static function createInstance<T>(type:Class<T>):T;
```

```haxe
var myComponent = HTMLComponent.createInstance(TestComponent);
Browser.document.body.appendChild(myComponent);
```


### Polyfills
Browsers don’t support Custom Elements very well. But it'll be native soonly.
![caniuse](http://happy-technologies.com/wp-content/uploads/2015/12/ce1-1024x256.jpg)
To make them compatible we used [webcomponent.js](https://github.com/WebComponents/webcomponentsjs).
![polyfill](http://happy-technologies.com/wp-content/uploads/2015/12/ce2.jpg)
An optimized and minified version of 15Kb is available on our [CDN here](http://storage.sakuradesigner.microclimat.com/apps/html5/js/CustomElements.min.js).

## JS Typing enhancement
Tamina give a set of new class and abstract to enhance javascript types, like Url, [Scheme](http://tamina.io/doc/classes/Scheme.html), [Event](http://tamina.io/doc/classes/Event[T].html), [HTTPMethod](http://tamina.io/doc/classes/HTTPMethod.html), and [MimeType](http://tamina.io/doc/classes/MimeType.html)

## Saas support
You can use Saas style in your web components

## i18n
You can manage your translation using the [LocalizationManager](http://tamina.io/doc/classes/LocalizationManager.html).

### Initialization

You can initialize the LocalizationManager using an array of ITranslation.

```haxe
interface ITranslation {
    public var fieldName:String;
    public var locale:Locale;
    public var value:String;
 
}
```
The Json data :

```json
{
    "translations": [{
 
        "fieldName": "title",
        "value": "Mon Application",
        "locale": "fr_FR"
 
    }, {
 
        "fieldName": "sub_title",
        "value": "Haxe power",
        "locale": "fr_FR"
 
    }]
}
```
And an example of initialization :
```haxe
LocalizationManager.instance.setTranslations(translations);
```
### Utilization

To use a translation from your application, you just have to call the LocalizationManager.

```haxe
var myTitle = LocalizationManager.instance.getString("title");
```
Or from the view :

```html
<div>
     <a href="#" class="btn btn-prev">
     {{ title }}
     </a>
</div>
```

# Full Example

The main page : main.html

```html
<body>
 
<script src="main.js"></script>
<html-view-testcomponent id="_myComponent"></html-view-testcomponent>
<script>
    var translations = [{
 
        fieldName: 'title',
        value: 'Hello',
        locale: 'fr_FR'
 
    }]
 
    Main.init(translations);
</script>
</body>
```

The main application, Main.hx, compiles main.js


```haxe
package;
 
import org.tamina.i18n.LocalizationManager;
import org.tamina.i18n.ITranslation;
import html.view.TestComponent;
import org.tamina.html.component.HTMLApplication;
 
@:expose class Main extends HTMLApplication{
 
    private static var _instance:Main;
 
    private var _myComponent:TestComponent;
 
    public function new():Void {
        super();
    }
 
    public static function init(translations:Array<ITranslation>):Void{
        LocalizationManager.instance.setTranslations(translations);
        _instance.loadComponents();
    }
 
    public static function main():Void {
        _instance = new Main();
    }
}
```
TestComponent.hx with a typed SkinPart , and an override of attachedCallback.

```haxe
package html.view;
import org.tamina.html.component.HTMLComponent;
 
@view('html/view/TestComponent.html')
class TestComponent extends HTMLComponent {
 
    @skinpart("")
    private var _otherComponent:OtherTestComponent;
 
    override public function attachedCallback() {
        _otherComponent.displaySomething();
    }
 
}
```

TestComponent.html


```html
<div>
    {{title}}
</div>
 
<html-view-othertestcomponent data-id="_otherComponent"></html-view-othertestcomponent>
```

OtherTestComponent.hx and OtherTestComponent.html

```html
<div>
    Happy
</div>
```

```haxe
package html.view;
import org.tamina.html.component.HTMLComponent;
 
@view('html/view/OtherTestComponent.html')
class OtherTestComponent  extends HTMLComponent {
    public function displaySomething():Void{
        trace("yarglaaaa");
    }
}
```

The Result :


```html
<body>
 
<script src="release/tamina.js"></script>
 
<html-view-testcomponent>
 
<div>
    Hello
</div>
 
<html-view-othertestcomponent data-id="_otherComponent">
 
<div>
    Happy
</div>
 
</html-view-othertestcomponent>
</html-view-testcomponent>
 
</body>
```

# Documentation

Full documentation is available here : http://tamina.io/doc/modules/Tamina.html

[npm-image]: https://badge.fury.io/js/taminahx.svg
[npm-url]: https://npmjs.org/package/taminahx
