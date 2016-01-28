package ;

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
