package org.tamina.net;

import haxe.ds.Either;
import js.Browser;
import js.html.Element;
import js.html.ScriptElement;
import js.html.LinkElement;

import org.tamina.log.QuickLogger;
import msignal.Signal.Signal0;

class AssetLoader {

    public var completeSignal:Signal0;
    public var errorSignal:Signal0;

    private var _header:Element;
    private var _url:AssetURL;
    private var _asset:Element;
    private var _cache:AssetLoaderCache;

    public function new() {
        completeSignal = new Signal0();
        errorSignal = new Signal0();
        _cache = new AssetLoaderCache();
    }

    public function load(url:AssetURL):Void {
        _url = url;
        _asset = _cache.getLoadingAsset(_url);

        if ( _cache.isLoaded(_url) ) {
            QuickLogger.info('Asset déja chargé : ' + _url.documentName);
            loadCompleteHandler();
        } else if( _asset != null){
            QuickLogger.info('Asset en cours de chargement : ' + _url.documentName);
            _asset.addEventListener('load', loadCompleteHandler) ;
            _asset.addEventListener('error', loadErrorHandler) ;
        } else {
            addToHTML();
        }

    }

    private function addToHTML():Void {
        QuickLogger.info('chargement de ' + _url.path);

        var tagName:String = 'script';
        if (_url.assetType == CSS) tagName = 'link';

        _asset = Browser.document.createElement(tagName);
        _asset.addEventListener('load', loadCompleteHandler) ;
        _asset.addEventListener('error', loadErrorHandler) ;
        _cache.addLoadingAsset(_asset);

        switch (_url.assetType) {
            case JS:
            var script:ScriptElement = cast _asset;
            script.type = 'text/javascript';
            script.src = _url.path;

            case CSS:
            var link:LinkElement = cast _asset;
            link.type = 'text/css';
            link.rel = 'stylesheet';
            link.href = _url.path;
        }

        _header = cast Browser.document.getElementsByTagName('head')[0];
        _header.appendChild(_asset);
    }

    private function loadCompleteHandler(?event:Dynamic):Void {
        QuickLogger.info('asset loaded');
        _cache.addLoadedAsset(_url);
        _cache.removeLoadingAsset(_asset);
        completeSignal.dispatch();
    }

    private function loadErrorHandler(event:Dynamic):Void {
        _cache.removeLoadingAsset(_asset);
        errorSignal.dispatch();
    }
}
