package org.tamina.io;

import org.tamina.events.html.ImageEvent;
import haxe.Timer;
import js.Browser;
import msignal.Signal.Signal1;
import js.html.Image;
import org.tamina.net.URL;

class ImageLoader {

    public var complete:Signal1<Image>;

    public var image(get, null):Image;
    private var _image:Image;

    private function get_image():Image {
        return _image;
    }

    public function new():Void {
        _image = new Image();
        _image.crossOrigin = "anonymous";
        complete = new Signal1<Image>();
    }

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
