package org.tamina.unit;
import haxe.Timer;
import js.Error;
import haxe.PosInfos;
class TestCase extends haxe.unit.TestCase {
    public function new() {
        super();
    }

    function assertError<T>( func:Void->Void, Err:T, ?c : PosInfos ) : Void {
        currentTest.done = true;
        currentTest.success = false;
        currentTest.error   = "exception non catché";
        currentTest.posInfos = c;
        try{
            func();
        } catch(e:Error){

            if(Std.is(e,Err)){
             currentTest.success = true;
            } else {
                currentTest.error   = "exception inconnue";
            }
        }
        if(!currentTest.success){
            throw currentTest;
        }

    }

    function assertAsync(func:Timer->Void,timeout:Int=3000):Void{
        var t = Timer.delay(asyncTimeOutHandler,timeout);
        func(t);

    }

    function endAsyncTest(t:Timer):Void{
        t.stop();
    }

    private function asyncTimeOutHandler():Void{
        trace('qsdqdsq');
    }
}
