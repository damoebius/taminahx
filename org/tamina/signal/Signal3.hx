/*
* SakuraEditor
* Visit http://storage.sakuradesigner.microclimat.com/apps/api/ for documentation, updates and examples.
*
* Copyright (c) 2014 microclimat, inc.
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/
package org.tamina.signal;

import msignal.Slot;
import msignal.Signal;

using msignal.Signal;

class Signal3<TValue1, TValue2, TValue3> extends Signal<Slot3<TValue1, TValue2, TValue3>, TValue1 -> TValue2 -> TValue3 -> Void> {

/**
    * @constructor
    */
    public function new(?type1:Dynamic=null, ?type2:Dynamic=null, ?type3:Dynamic=null) {
        super([type1, type2, type3]);
    }

    public function dispatch(value1:TValue1, value2:TValue2, value3:TValue3)
    {
        var slotsToProcess = slots;

        while (slotsToProcess.nonEmpty)
        {
            slotsToProcess.head.execute(value1, value2, value3);
            slotsToProcess = slotsToProcess.tail;
        }
    }

    override function createSlot(listener:TValue1 -> TValue2 -> TValue3 -> Void, ?once:Bool=false, ?priority:Int=0)
    {
        return new Slot3<TValue1, TValue2, TValue3>(this, listener, once, priority);
    }
}

class Slot3<TValue1, TValue2, TValue3> extends Slot<Signal3<TValue1, TValue2, TValue3>, TValue1 -> TValue2 -> TValue3 -> Void>
{
/**
		Allows the slot to inject the first argument to dispatch.
	**/
    public var param1:Dynamic;

/**
		Allows the slot to inject the second argument to dispatch.
	**/
    public var param2:Dynamic;

    public var param3:Dynamic;

    public function new(signal:Signal3<TValue1, TValue2,TValue3>, listener:TValue1 -> TValue2 -> TValue3 -> Void, ?once:Bool=false, ?priority:Int=0)
    {
        super(signal, listener, once, priority);
    }

/**
		Executes a listener with two arguments.
		If <code>param1</code> or <code>param2</code> is set,
		they override the values provided.
	**/
    public function execute(value1:TValue1, value2:TValue2, value3:TValue3)
    {
        if (!enabled) return;
        if (once) remove();

        if (param1 != null) value1 = param1;
        if (param2 != null) value2 = param2;
        if (param3 != null) value3 = param3;

        listener(value1, value2, value3);
    }
}
