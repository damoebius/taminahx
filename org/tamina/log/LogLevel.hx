package org.tamina.log;
/**
 * Tamina Lib
 * <br/>https://github.com/damoebius/taminahx
 * Enumeration des niveaux de logs
 * @class LogLevel
 */
@:enum abstract LogLevel(Int) from Int to Int {

/**
	 * INFO
	 * @property INFO
	 * @type Int
	 * @readOnly
	 * @static
	 * @default 0
	 */
    var INFO = 0;

/**
	 * DEBUG
	 * @property DEBUG
	 * @type Int
	 * @readOnly
	 * @static
	 * @default 1
	 */
    var DEBUG = 1;

/**
	 * WARN
	 * @property WARN
	 * @type Int
	 * @readOnly
	 * @static
	 * @default 2
	 */
    var WARN = 2;

/**
	 * ERROR
	 * @property ERROR
	 * @type Int
	 * @readOnly
	 * @static
	 * @default 3
	 */
    var ERROR = 3;

/**
	 * NONE
	 * @property NONE
	 * @type Int
	 * @readOnly
	 * @static
	 * @default 4
	 */
    var NONE = 4;

    @:op(A<=B) public function compareMinusOrEqual(target:Int):Bool{ return this <= target;}

}
