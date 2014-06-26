package org.tamina.net;
import js.html.Element;
import org.tamina.log.QuickLogger;
import js.html.ScriptElement;
import js.Browser;
import msignal.Signal.Signal0;

class ScriptLoader {

    public var completeSignal:Signal0;
    public var errorSignal:Signal0;

    private var _header:Element;
    private var _url:URL;
    private var _script:ScriptElement;
    private var _cache:ScriptLoaderCache;

    public function new() {
        completeSignal = new Signal0();
        errorSignal = new Signal0();
        _cache = new ScriptLoaderCache();
    }

    public function load(url:URL):Void {
        _url = url;
        _script = _cache.getLoadingScript(_url);

        if ( _cache.isLoaded(_url) ) {
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
            _cache.addLoadingScript(_script);
            _script.src = _url.path;
            _header = cast Browser.document.getElementsByTagName('head')[0];
            _header.appendChild(_script);
        }

    }

    private function loadCompleteHandler(?event:Dynamic):Void {
        QuickLogger.info('script loaded');
        _cache.addLoadedScript(_url);
        _cache.removeLoadingScript(_script);
        completeSignal.dispatch();
    }

    private function loadErrorHandler(event:Dynamic):Void {
        _cache.removeLoadingScript(_script);
        errorSignal.dispatch();
    }
}
