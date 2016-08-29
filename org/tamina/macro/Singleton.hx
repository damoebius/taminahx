package org.tamina.macro;

import haxe.macro.Context;
import haxe.macro.Expr;

/**
 * TODO: Documentation
 *
 * @class Singleton
 */
class Singleton {
	
	public static function makeSingleton():Array<Field> {
		var pos = Context.currentPos();
		var fields = Context.getBuildFields();

		var cls = Context.getLocalClass().get();
		var clsPath = {pack: cls.pack, name: cls.name};
		var clsType = TPath(clsPath);

		fields.push({
			name: "instance",
			access: [AStatic, APublic],
			kind: FProp("get", "null", clsType),
			pos: pos
		});

		fields.push({
			name: "get_instance",
			access: [AStatic, APublic],
			kind: FFun({
				args: [],
				params: [],
				ret: clsType,
				expr: macro {
					if (instance == null) {
						instance = new $clsPath();
					}
					return instance;
				}
			}),
			pos: pos
		});

		return fields;
	}
}
