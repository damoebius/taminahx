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

    public function removeParameter(key:String):Void {
        var rtn:String = path;

        if(path.indexOf('?') != -1) {
            rtn = path.split("?")[0];
            var param:String;
            var params_arr = new Array();
            var queryString:String = (path.indexOf("?") != -1) ? path.split("?")[1] : "";

            if (queryString != "") {
                params_arr = queryString.split("&");

                var i = params_arr.length - 1;
                while(i >= 0) {
                    param = params_arr[i].split("=")[0];
                    if (param == key) {
                        params_arr.splice(i, 1);
                    }
                    i -= 1;
                }

                rtn = rtn + "?" + params_arr.join("&");
            }
        }

        path = rtn;
    }
}