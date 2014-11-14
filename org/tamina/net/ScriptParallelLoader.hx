package org.tamina.net;
import org.tamina.log.QuickLogger;
import msignal.Signal.Signal0;
class ScriptParallelLoader {

    public var completeSignal:Signal0;
    public var errorSignal:Signal0;

    private var _pool:Array<URL>;
    private var _remainingScriptNumber:Int=0;

    public function new() {
        completeSignal = new Signal0();
        errorSignal = new Signal0();
        _pool = new Array<URL>();
    }

    public function load(scripts:Array<URL>):Void {
        _pool = scripts;
        _remainingScriptNumber = _pool.length;
        start();
    }

    private function start():Void{
        for(i in 0..._pool.length){
            var l = new ScriptLoader();
            l.completeSignal.add(scriptCompleteHandler);
            l.errorSignal.add(scriptErrorHandler);
            l.load(_pool[i]);
        }
    }

    private function scriptCompleteHandler():Void {
        _remainingScriptNumber--;
        if(_remainingScriptNumber == 0){
            completeSignal.dispatch();
        }
    }

    private function scriptErrorHandler():Void {
        QuickLogger.error('error while loading script');
        _remainingScriptNumber--;
        if(_remainingScriptNumber == 0){
            completeSignal.dispatch();
        }
    }
}
