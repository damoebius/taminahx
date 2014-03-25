package ;
import org.tamina.html.TextAlign;
import org.tamina.utils.DateUtils;
import org.tamina.log.LogLevel;
import org.tamina.html.MimeType;
import js.html.Image;
import org.tamina.display.BitmapData;
import js.html.Document;
import org.tamina.net.XMLLoader;
import org.tamina.geom.Junction;
import org.tamina.html.Global;
import createjs.easeljs.Sprite;
import org.tamina.view.Group;
import org.tamina.net.ScriptListLoader;
import org.tamina.net.URL;
import org.tamina.net.ScriptLoader;
import org.tamina.log.QuickLogger;
import org.tamina.log.DivPrinter;
class Main {

    public function new() {
    }

    public static function main():Void {
        Console.addPrinter(new DivPrinter());
        QuickLogger.level = LogLevel.INFO;
        QuickLogger.info('test lib');
        QuickLogger.warn('test warn message');
        var loader = new ScriptListLoader();
        var scripts = new Array<URL>();
        scripts.push(new URL('http://code.createjs.com/tweenjs-0.5.1.min.js'));
        scripts.push(new URL('http://code.createjs.com/preloadjs-0.4.1.min.js'));
        loader.load(scripts);
        QuickLogger.warn('toto');
        var g = new Group<Sprite>();

        var j1:Junction = new Junction(10,10);
        var j2:Junction = new Junction(100,100);
        j1.links.push(j2);
        j2.links.push(j1);

        var xmlLoader:XMLLoader = new XMLLoader();
        xmlLoader.completeSignal.add(xml_completeHandler);
        xmlLoader.load( new URL('http://linuxfr.org/news.atom') );

        Global.getInstance().call('errorHandler', []);
        BitmapData.toDataUrl( new Image(),100,100,MimeType.PNG);

        DateUtils.toFrenchString( Date.now() );
        TextAlign.CENTER;

    }

    public static function xml_completeHandler(xml:Document):Void{
        QuickLogger.info('hop');
    }
}
