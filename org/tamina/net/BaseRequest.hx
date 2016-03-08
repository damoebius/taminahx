package org.tamina.net;

import js.html.ProgressEvent;
import haxe.MimeType;
import org.tamina.net.URL;
import msignal.Signal;
import org.tamina.utils.UID;
import org.tamina.events.XMLHttpRequestEvent;
import org.tamina.log.QuickLogger;
import js.html.XMLHttpRequest;

import haxe.Json;
import haxe.HTTPMethod;

class BaseRequest {

    private var _httpRequest:XMLHttpRequest;

    public var completeSignal:Signal1<ProgressEvent>;
    public var errorSignal:Signal0;


    private var _id:Float;
    public var id(get, null):Float;


    public function new( remoteMethod:String, method:HTTPMethod = HTTPMethod.POST ) {
        _id = UID.getUID();
        completeSignal = new Signal1<ProgressEvent>();
        errorSignal = new Signal0();
        _httpRequest = new XMLHttpRequest();
        _httpRequest.upload.addEventListener(XMLHttpRequestEvent.PROGRESS, uploadHandler) ;
        _httpRequest.addEventListener(XMLHttpRequestEvent.LOAD, successHandler);
        _httpRequest.addEventListener(XMLHttpRequestEvent.ERROR, errorHandler);
        _httpRequest.addEventListener(XMLHttpRequestEvent.PROGRESS, progressHandler);
        _httpRequest.open(method, remoteMethod, true);
        _httpRequest.setRequestHeader("Content-Type", MimeType.JSON+"; charset=utf-8");
    }

    public function get_id( ):Float {
        return _id;
    }

    public function send( ):Void {
        QuickLogger.debug(getRequestContent());
        _httpRequest.send(Json.stringify(getRequestContent()));
    }

    public function abort( ):Void {
        _httpRequest.abort();
    }

    private function uploadHandler( progress:ProgressEvent ):Void {
        QuickLogger.info('uploading ' + progress.loaded + "/" + progress.total);
    }

    private function getRequestContent( ):Dynamic {
        var data:Dynamic = { };
        return data;
    }

    private function successHandler( result:ProgressEvent ):Void {
        var req:XMLHttpRequest = cast result.target;
        try {
            var p = Json.parse(req.response);
            completeSignal.dispatch(result);
        } catch ( e:Dynamic ) {
            QuickLogger.error('la reponse pas json : ' + req.response);
            errorSignal.dispatch();
        }
    }

    private function progressHandler( progress:ProgressEvent ):Void {
        QuickLogger.info('downloading ' + progress.loaded + "/" + progress.total);

    }

    private function errorHandler( error:Dynamic ):Void {
        QuickLogger.error(error);
    }
}
