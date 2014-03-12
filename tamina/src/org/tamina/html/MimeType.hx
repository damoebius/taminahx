package org.tamina.html;
enum MimeType {
    PNG;
    JPG;

}

class MimeTypes {
    public static function toString(value:MimeType):String {
        var result:String = '';
        switch (value) {
            case MimeType.JPG : result = 'image/jpeg';
            case MimeType.PNG : result = 'image/png';
        }
        return result;
    }
}