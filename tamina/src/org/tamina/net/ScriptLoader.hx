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
    private static var _scriptsLoaded:Array<String>;

    public function new() {
        completeSignal = new Signal0();
        errorSignal = new Signal0();
        if (_scriptsLoaded == null) {
            _scriptsLoaded = new Array<String>();
        }
    }

    public function load(url:URL):Void {
        _url = url;
        if (_scriptsLoaded.indexOf(_url.path) == -1) {
            var script:ScriptElement = cast Browser.document.createElement('script');
            QuickLogger.info('chargement de ' + _url.path);
            script.addEventListener('load', loadCompleteHandler) ;
            script.addEventListener('error', loadErrorHandler) ;
            script.src = _url.path;
            _header = cast Browser.document.getElementsByTagName('head')[0];
            _header.appendChild(script);
        } else {
            QuickLogger.info('Script déja chargé : ' + _url.documentName);
            loadCompleteHandler();
        }

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
