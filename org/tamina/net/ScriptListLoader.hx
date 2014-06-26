package org.tamina.net;
import org.tamina.log.QuickLogger;
import msignal.Signal;

class ScriptListLoader {

    public var completeSignal:Signal0;
    public var errorSignal:Signal0;

    private var _pool:Array<URL>;
    private var _loader:ScriptLoader;

    public function new() {
        completeSignal = new Signal0();
        errorSignal = new Signal0();
        _loader = new ScriptLoader();
        _loader.completeSignal.add(scriptCompleteHandler);
        _loader.errorSignal.add(scriptErrorHandler);
    }

    public function load(scripts:Array<URL>):Void {
        _pool = scripts;
        loadNextScript();
    }

    private function scriptCompleteHandler():Void {
        loadNextScript();
    }

    private function scriptErrorHandler():Void {
        loadNextScript();
    }

    private function loadNextScript():Void {
        if (_pool.length > 0) {
            _loader.load(_pool.shift());
        } else {
            QuickLogger.info("ALL SCRIPTS LOADED");
            completeSignal.dispatch();
        }
    }
}
