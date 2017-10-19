package org.tamina.net;

import js.Promise;
import js.Error;

class BaseAssetsLoader {

    private var _pool:Array<AssetURL>;
    private var _loader:AssetLoader;
    private var _resolve:Bool->Void;
    private var _reject:Array<Error>->Void;
    private var _errors:Array<Error>;

    public function new() {
        _pool = new Array<AssetURL>();
        _loader = new AssetLoader();
        _errors = new Array<Error>();
    }

    public function load(assets:Array<AssetURL>):Promise<Bool> {
        _pool = assets;
        return null;
    }

    private function end():Void{
        if(_errors.length == 0){
            _resolve(true);
        } else {
            _reject(_errors);
        }
    }
}
