package org.tamina.net;
import js.html.Element;
import org.tamina.log.QuickLogger;
import js.html.ScriptElement;
import js.html.HtmlElement;
import js.Browser;
import msignal.Signal.Signal0;

@:expose class ScriptLoader {

    public var completeSignal:Signal0;
    public var errorSignal:Signal0;

    private var _header:Element;
    private var _url:URL;
    private var _script:ScriptElement;
    private static var _scriptsLoaded:Array<String>;
    private static var _scriptsLoading:Array<ScriptElement>;

    public function new() {
        completeSignal = new Signal0();
        errorSignal = new Signal0();
        if (_scriptsLoaded == null) {
            _scriptsLoaded = new Array<String>();
            _scriptsLoading = new Array<ScriptElement>();
        }
    }

    public function load(url:URL):Void {
        _url = url;
        _script = getLoadingScript(_url);

        if (_scriptsLoaded.indexOf(_url.path) >= 0 ) {
            QuickLogger.info('Script déja chargé : ' + _url.documentName);
            loadCompleteHandler();
        } else if( _script != null){
            QuickLogger.info('Script en cours de chargement : ' + _url.documentName);
            _script.addEventListener('load', loadCompleteHandler) ;
            _script.addEventListener('error', loadErrorHandler) ;
        } else {
            _script = cast Browser.document.createElement('script');
            QuickLogger.info('chargement de ' + _url.path);
            _script.addEventListener('load', loadCompleteHandler) ;
            _script.addEventListener('error', loadErrorHandler) ;
            _script.src = _url.path;
            _header = cast Browser.document.getElementsByTagName('head')[0];
            _header.appendChild(_script);
        }

    }

    private function getLoadingScript(url:URL):ScriptElement{
        var result:ScriptElement = null;
        for(i in 0..._scriptsLoading.length){
            var script = _scriptsLoading[i];
            if(script.src == url.path){
                result = script;
                break;
            }
        }
        return result;
    }

    private function loadCompleteHandler(?event:Dynamic):Void {
        QuickLogger.info('script loaded');
        _scriptsLoaded.push(_url.path);
        completeSignal.dispatch();
    }

    private function loadErrorHandler(event:Dynamic):Void {
        errorSignal.dispatch();
    }
}
