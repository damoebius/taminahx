package org.tamina.net;

class AssetListLoader {

    private var _pool:Array<AssetURL>;
    private var _loader:AssetLoader;

    public function new() {
        _pool = new Array<AssetURL>();
        _loader = new AssetLoader();
        _loader.completeSignal.add(assetCompleteHandler);
        _loader.errorSignal.add(assetErrorHandler);
    }

    public function load(assets:Array<AssetURL>):Void {
        _pool = assets;
        loadNextAsset();
    }

    private function assetCompleteHandler():Void {
        loadNextAsset();
    }

    private function assetErrorHandler():Void {
        loadNextAsset();
    }

    private function loadNextAsset():Void {
        if (_pool.length > 0) {
            _loader.load(_pool.shift());
        } else {
            //completeSignal.dispatch();
        }
    }
}
