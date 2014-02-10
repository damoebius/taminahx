package org.tamina.net;
import js.html.XMLHttpRequestProgressEvent;
import org.tamina.log.QuickLogger;
import org.tamina.events.XMLHttpRequestEvent;
import js.html.XMLHttpRequest;
import msignal.Signal;
class XMLLoader {

    public var completeSignal:Signal1<Xml>;
    public var errorSignal:Signal1<Dynamic>;
    private var _configXML:Xml;
    private var _configLoader:XMLHttpRequest;

    public function new() {
        _configLoader = new XMLHttpRequest();
        _configLoader.addEventListener(XMLHttpRequestEvent.LOAD, loadCompleteHandler);
        _configLoader.addEventListener(XMLHttpRequestEvent.ERROR, loadErrorHandler);
        _configLoader.overrideMimeType("text/xml");
        try {
            _configLoader.responseType = "xml";
        } catch (e:Dynamic) {
            QuickLogger.warn('responseType not supported');
        }

        completeSignal = new Signal1<Xml>();
        errorSignal = new Signal1<Dynamic>();
    }

    public function load(url:URL):Void {
        QuickLogger.info("Config : init : " + url.path);
        _configLoader.open("GET", url.path, true);
        _configLoader.send(null);

    }

    private function loadCompleteHandler(event:XMLHttpRequestProgressEvent):Void {
        QuickLogger.info('xml loaded : ' + _configLoader.responseText);
        _configXML = Xml.parse(_configLoader.responseText);
        completeSignal.dispatch(_configXML);
    }

    private function loadErrorHandler(error:Dynamic):Void {
        errorSignal.dispatch(error);
    }
}
