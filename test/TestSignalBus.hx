package test;

import msignal.Signal;

import org.tamina.signal.SignalBus;
import org.tamina.signal.Signal3;

class TestSignalBus extends SignalBus {
	private var signal0:Signal0;
	private var signal1:Signal1<Int>;
	private var signal2:Signal2<Int, Int>;
	private var signal3:Signal3<Int, Int, Int>;

	public static function main():Void {
		var test = TestSignalBus.instance;

		test.signal0.add(test.signal0Handler);
		test.signal1.add(test.signal1Handler);
		test.signal2.add(test.signal2Handler);
		test.signal3.add(test.signal3Handler);

		test.signal0.dispatch();
		test.signal1.dispatch(42);
		test.signal2.dispatch(13, 37);
		test.signal3.dispatch(42, 13, 37);
	}

	public function signal0Handler():Void {
		trace("signal0 handler");
	}

	public function signal1Handler(a:Int):Void {
		trace('signal1 handler [$a]');
	}

	public function signal2Handler(a:Int, b:Int):Void {
		trace('signal2 handler [$a,$b]');
	}

	public function signal3Handler(a:Int, b:Int, c:Int):Void {
		trace('signal3 handler [$a,$b,$c]');
	}
}
