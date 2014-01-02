package org.tamina.utils;

/**
 * ...
 * @author David Mouton
 */

class UID 
{
	private static var _lastUID:Float = 0;
	
	public static function getUID():Float
	{
		var result:Float = Date.now().getTime();
		if ( result <= _lastUID )
		{
			result = _lastUID + 1;
		}
		_lastUID = result;
		return result;
	}
	
}