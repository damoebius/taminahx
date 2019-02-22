package test.html.view;
import js.Browser;
import js.html.SpanElement;
import org.tamina.html.component.HTMLComponent;
import org.tamina.utils.BindingUtils;

@view("", "my-customelement")
class TestComponent extends HTMLComponent {

    @skinpart("") private var _otherComponent:OtherTestComponent;
    @skinpart("") private var _messageSpan:SpanElement;

    private var _rand:Float;
    private var _data:TestData;
    private var _index:Int;

    override public function connectedCallback() {
        super.connectedCallback();
        _otherComponent.displaySomething();
        _rand = Math.random();
        _index = 0;
        _data = {
            message: "click to update",
            name:"me"
        };

        var watcher = BindingUtils.bindProperty(_data, "message", _messageSpan, "innerHTML");
        for (i in 0...1000) {
            var element = Browser.document.createSpanElement();
            BindingUtils.bindProperty(_data, "message", element, "innerHTML");
            this.appendChild(element);
        }

        BindingUtils.remove(watcher);

    }

    private function toto():Void {
        trace("clicked " + _rand);
        _index++;
        _data.message = "clicked " + _index + " times";
    }

}

typedef TestData = {
    var message:String;
    var name:String;
}
