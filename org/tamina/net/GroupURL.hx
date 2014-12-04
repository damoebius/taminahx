package org.tamina.net;
class GroupURL {

    public var loadingType:ScriptLoadingType;

    private var _pool:Array<URL>;
    private var _cacheKiller:Void->Dynamic;

    public function new(type:ScriptLoadingType = ScriptLoadingType.SEQUENCE, cacheKiller:Void->Dynamic=null) {
        loadingType = type;
        _pool = new Array<URL>();
        _cacheKiller = cacheKiller;
    }

    public function add(url:URL):Void{
        _pool.push(url);
    }

    public function toArray():Array<URL>{
        var result = new Array<URL>();
        for(i in 0..._pool.length){
            var path = _pool[i].path;
            if(_cacheKiller != null){
                path += '?cacheKiller=' + _cacheKiller();
            }
            result.push( new URL(path)) ;
        }
        return result;
    }

}
