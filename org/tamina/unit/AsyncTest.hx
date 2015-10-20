package org.tamina.unit;
import js.Error;
import haxe.PosInfos;
import haxe.Timer;
class AsyncTest extends haxe.unit.TestCase {

    private var _name:String="noname";
    private var _timeout:Int=3000;
    private var _timer:Timer;
    private var _callBack:Void->Void;

    public function new(name:String, callBack:Void->Void, timeout=3000) {
        _name = name;
        _timeout = timeout;
        _callBack = callBack;
        super();
    }

    override function assertTrue( b:Bool, ?c : PosInfos ) : Void {
        currentTest.done = true;
        if (b != true){
            currentTest.success = false;
            currentTest.error   = "expected true but was false";
            currentTest.posInfos = c;
            printError();
        } else {
            printSuccess();
        }
    }



    public function assertError<T>( func:Void->Void, Err:T, ?c : PosInfos ) : Void {
        currentTest.done = true;
        currentTest.success = false;
        currentTest.error   = "exception non catché";
        currentTest.posInfos = c;
        try{
            func();
        } catch(error:Error){

            if(Std.is(error,Err)){
                currentTest.success = true;
            } else {
                currentTest.error   = "exception inconnue";
            }
        }
        if(!currentTest.success){
            printError();
        } else {
            printSuccess();
        }

    }

    public function run(func:Void->Void):Void{
        _timer = Timer.delay(asyncTimeOutHandler,_timeout);
        func();
    }

    private function asyncTimeOutHandler():Void{
        trace('AsyncTest FAIL : ' + _name);
        currentTest.error   = "TIME OUT";
        printError();
        _callBack();
    }

    private function printError():Void{
       print('##### ERR:'+ currentTest.classname+'('+ currentTest.posInfos.methodName + ' ' + currentTest.posInfos.lineNumber + ') - ' + currentTest.error );
    }

    private function printSuccess():Void{
        if(currentTest.posInfos != null ){
            print('[ OK ]:'+ currentTest.classname+'('+ currentTest.posInfos.methodName +')' );
        } else {
            print('[ OK ]:'+ currentTest.classname );
        }
    }
}
