package org.tamina.net;

import js.Promise;
import org.tamina.log.QuickLogger;
import js.Error;

class AssetCompositeLoader {

    private var _pool:Array<GroupURL>;
    private var _resolve:Bool->Void;
    private var _reject:Array<Error>->Void;
    private var _errors:Array<Error>;

    public function new() {
        _pool = new Array<GroupURL>();
        _errors = new Array<Error>();
    }

    public function add(group:GroupURL):Void{
        _pool.push(group);
    }

    public function start():Promise<Bool>{
        return new Promise(loadNextGroup);
    }

    private function loadNextGroup(resolve:Bool->Void,reject:Array<Error>->Void):Void {
        _resolve = resolve;
        _reject = reject;
        if (_pool.length > 0) {
            var g = _pool.shift();
            if(g.loadingType == AssetLoadingType.SEQUENCE){
                var loader = new AssetsSequenceLoader();
                loader.load(g.toArray()).then(assetCompleteHandler).catchError(assetErrorHandler);
            } else {
                var loader = new AssetParallelLoader();
                loader.load(g.toArray()).then(assetCompleteHandler).catchError(assetErrorHandler);
            }
        } else {
            if(_errors.length == 0){
                L.info("ALL ASSETS LOADED");
                _resolve(true);
            } else {
                _reject(_errors);
            }
        }
    }

    private function assetCompleteHandler(value:Bool):Void {
        loadNextGroup(_resolve,_reject);
    }

    private function assetErrorHandler(errors:Array<Error>):Void {
        _errors = _errors.concat(errors);
        loadNextGroup(_resolve,_reject);
    }
}
