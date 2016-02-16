package ;

import createjs.easeljs.DisplayObject;
import org.tamina.view.Group;
import org.tamina.utils.UID;
import org.tamina.utils.ObjectUtils;
import org.tamina.utils.NumberUtils;
import org.tamina.utils.HTMLUtils;
import org.tamina.utils.GraphicUtils;
import org.tamina.utils.DateUtils;
import org.tamina.utils.ColorUtils;
import org.tamina.utils.ClassUtils;
import org.tamina.net.URL;
import org.tamina.net.ScriptLoader;
import org.tamina.net.XMLLoader;
import org.tamina.log.QuickLogger;
import org.tamina.io.ImageLoader;
import org.tamina.geom.Junction;
import org.tamina.events.EventDispatcher;
import org.tamina.events.Event;
import org.tamina.display.ColorMatrix;
import org.tamina.display.BitmapData;
import org.tamina.i18n.LocalizationManager;
import org.tamina.i18n.ITranslation;
import html.view.TestComponent;
import org.tamina.html.component.HTMLApplication;
/**
 * Tamina Haxe Library
 *
 * @module Tamina
 * @main
 */

typedef MainEvent=Event<String>;

@:expose class Main extends HTMLApplication{

    private static var _instance:Main;

    private var _myComponent:TestComponent;

    public function new():Void {
        super();
        build();
    }

    public static function init(translations:Array<ITranslation>):Void{
        LocalizationManager.instance.setTranslations(translations);
        _instance.loadComponents();
    }

    public static function main():Void {
        _instance = new Main();
    }

    private function build():Void{
        BitmapData.getMimeType('');
        ColorMatrix.BANDW_MATRIX.length;
        new EventDispatcher<String>();
        new Junction();
        new ImageLoader();
        QuickLogger.debug("");
        new XMLLoader();
        new ScriptLoader();
        ClassUtils.expose(null,'');
        ColorUtils.invert('');
        DateUtils.toFrenchString(Date.now());
        GraphicUtils.isPointInsideRectangle(null,null);
        HTMLUtils.getElementById(null,null);
        NumberUtils.toFixed(0,0);
        ObjectUtils.merge(null,null);
        UID.getUID();
        new Group<DisplayObject>();
    }
}
/**
 * <br/>http://www.createjs.com/easeljs
 * <br/>To install easeljs external definition
 * @main
 * @module EaselJS
 * @example
 *      npm install createjs-haxe
**/
