package org.tamina.log;

import mconsole.Console;

/**
 * ...
 * @author David Mouton
 */

class QuickLogger 
{

	public static function info(message:String, ?source:Dynamic):Void 
	{
		Console.info(Date.now().toString() + ' [ INFO ] ' + message);
	}
	
	public static function debug(message:String, ?source:Dynamic):Void 
	{
		Console.debug(Date.now().toString() + ' [ DEBUG ] ' + message);
	}
	
	public static function warn(message:String, ?source:Dynamic):Void 
	{
		Console.warn(Date.now().toString() + ' [ WARN ] ' + message);
	}
	
	public static function error(message:String, ?source:Dynamic):Void 
	{
		Console.error(Date.now().toString() + ' [ ERROR ] ' + message);
	}
	
	
	
}