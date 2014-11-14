package org.tamina.net;
import org.tamina.log.QuickLogger;
import msignal.Signal.Signal0;
class ScriptCompositeLoader {

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
            if(g.loadingType == ScriptLoadingType.SEQUENCE){
                var loader = new ScriptListLoader();
                loader.completeSignal.add(scriptCompleteHandler);
                loader.errorSignal.add(scriptErrorHandler);
                loader.load(g.toArray());
            } else {
                var loader = new ScriptParallelLoader();
                loader.completeSignal.add(scriptCompleteHandler);
                loader.errorSignal.add(scriptErrorHandler);
                loader.load(g.toArray());
            }
        } else {
            QuickLogger.info("ALL SCRIPTS LOADED");
            completeSignal.dispatch();
        }
    }

    private function scriptCompleteHandler():Void {
        loadNextGroup();
    }

    private function scriptErrorHandler():Void {
        loadNextGroup();
    }
}
