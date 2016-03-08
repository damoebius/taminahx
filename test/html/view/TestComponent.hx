package test.html.view;
import org.tamina.html.component.HTMLComponent;

@view('test/html/view/TestComponent.html')
class TestComponent extends HTMLComponent {

    @skinpart("")
    private var _otherComponent:OtherTestComponent;

    override public function attachedCallback() {
        _otherComponent.displaySomething();
    }

}
