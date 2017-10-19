package org.tamina.net;

import js.Promise;
import js.Error;
import org.tamina.log.QuickLogger;

class AssetParallelLoader extends BaseAssetsLoader{

    private var _remainingAssetNumber:Int=0;

    public function new() {
        super();
    }

    override public function load(assets:Array<AssetURL>):Promise<Bool> {
        _pool = assets;
        _remainingAssetNumber = _pool.length;
        return new Promise(start);
    }

    private function start(resolve:Bool->Void,reject:Array<Error>->Void):Void{
        _resolve = resolve;
        _reject = reject;
        for(i in 0..._pool.length){
            var l = new AssetLoader();
            l.load(_pool[i]).then(assetCompleteHandler).catchError(assetErrorHandler);
        }
    }

    private function assetCompleteHandler(value:Bool):Void {
        _remainingAssetNumber--;
        if(_remainingAssetNumber == 0){
            end();
        }
    }

    private function assetErrorHandler(error:Error):Void {
        L.error('error while loading asset');
        _remainingAssetNumber--;
        _errors.push(error);
        if(_remainingAssetNumber == 0){
            end();
        }
    }
}
