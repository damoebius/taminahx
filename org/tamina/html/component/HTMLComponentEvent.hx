package org.tamina.html.component;
import js.html.Event;

@:native("Event")
extern class HTMLComponentEvent extends Event {

}

@:enum abstract HTMLComponentEventType(String) from String to String {

    public var CREATION_COMPLETE = "creationComplete";
    public var INITIALIZE = "initialize";
}
