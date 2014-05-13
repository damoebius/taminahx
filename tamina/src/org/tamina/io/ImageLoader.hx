package org.tamina.io;

import msignal.Signal.Signal1;
import js.html.Image;
import org.tamina.net.URL;
class ImageLoader {

    public var complete:Signal1<Image>;

    public var image(get,null):Image;
    private var _image:Image;

    private function get_image():Image {
        return _image;
    }

    public function new():Void{
        _image = new Image();
        complete = new Signal1<Image>();
    }

    public function load(url:URL):Void{
        _image.addEventListener('load', imageLoadHandler, false);
        _image.src = url.path;
    }

    private function imageLoadHandler(event:js.html.Event):Void{
       _image.removeEventListener('load',imageLoadHandler);
       complete.dispatch(_image);
    }
}
