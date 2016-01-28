package org.tamina.utils;
import org.tamina.html.MimeType;
class BitmapUtils {

    public static function getMimeType(base64:String):MimeType{
        return base64.substring(base64.indexOf(':') + 1, base64.indexOf(';'));
    }
}
