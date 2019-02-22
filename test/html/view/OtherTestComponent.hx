package test.html.view;
import org.tamina.html.component.HTMLComponent;

@view("", "my-othercustomelement")
class OtherTestComponent  extends HTMLComponent {

    private var _myvar:String="coucou";

    override public function connectedCallback() {
        super.connectedCallback();
        _myvar = "pouet";
    }


    public function displaySomething():Void{
        trace(_myvar);
    }
}
