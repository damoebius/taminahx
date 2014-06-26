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
* @class ScriptLoaderCache
* @constructor
*/
import js.html.ScriptElement;
import js.Browser;
class ScriptLoaderCache {

    private var _cache(get, set):Cache;


/**
    * @constructor
    */

    public function new() {
        if (_cache == null) {
            _cache = new Cache();
        }
    }

    public function getLoadingScript(url:URL):ScriptElement{
        var result:ScriptElement = null;
        for(i in 0..._cache.scriptsLoading.length){
            var script = _cache.scriptsLoading[i];
            if(script.src == url.path){
                result = script;
                break;
            }
        }
        return result;
    }

    public function isLoaded(scriptUrl:URL):Bool{
        return _cache.scriptsLoaded.indexOf(scriptUrl.path) >= 0;
    }

    public function addLoadedScript(scriptUrl:URL):Void{
        _cache.scriptsLoaded.push(scriptUrl.path);
    }

    public function addLoadingScript(script:ScriptElement):Void{
        _cache.scriptsLoading.push(script);
    }

    public function removeLoadingScript(script:ScriptElement):Void{
        _cache.scriptsLoading.remove(script);
    }

    private function set__cache(value:Cache):Cache {
        Reflect.setField(Browser.window,'scriptLoaderCache',value);
        return null;
    }

    private function get__cache():Cache {
        return cast  Reflect.field(Browser.window,'scriptLoaderCache');
    }
}

private class Cache {
    public var scriptsLoaded:Array<String>;
    public var scriptsLoading:Array<ScriptElement>;

    public function new() {
        scriptsLoaded = new Array<String>();
        scriptsLoading = new Array<ScriptElement>();
    }
}
