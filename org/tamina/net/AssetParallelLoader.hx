package org.tamina.net;

import org.tamina.log.QuickLogger;

class AssetParallelLoader {

    private var _pool:Array<AssetURL>;
    private var _remainingAssetNumber:Int=0;

    public function new() {
        _pool = new Array<AssetURL>();
    }

    public function load(assets:Array<AssetURL>):Void {
        _pool = assets;
        _remainingAssetNumber = _pool.length;
        start();
    }

    private function start():Void{
        for(i in 0..._pool.length){
            var l = new AssetLoader();
            l.completeSignal.add(assetCompleteHandler);
            l.errorSignal.add(assetErrorHandler);
            l.load(_pool[i]);
        }
    }

    private function assetCompleteHandler():Void {
        _remainingAssetNumber--;
        if(_remainingAssetNumber == 0){
            //completeSignal.dispatch();
        }
    }

    private function assetErrorHandler():Void {
        QuickLogger.error('error while loading asset');
        _remainingAssetNumber--;
        if(_remainingAssetNumber == 0){
            //completeSignal.dispatch();
        }
    }
}
