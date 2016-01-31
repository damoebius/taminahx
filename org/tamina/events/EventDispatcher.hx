package org.tamina.events;

import haxe.ds.StringMap;

/**
* Dispatch Events
* @class EventDispatcher[T]
*/
class EventDispatcher<T:String> {


    private var _eventsCallback:StringMap<Array<Event<T> -> Void>>;

/**
    * @constructor
    * @method new
    */

    public function new( ) {

        _eventsCallback = new StringMap<Array<Event<T> -> Void>>();
    }

/**
	 * This method registers the specified listener on the target it's called on
	 * @method addEventListener
	 * @param	type {T} A string representing the event type to listen for.
	 * @param listener {Event}<T> -> Void The function that's called when an event of the specified type occurs.
	 * @example
	 *      _editor.addEventListener(SakuraEventType.CUSTOMER_DESIGN_ADDED, customerDesignAddedHandler);
	 *      private function customerDesignAddedHandler(evt:SakuraEvent):Void {
	 *      }
	 */
    public function addEventListener( type:T, listener:Event<T> -> Void ):Void {
        if ( !_eventsCallback.exists(type) ) {
            _eventsCallback.set(type, new Array<Event<T> -> Void>());
        }
        _eventsCallback.get(type).push(listener);
    }

/**
	 * Removes the event listener previously registered with addEventListener().
	 * @method removeEventListener
	 * @param	type {T} A string representing the event type to remove.
	 * @param listener {Event}<T> -> Void The EventListener function to remove from the event target.
	 * @example
	 *      _editor.removeEventListener(SakuraEventType.CUSTOMER_DESIGN_ADDED, customerDesignAddedHandler);
	 */
    public function removeEventListener( type:T, listener:Event<T> -> Void ):Void {
        if ( _eventsCallback.exists(type) ) {
            var events = _eventsCallback.get(type);
            events.remove(listener);
        }
    }

/**
	 * Removes all listeners previously registered with addEventListener() on a specific type.
	 * @method removeAllEventListeners
	 * @param	type {T} A string representing the event type to remove.
	 * @example
	 *      _editor.removeAllEventListeners(SakuraEventType.CUSTOMER_DESIGN_ADDED);
	 */
    public function removeAllEventListeners( type:T ):Void {
        if ( _eventsCallback.exists(type) ) {
            _eventsCallback.remove(type);
        }
    }

/**
	 * Dispatch an event to this EventDispatcher.
	 * @method dispatchEvent
	 * @param	event {Event}<T> event is the Event object to be dispatched.
	 * @example
	 *      this.dispatchEvent(new SakuraEvent(SakuraEventType.PROGRESS, new Progress(progress.loaded, progress.total))) ;
	 */
    public function dispatchEvent( event:Event<T> ):Void {
        if ( _eventsCallback.exists(event.type) ) {
            var events = _eventsCallback.get(event.type);
            for ( i in 0...events.length ) {
                events[i](event);
            }
        }
    }
}


