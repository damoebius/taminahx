package org.tamina.display;
import haxe.MimeType;
import js.html.Image;
import js.html.CanvasRenderingContext2D;
import js.Browser;

/**
 * Utiliy to manipulte Bitmap
 * @class BitmapData
 * @static
 * @module Tamina
 */
class BitmapData {

/**
	 * Convert and Resize, an Image to base64 String
	 * @method toDataUrl
	 * @param	source {HTMLImageElement} the HTMLImageElement to convert
	 * @param width {Int} the new width
	 * @param height {Int} the new height
	 * @param type {MimeType} the output type
	 * @return {String} the base64 image data
	 * @example
	 *      var thumbBase64 = BitmapData.toDataUrl( bigPicture, bigPicture.width, BigPicture.height, MimeType.PNG);
	 */
    public static function toDataUrl(source:Image,width:Int, height:Int, type:MimeType):String{
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

/**
	 * Get the MimeType of a base64 Image data
	 * @method getMimeType
	 * @param	base64 {String} the base64 image data
	 * @return {MimeType}
	 */
    public static function getMimeType(base64:String):MimeType{
        return base64.substring(base64.indexOf(':') + 1, base64.indexOf(';'));
    }
}
