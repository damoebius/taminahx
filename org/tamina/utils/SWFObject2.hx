package org.tamina.utils;

import js.html.Element;
typedef SuccessEvent = {
    var success:Bool;
    var id:String;
    var ref:Element;
}

typedef FlashPlayerVersion = {
    var major:Int;
    var minor:Int;
    var release:Int;
}

@:native("swfobject")
extern class SWFObject2 {

    static function registerObject( objectId:String, swfVersion:String, xiSwfUrl :String, ?callback:SuccessEvent->Void ):Void;

    static function getObjectById(objectId:String):Element;

    static function embedSWF(swfUrl:String, replaceElemId:String, width:Int, height:Int, swfVersion:String, ?xiSwfUrl:String, ?flashvars:Dynamic, ?par:Dynamic, ?att:Dynamic, ?callback:SuccessEvent->Void):Void;

    static function getFlashPlayerVersion():FlashPlayerVersion;

    static function hasFlashPlayerVersion(version:String):Bool;

    static function createSWF(att:Dynamic, par:Dynamic, replaceElemId:String):Element;
}