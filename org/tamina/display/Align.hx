package org.tamina.display;

@:enum abstract Align(Int) from Int to Int {
    private static inline var _LEFT:Int = 0x1;
    private static inline var _CENTER:Int = 0x10;
    private static inline var _RIGHT:Int = 0x100;
    private static inline var _TOP:Int = 0x1000;
    private static inline var _MIDDLE:Int = 0x10000;
    private static inline var _BOTTOM:Int = 0x100000;
    
    var TOP_LEFT:Align = _TOP | _LEFT;
    var TOP:Align = _TOP | _CENTER;
    var TOP_RIGHT:Align = _TOP | _RIGHT;
    
    var BOTTOM_LEFT:Align = _BOTTOM | _LEFT;
    var BOTTOM:Align = _BOTTOM | _CENTER;
    var BOTTOM_RIGHT:Align = _BOTTOM | _RIGHT;
    
    var LEFT:Align = _MIDDLE | _LEFT;
    var CENTER:Align = _MIDDLE | _CENTER;
    var RIGHT:Align = _MIDDLE | _RIGHT;
    

    public static inline function isLeftAligned(flag:Align):Bool {
        return (flag & _LEFT) != 0;
    }
    
    public static inline function isCenterAligned(flag:Align):Bool {
        return (flag & _CENTER) != 0;
    }

    public static inline function isHCenterAligned(flag:Align):Bool {
        return (flag & _CENTER) != 0;
    }
    
    public static inline function isRightAligned(flag:Align):Bool {
        return (flag & _RIGHT) != 0;
    }

    public static inline function isTopAligned(flag:Align):Bool {
        return (flag & _TOP) != 0;
    }
    
    public static inline function isVCenterAligned(flag:Align):Bool {
        return (flag & _MIDDLE) != 0;
    }

    public static inline function isMiddleAligned(flag:Align):Bool {
        return (flag & _MIDDLE) != 0;
    }

    public static inline function isBottomAligned(flag:Align):Bool {
        return (flag & _BOTTOM) != 0;
    }

    public static inline function fromString(alignStr:String):Align {
        return switch(alignStr) {
            case "TOP": TOP;
            case "TOP_LEFT": TOP_LEFT;
            case "TOP_RIGHT": TOP_RIGHT;
            case "BOTTOM": BOTTOM;
            case "BOTTOM_LEFT": BOTTOM_LEFT;
            case "BOTTOM_RIGHT": BOTTOM_RIGHT;
            case "LEFT": LEFT;
            case "CENTER": CENTER;
            case "RIGHT": RIGHT;

            default:
            null;
        }
    }

}