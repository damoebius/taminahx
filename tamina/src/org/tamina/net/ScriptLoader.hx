package org.tamina.net;
import js.html.Element;
import org.tamina.log.QuickLogger;
import js.html.ScriptElement;
import js.html.HtmlElement;
import js.Browser;
import msignal.Signal.Signal0;
class ScriptLoader {

    public var completeSignal:Signal0;
    public var errorSignal:Signal0;

    private var _header:Element;

    public function new() {
        completeSignal = new Signal0();
        errorSignal = new Signal0();
    }

    public function load(url:URL):Void {
        var script:ScriptElement = cast Browser.document.createElement('script');
        QuickLogger.info('chargement de ' + url.path);
        script.addEventListener('load', loadCompleteHandler) ;
        script.addEventListener('error', loadErrorHandler) ;
        script.src = url.path;
        _header = cast Browser.document.getElementsByTagName('head')[0];
        _header.appendChild(script);

    }

    private function loadCompleteHandler(event:Dynamic):Void {
        QuickLogger.info('script loaded');
        completeSignal.dispatch();
    }

    private function loadErrorHandler(event:Dynamic):Void {
        errorSignal.dispatch();
    }
}
