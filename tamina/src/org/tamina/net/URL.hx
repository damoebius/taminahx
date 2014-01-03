package org.tamina.net;

/**
 * ...
 * @author David Mouton
 */

class URL 
{
	public var path:String;
	
	public var documentName(get, null):String;
	public var extension(get, null):String;
	
	public function new(path:String = "") 
	{
		this.path = path;
	}
	
	private function get_extension():String
	{
		var result:String = "";
		if ( path.lastIndexOf( "." ) == path.length - 4 )
		{
			result = path.substring( path.length - 3 );
		}
		return result;
	}

	private function get_documentName():String
	{
		var result:String = "";
		if ( path != null )
		{
			result = path.substring( path.lastIndexOf( "/" ) + 1 );
		}
		return result;
	}


	public function toString():String
	{
		return path;
	}
}