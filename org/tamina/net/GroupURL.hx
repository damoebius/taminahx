package org.tamina.net;
class GroupURL {

    public var loadingType:AssetLoadingType;

    private var _pool:Array<AssetURL>;
    private var _cacheKiller:Void->Dynamic;

    public function new(type:AssetLoadingType = AssetLoadingType.SEQUENCE, cacheKiller:Void->Dynamic=null) {
        loadingType = type;
        _pool = new Array<AssetURL>();
        _cacheKiller = cacheKiller;
    }

    public function add(url:URL, ?assetType:AssetType = AssetType.JS):Void {
        var assetURL:AssetURL = new AssetURL(url.path, assetType);
        _pool.push(assetURL);
    }

    public function toArray():Array<AssetURL>{
        var result = new Array<AssetURL>();
        for(i in 0..._pool.length){
            var path = _pool[i].path;
            if(_cacheKiller != null){
                path += '?cacheKiller=' + _cacheKiller();
            }

            var assetURL:AssetURL = new AssetURL(path);
            assetURL.assetType = _pool[i].assetType;
            result.push(assetURL) ;
        }
        return result;
    }

}
