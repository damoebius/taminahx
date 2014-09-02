package org.tamina.display;
import org.tamina.log.QuickLogger;
import org.tamina.html.MimeType;
import js.html.Image;
import js.html.CanvasRenderingContext2D;
import js.Browser;

using org.tamina.display.CanvasRenderingContextType;
using org.tamina.html.MimeType;

class BitmapData {

    public static function toDataUrl(source:Image,width:Int, height:Int,scale:Float, type:MimeType):String{
        var result = '';
        var tempCanvas = Browser.document.createCanvasElement();
        tempCanvas.width = width;
        tempCanvas.height = height;
        var tempContext = tempCanvas.getContext2d();
        tempContext.drawImage(source,0,0,source.width,source.height,0,0,width,height); //slow
        result = tempCanvas.toDataURL(type);
        tempContext = null;
        try{
            tempCanvas.remove();
        } catch (e:Dynamic) {
            tempCanvas = null;
        }


        return result;
    }
}
