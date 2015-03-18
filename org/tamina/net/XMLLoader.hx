package org.tamina.net;
import js.html.XMLHttpRequestResponseType;
import js.html.Document;
import js.html.ProgressEvent;
import org.tamina.log.QuickLogger;
import org.tamina.events.XMLHttpRequestEvent;
import js.html.XMLHttpRequest;
import msignal.Signal;
class XMLLoader {

    public var completeSignal:Signal1<Document>;
    public var errorSignal:Signal1<Dynamic>;
    private var _configDocument:Document;
    private var _configLoader:XMLHttpRequest;

    public function new() {
        _configLoader = new XMLHttpRequest();
        _configLoader.addEventListener(XMLHttpRequestEvent.LOAD, loadCompleteHandler);
        _configLoader.addEventListener(XMLHttpRequestEvent.ERROR, loadErrorHandler);
        try {
            _configLoader.overrideMimeType("text/xml");
        } catch (e:Dynamic) {
            QuickLogger.warn('overrideMimeType not supported');
        }
        try {
            _configLoader.responseType = XMLHttpRequestResponseType.DOCUMENT;
        } catch (e:Dynamic) {
            QuickLogger.warn('responseType not supported');
        }

        completeSignal = new Signal1<Document>();
        errorSignal = new Signal1<Dynamic>();
    }

    public function load(url:URL):Void {
        QuickLogger.info("Config : init : " + url.path);
        _configLoader.open("GET", url.path, true);
        _configLoader.send(null);

    }

    private function loadCompleteHandler(event:ProgressEvent):Void {
        QuickLogger.info('xml loaded : ' + _configLoader.responseXML);
        _configDocument = _configLoader.responseXML;
        completeSignal.dispatch(_configDocument);
    }

    private function loadErrorHandler(error:Dynamic):Void {
        errorSignal.dispatch(error);
    }
}
