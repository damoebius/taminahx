package org.tamina.macro;

class CompileTimeClassList
{
    static var lists:Map<String, List<Class<Dynamic>>> = null;

    public static function get(id:String):List<Class<Dynamic>>
    {
        if (lists == null) initialise();
        return lists.get(id);
    }

    public static inline function getTyped<T>(id:String, type:Class<T>):List<Class<T>>
    {
        return cast get(id);
    }

    static function initialise()
    {
        lists = new Map();
        var m = haxe.rtti.Meta.getType(CompileTimeClassList);
        if (m.classLists != null)
        {
            for (item in m.classLists)
            {
                var array:Array<String> = cast item;
                var listID = array[0];
                var list = new List();
                for ( typeName in array[1].split(',') ) {
                    var type = Type.resolveClass(typeName);
                    if ( type!=null ) list.push( type );
                }
                lists.set(listID, list);
            }
        }
    }
}