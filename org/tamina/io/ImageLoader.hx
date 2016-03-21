package org.tamina.io;

import org.tamina.events.html.ImageEvent;
import haxe.Timer;
import js.Browser;
import msignal.Signal.Signal1;
import js.html.Image;
import org.tamina.net.URL;

/**
 * The ImageLoader class downloads image data from a URL. It is useful for downloading images files, to be used in a dynamic, data-driven application.<br>
 *
 * @module Tamina
 * @class ImageLoader
 */
class ImageLoader {

/**
 * Dispatched after all the received data is decoded and placed in the src property of the Image object.
 * @property complete
 * @readOnly
 * @type Signal1<{js.html.Image}>
 */
    public var complete:Signal1<Image>;

/**
 * Returns a data URI containing a representation of the image
 * @property dataURL
 * @readOnly
 * @type String
 */
    public var dataURL(get, null):String;

/**
 * The Image received from the load operation.
 * @property image
 * @readOnly
 * @type js.html.Image
 */
    public var image(get, null):Image;


    private var _image:Image;

    private function get_image():Image {
        return _image;
    }
    private function get_dataURL():String {
        var result = '';
        if(_image != null){
            result = _image.src;
        }
        return result;
    }

/**
    * @constructor
    * @method new
    * @example
     *      var l = new ImageLoader();
     *      var img = l.image;
     *      l.load(iconURL);
    */
    public function new():Void {
        _image = new Image();
        _image.crossOrigin = "anonymous";
        complete = new Signal1<Image>();
    }

/**
	 * Sends and loads data from the specified URL.
	 * @method load
	 * @param	url {URL} A string representing the attribute's name
	 */
    public function load(url:URL):Void {
        _image.addEventListener(ImageEvent.LOAD, imageLoadHandler, false);
        _image.src = url.path;
    }

    private function imageLoadHandler(event:js.html.Event):Void {
        _image.removeEventListener(ImageEvent.LOAD, imageLoadHandler);
        var canvas = Browser.document.createCanvasElement();
        canvas.width = _image.width;
        canvas.height = _image.height;
        var ctx = canvas.getContext2d();
        ctx.drawImage(_image, 0, 0, _image.width, _image.height);

        var outputImage = new Image();
        outputImage.src = canvas.toDataURL();

        Timer.delay( function(){ complete.dispatch(outputImage);},200);
    }
}
