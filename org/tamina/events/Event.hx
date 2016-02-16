package org.tamina.events;

/**
* The Event class is used as the base class for the creation of Event objects, which are passed as parameters to event listeners when an event occurs.
 * <br>
 * The properties of the Event class carry basic information about an event, such as the event's type or whether the event's default behavior can be canceled. For many events, such as the events represented by the Event class constants, this basic information is sufficient. Other events, however, may require more detailed information.
 * The methods of the Event class can be used in event listener functions to affect the behavior of the event object.
*
*     typedef SakuraEvent = Event<SakuraEventType>;
*
*     enum abstract SakuraEventType(String) from String to String {
*           var LOADING = "loading";
*       }
*
*       ExternalEventBus.instance.send(new SakuraEvent(SakuraEventType.PROGRESS, new Progress(0, 0))) ;
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
