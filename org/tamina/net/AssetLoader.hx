package org.tamina.net;

import org.tamina.net.AssetType;
import org.tamina.net.AssetType;
import js.Promise;
import haxe.ds.Either;
import js.Browser;
import js.html.Element;
import js.html.ScriptElement;
import js.html.LinkElement;

import org.tamina.log.QuickLogger;

class AssetLoader {

    private var _header:Element;
    private var _url:AssetURL;
    private var _asset:Element;
    private var _cache:AssetLoaderCache;
    private var _resolve:Bool->Void;
    private var _reject:Bool->Void;

    public function new() {
        _cache = new AssetLoaderCache();
    }

    public function load(url:AssetURL):Promise<Bool> {
        _url = url;
        _asset = _cache.getLoadingAsset(_url);

        return new Promise(loadPromise);
    }

    private function loadPromise(resolve:Bool->Void,reject:Bool->Void):Void{
        _resolve = resolve;
        _reject = reject;
        if ( _cache.isLoaded(_url) ) {
            L.info('Asset already loaded : ' + _url.documentName);
            loadCompleteHandler();
        } else if( _asset != null){
            L.info('Loading asset : ' + _url.documentName);
            _asset.addEventListener('load', loadCompleteHandler) ;
            _asset.addEventListener('error', loadErrorHandler) ;
        } else {
            L.info('Loading ' + _url.path);

            var tagName:String = 'script';
            if (_url.assetType == AssetType.CSS) tagName = 'link';

            _asset = Browser.document.createElement(tagName);
            _asset.addEventListener('load', loadCompleteHandler) ;
            _asset.addEventListener('error', loadErrorHandler) ;
            _cache.addLoadingAsset(_asset);

            switch (_url.assetType) {
                case AssetType.JS:
                    var script:ScriptElement = cast _asset;
                    script.type = 'text/javascript';
                    script.src = _url.path;

                case AssetType.CSS:
                    var link:LinkElement = cast _asset;
                    link.type = 'text/css';
                    link.rel = 'stylesheet';
                    link.href = _url.path;
            }
            _header = cast Browser.document.getElementsByTagName('head')[0];
            _header.appendChild(_asset);
        }
    }

    private function loadCompleteHandler(?event:Dynamic):Void {
        QuickLogger.info('asset loaded');
        _cache.addLoadedAsset(_url);
        _cache.removeLoadingAsset(_asset);
        _resolve(true);
    }

    private function loadErrorHandler(event:Dynamic):Void {
        _cache.removeLoadingAsset(_asset);
        _reject(false);
    }
}
