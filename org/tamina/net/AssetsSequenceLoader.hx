package org.tamina.net;

import js.Promise;
import js.Error;

class AssetsSequenceLoader extends BaseAssetsLoader {

    public function new() {
        super();
    }

    override public function load(assets:Array<AssetURL>):Promise<Bool> {
        _pool = assets;
        return new Promise(loadNextAsset);
    }

    private function assetCompleteHandler(value:Bool):Void {
        loadNextAsset(_resolve,_reject);
    }

    private function assetErrorHandler(error:Error):Void {
        _errors.push(error);
        loadNextAsset(_resolve,_reject);
    }

    private function loadNextAsset(resolve:Bool->Void,reject:Array<Error>->Void):Void {
        _resolve = resolve;
        _reject = reject;
        if (_pool.length > 0) {
            _loader.load(_pool.shift()).then(assetCompleteHandler).catchError(assetErrorHandler);
        } else {
            end();
        }
    }
}
