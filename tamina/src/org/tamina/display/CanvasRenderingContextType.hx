package org.tamina.display;
enum CanvasRenderingContextType {
    _2D;
    _3D;
}

class CanvasRenderingContextTypes {
    public static function toString(value:CanvasRenderingContextType):String {
        var result:String = '';
        switch (value) {
            case CanvasRenderingContextType._2D : result = '2d';
            case CanvasRenderingContextType._3D : result = '3d';
        }
        return result;
    }
}