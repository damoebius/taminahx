package org.tamina.utils;

class ObjectUtils {

    public static function merge(fromObject:Dynamic,toObject:Dynamic):Void{
        var fields = Reflect.fields(fromObject);
        for(i in 0...fields.length){
            var field = fields[i];
            if( Reflect.hasField(toObject,field)){
               Reflect.setField(toObject,field, Reflect.field(fromObject,field));
            }
        }
    }
}
