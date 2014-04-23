package org.tamina.display;
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
        var tempContext:CanvasRenderingContext2D = cast tempCanvas.getContext( CanvasRenderingContextType._2D.toString() );
        tempContext.transform(scale, 0, 0, scale, 0, 0);
        tempContext.drawImage(source,0,0);
        result = tempCanvas.toDataURL(type.toString());
        tempContext = null;
        try{
            tempCanvas.remove();
        } catch (e:Dynamic) {
            tempCanvas = null;
        }


        return result;
    }
}
