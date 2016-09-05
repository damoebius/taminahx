package org.tamina.events;

import js.html.Event;
import js.html.FileList;

class UploadFilesEvent extends Event {

    public static inline var EVENT_TYPE:String = "uploadfiles";

    public var files:FileList;

}