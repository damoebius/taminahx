package ;
import org.tamina.net.URL;
import org.tamina.net.ScriptLoader;
import org.tamina.log.QuickLogger;
class Main {

    public function new() {
    }

    public static function main():Void{
        QuickLogger.info('test lib');
        var loader = new ScriptLoader();
        loader.load( new URL('http://code.createjs.com/easeljs-0.7.1.min.js') );
    }
}
