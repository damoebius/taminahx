package test.html.view;
import org.tamina.html.component.HTMLComponent;

@view('test/html/view/OtherTestComponent.html')
class OtherTestComponent  extends HTMLComponent {
    public function displaySomething():Void{
        trace("yarglaaaa");
    }
}
