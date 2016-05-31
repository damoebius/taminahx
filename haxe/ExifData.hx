package haxe;

/**
* The Exif Data of an image.
* See : https://en.wikipedia.org/wiki/Exchangeable_image_file_format
* @class ExifData
* @module Tamina
*/
typedef ExifData = {
    @:optional var Make:String;
    @:optional var Model:String;
    @:optional var Orientation:Orientation;
    @:optional var XResolution:Int;
    @:optional var YResolution:Int;
    @:optional var ResolutionUnit:String;
    @:optional var Software:String;
    @:optional var DateTime:String;
    @:optional var YCbCrPositioning:Int;
    @:optional var ExifIFDPointer:Int;
    @:optional var GPSInfoIFDPointer:Int;
    @:optional var ExposureTime:Int;
    @:optional var FNumber:Int;
    @:optional var ExposureProgram:String;
    @:optional var ISOSpeedRatings:String;
    @:optional var ExifVersion:String;
    @:optional var DateTimeOriginal:String;
    @:optional var DateTimeDigitized:String;
    @:optional var ComponentsConfiguration:String;
    @:optional var CompressedBitsPerPixel:String;
    @:optional var ExposureBias:String;
    @:optional var MaxApertureValue:String;
    @:optional var MeteringMode:String;
    @:optional var LightSource:String;
    @:optional var Flash:String;
    @:optional var FocalLength:String;
    @:optional var MakerNote:String;
    @:optional var UserComment:String;
    @:optional var SubsecTime:String;
    @:optional var SubsecTimeOriginal:String;
    @:optional var SubsecTimeDigitized:String;
    @:optional var FlashpixVersion:String;
    @:optional var ColorSpace:String;
    @:optional var PixelXDimension:String;
    @:optional var PixelYDimension:String;
    @:optional var InteroperabilityIFDPointer:String;
    @:optional var SensingMethod:String;
    @:optional var FileSource:String;
    @:optional var SceneType:String;
    @:optional var CFAPattern:String;
    @:optional var CustomRendered:String;
    @:optional var ExposureMode:String;
    @:optional var WhiteBalance:String;
    @:optional var DigitalZoomRation:String;
    @:optional var FocalLengthIn35mmFilm:String;
    @:optional var SceneCaptureType:String;
    @:optional var GainControl:String;
    @:optional var Contrast:String;
    @:optional var Saturation:String;
    @:optional var Sharpness:String;
    @:optional var SubjectDistanceRange:String;
    @:optional var ImageUniqueID:String;
    @:optional var GPSVersionID:String;
    @:optional var GPSLatitudeRef:String;
    @:optional var GPSLatitude:String;
    @:optional var GPSLongitudeRef:String;
    @:optional var GPSLongitude:String;
    @:optional var GPSAltitudeRef:String;
    @:optional var GPSAltitude:String;
    @:optional var GPSTimeStamp:String;
    @:optional var GPSSatellites:String;
    @:optional var GPSMapDatum:String;
    @:optional var GPSDateStamp:String;
}

/**
* Photo Orientation
* @class Orientation
* @module Tamina
*/
@:enum abstract Orientation(Int) from Int to Int {

    var NONE = 0;
    var TOP = 1;
    var LEFT = 8;
    var RIGHT = 6;
    var BOTTOM = 3;

}
