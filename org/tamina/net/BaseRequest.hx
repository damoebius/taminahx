package org.tamina.net;

import js.Promise;
import js.html.ProgressEvent;
import haxe.MimeType;
import org.tamina.net.URL;
import org.tamina.utils.UID;
import org.tamina.events.XMLHttpRequestEvent;
import org.tamina.log.QuickLogger;
import js.html.XMLHttpRequest;
import js.Error;

import haxe.Json;
import haxe.HTTPMethod;

class BaseRequest<Header, Response> {

    private var _httpRequest:XMLHttpRequest;
    private var _contentType:MimeType;
    private var _header:Header;

    private var _id:Float;
    public var id(get, null):Float;


    public function new( remoteMethod:String, method:HTTPMethod = HTTPMethod.POST, ?contentType:MimeType = MimeType.JSON ) {
        _id = UID.getUID();
        _contentType = contentType;
        // completeSignal = new Signal1<ProgressEvent>();
        // errorSignal = new Signal0();
        _httpRequest = new XMLHttpRequest();
        _httpRequest.upload.addEventListener(XMLHttpRequestEvent.PROGRESS, uploadHandler) ;
        
        _httpRequest.addEventListener(XMLHttpRequestEvent.ERROR, errorHandler);
        _httpRequest.addEventListener(XMLHttpRequestEvent.PROGRESS, progressHandler);
        _httpRequest.open(method, remoteMethod, true);

        _httpRequest.setRequestHeader("Content-Type", _contentType+"; charset=utf-8");
    }

    public function setHeaders(header:Header ):Void {

        _header = header;
    }

    public function get_id( ):Float {
        return _id;
    }

    public function send( ):Promise<Response> {
        return new Promise(function(resolve, reject){
            _httpRequest.addEventListener(XMLHttpRequestEvent.LOAD, function( result:ProgressEvent ):Void {
                var req:XMLHttpRequest = cast result.target;
                try {
                    var p:Response = Json.parse(req.response);
                    resolve(p);
                } catch ( e:Dynamic ) {
                    QuickLogger.error(e);
                    reject(new Error("lalalal"));
                }
            });

            _httpRequest.send(Json.stringify(getRequestContent()));            
        });
    }

    public function abort( ):Void {
        _httpRequest.abort();
    }

    private function uploadHandler( progress:ProgressEvent ):Void {
        QuickLogger.info('uploading ' + progress.loaded + "/" + progress.total);
    }

    private function getRequestContent( ):Header {
        return _header;
    }

    private function progressHandler( progress:ProgressEvent ):Void {
        QuickLogger.info('downloading ' + progress.loaded + "/" + progress.total);

    }

    private function errorHandler( error:Dynamic ):Void {
        QuickLogger.error(error);
    }
}
