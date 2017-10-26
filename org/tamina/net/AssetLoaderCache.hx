/*
* SakuraEditor
* Visit http://storage.sakuradesigner.microclimat.com/apps/api/ for documentation, updates and examples.
*
* Copyright (c) 2014 microclimat, inc.
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/
package org.tamina.net;

/**
* This is the description for my class.
* @author d.mouton
* @class AssetLoaderCache
* @constructor
*/
import js.Browser;
import js.html.Element;
import js.html.LinkElement;
import js.html.ScriptElement;
class AssetLoaderCache {

    private var _cache(get, set):Cache;

    public function new() {
        if (_cache == null) {
            _cache = new Cache();
        }
    }

    /**
    * @method getLoadingAsset
    * @param {AssetURL} url
    * @return {Element}
    **/
    public function getLoadingAsset(url:AssetURL):Element {
        var result:Element = null;

        for (i in 0..._cache.assetsLoading.length) {
            var asset = _cache.assetsLoading[i];
            switch (url.assetType) {
                case JS:
                    var script:ScriptElement = cast asset;
                    if (script.src == url.path) {
                        result = asset;
                        break;
                    }

                case CSS:
                    var link:LinkElement = cast asset;
                    if (link.href == url.path) {
                        result = asset;
                        break;
                    }
            }
        }
        return result;
    }

    public function isLoaded(assetUrl:URL):Bool{
        return _cache.assetsLoaded.indexOf(assetUrl.path) >= 0;
    }

    public function addLoadedAsset(assetUrl:URL):Void{
        _cache.assetsLoaded.push(assetUrl.path);
    }

    public function addLoadingAsset(asset:Element):Void{
        _cache.assetsLoading.push(asset);
    }

    public function removeLoadingAsset(asset:Element):Void{
        _cache.assetsLoading.remove(asset);
    }

    private function set__cache(value:Cache):Cache {
        Reflect.setField(Browser.window,'assetLoaderCache',value);
        return null;
    }

    private function get__cache():Cache {
        return cast Reflect.field(Browser.window,'assetLoaderCache');
    }
}

private class Cache {
    public var assetsLoaded:Array<String>;
    public var assetsLoading:Array<Element>;

    public function new() {
        assetsLoaded = new Array<String>();
        assetsLoading = new Array<Element>();
    }
}
