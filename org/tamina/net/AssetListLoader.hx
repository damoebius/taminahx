package org.tamina.net;
import org.tamina.log.QuickLogger;
import msignal.Signal;

class AssetListLoader {

    public var completeSignal:Signal0;
    public var errorSignal:Signal0;

    private var _pool:Array<AssetURL>;
    private var _loader:AssetLoader;

    public function new() {
        completeSignal = new Signal0();
        errorSignal = new Signal0();
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
            completeSignal.dispatch();
        }
    }
}
