package ;
import org.tamina.net.ScriptListLoader;
import org.tamina.net.URL;
import org.tamina.net.ScriptLoader;
import org.tamina.log.QuickLogger;
class Main {

    public function new() {
    }

    public static function main():Void {
        QuickLogger.info('test lib');
        var loader = new ScriptListLoader();
        var scripts = new Array<URL>();
        scripts.push(new URL('http://code.createjs.com/easeljs-0.7.1.min.js'));
        scripts.push(new URL('http://code.createjs.com/tweenjs-0.5.1.min.js'));
        scripts.push(new URL('http://code.createjs.com/preloadjs-0.4.1.min.js'));
        loader.load(scripts);
    }
}
