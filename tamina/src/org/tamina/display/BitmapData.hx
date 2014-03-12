package org.tamina.display;
import org.tamina.display.CanvasRenderingContextType.CanvasRenderingContextTypes;
import org.tamina.html.MimeType;
import js.html.Image;
import js.html.CanvasRenderingContext2D;
import js.Browser;
class BitmapData {

    public static function toDataUrl(source:Image,width:Int, height:Int, type:MimeType):String{
        var result = '';
        var tempCanvas = Browser.document.createCanvasElement();
        tempCanvas.width = width;
        tempCanvas.height = height;
        var tempContext:CanvasRenderingContext2D = cast tempCanvas.getContext(CanvasRenderingContextTypes.toString( CanvasRenderingContextType._2D) );
        tempContext.drawImage(source,0.0,0.0,width,height);
        result = tempCanvas.toDataURL(MimeTypes.toString(type));
        tempContext = null;
        tempCanvas.remove();
        return result;
    }
}
