package org.tamina.events;

/**
* Base class for event object
* @class Event[T]
*/
class Event<T> {

/** The event type
     * @property type
     * @type T
     */
    public var type:T;

/** An object
     * @property data
     * @type Dynamic
     */
    public var data:Dynamic;

/**
    * @constructor
    * @method new
    * @param	type {T} the event type
    * @param    {Dynamic} [data] an object
    * @example
    *       typedef SakuraEvent = Event<SakuraEventType>;
    *
    *       enum abstract SakuraEventType(String) from String to String {
    *           var LOADING = "loading";
    *       }
    *
    *       ExternalEventBus.instance.send(new SakuraEvent(SakuraEventType.PROGRESS, new Progress(0, 0))) ;
    */

    public function new( type:T, ?data:Dynamic ) {
        this.type = type;
        this.data = data;
    }
}
