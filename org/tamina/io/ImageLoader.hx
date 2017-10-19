package org.tamina.io;

import js.Promise;
import org.tamina.events.html.ImageEvent;
import js.Browser;
import js.html.Image;
import org.tamina.net.URL;
import js.Error;

/**
 * The ImageLoader class downloads image data from a URL. It is useful for downloading images files, to be used in a dynamic, data-driven application.<br>
 *
 * @module Tamina
 * @class ImageLoader
 */
class ImageLoader {


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
    private var _toDataURL:Bool;
    private var _url:URL;
    private var _resolve:Image->Void;
    private var _reject:Error->Void;

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
    public function new(?toDataURL:Bool = true):Void {
        _image = new Image();
        _image.crossOrigin = "anonymous";
    }

/**
	 * Sends and loads data from the specified URL.
	 * @method load
	 * @param	url {URL} A string representing the attribute's name
	 */
    public function load(url:URL):Promise<Image> {
        _url = url;
        _image.addEventListener(ImageEvent.LOAD, imageLoadHandler, false);
        _image.addEventListener(ImageEvent.ERROR, imageLoadErrorHandler, false);
        return new Promise<Image>(start);
    }

    private function start(resolve:Image->Void,reject:Error->Void):Void{
        _resolve = resolve;
        _reject = reject;
        _image.src = _url.path;
    }

    private function imageLoadErrorHandler(event:js.html.Event):Void {
        _image.removeEventListener(ImageEvent.LOAD, imageLoadHandler);
        _image.removeEventListener(ImageEvent.ERROR, imageLoadErrorHandler);

        _reject(new Error("Error while loading : " + _url.path));
    }

    private function imageLoadHandler(event:js.html.Event):Void {
        _image.removeEventListener(ImageEvent.LOAD, imageLoadHandler);
        _image.removeEventListener(ImageEvent.ERROR, imageLoadErrorHandler);

        if (_toDataURL) {
            var canvas = Browser.document.createCanvasElement();
            canvas.width = _image.width;
            canvas.height = _image.height;
            var ctx = canvas.getContext2d();
            ctx.drawImage(_image, 0, 0, _image.width, _image.height);

            var outputImage = new Image();
            outputImage.src = canvas.toDataURL();
            _resolve(outputImage);
        } else {
            _resolve(_image);
        }
    }
}
