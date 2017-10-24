package test.html.view;
import org.tamina.html.component.HTMLComponent;

@view('test/html/view/TestComponent.html')
class TestComponent extends HTMLComponent {

    @skinpart("")
    private var _otherComponent:OtherTestComponent;
    private var _rand:Float;

    override public function attachedCallback() {
        _otherComponent.displaySomething();
        _rand = Math.random();
    }

    private function toto():Void {
        trace("clicked " + _rand);
    }

}
