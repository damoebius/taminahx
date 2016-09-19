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

    /**
     * Retourne une fonction "filter" (classiquement, pour un usage en Array.filter())
     * Triant les objets du tableau pour retourner celui (ou ceux) qui a le même id
     * Que l'objet passé initialement
     *
     * @method filterById[T]
     * @param   source {T} L'objet à rechercher
     */
    public static function filterById<T:{id:Dynamic}>(source:T):T->Bool {
        return function(obj:T):Bool {
            return source.id == obj.id;
        };
    }
}
