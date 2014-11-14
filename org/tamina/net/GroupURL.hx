package org.tamina.net;
class GroupURL {

    public var loadingType:ScriptLoadingType;

    private var _pool:Array<URL>;
    private var _cacheKiller:Void->String;

    public function new(type:ScriptLoadingType = ScriptLoadingType.SEQUENCE, cacheKiller:Void->String=null) {
        loadingType = type;
        _pool = new Array<URL>();
        _cacheKiller = cacheKiller;
    }

    public function add(url:URL):Void{
        if(_cacheKiller != null){
           url.path += '?cacheKiller=' + _cacheKiller();
        }
        _pool.push(url);
    }

    public function toArray():Array<URL>{
        return _pool;
    }

}
