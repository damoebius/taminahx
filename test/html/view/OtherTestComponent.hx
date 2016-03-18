package test.html.view;
import org.tamina.html.component.HTMLComponent;

@view('test/html/view/OtherTestComponent.html')
class OtherTestComponent  extends HTMLComponent {

    private var _myvar:String="coucou";

    override public function createdCallback() {
        super.createdCallback();
        _myvar = "pouet";
    }


    public function displaySomething():Void{
        trace(_myvar);
    }
}
