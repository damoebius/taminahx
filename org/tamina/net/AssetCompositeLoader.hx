package org.tamina.net;
import org.tamina.log.QuickLogger;
import msignal.Signal.Signal0;

class AssetCompositeLoader {

    public var completeSignal:Signal0;
    public var errorSignal:Signal0;

    private var _pool:Array<GroupURL>;

    public function new() {
        completeSignal = new Signal0();
        errorSignal = new Signal0();
        _pool = new Array<GroupURL>();
    }

    public function add(group:GroupURL):Void{
        _pool.push(group);
    }

    public function start():Void{
        loadNextGroup();
    }

    private function loadNextGroup():Void {
        if (_pool.length > 0) {
            var g = _pool.shift();
            if(g.loadingType == AssetLoadingType.SEQUENCE){
                var loader = new AssetListLoader();
                loader.completeSignal.add(assetCompleteHandler);
                loader.errorSignal.add(assetErrorHandler);
                loader.load(g.toArray());
            } else {
                var loader = new AssetParallelLoader();
                loader.completeSignal.add(assetCompleteHandler);
                loader.errorSignal.add(assetErrorHandler);
                loader.load(g.toArray());
            }
        } else {
            QuickLogger.info("ALL ASSETS LOADED");
            completeSignal.dispatch();
        }
    }

    private function assetCompleteHandler():Void {
        loadNextGroup();
    }

    private function assetErrorHandler():Void {
        loadNextGroup();
    }
}
