package org.tamina.signal;

import haxe.macro.Context;
import haxe.macro.Expr;

import org.tamina.macro.Singleton;

class SignalTools {

	/**
	 *
	 * @method buildSignals
	 */
	public static macro function buildSignals():Array<Field> {
		var pos = Context.currentPos();
		var fields = Context.getBuildFields();

		var signalsInit = [];

		for (field in fields) {
			switch (field.kind) {
				case FVar(TPath(fieldType)):
					switch(fieldType.name) {
						case "Signal0", "Signal1", "Signal2", "Signal3":
							signalsInit.push(macro $i{field.name} = new $fieldType());

						default:
					}

				default:
			}
		}

		// Make class a singleton
		fields = Singleton.makeSingleton();

		// Create a constructor
		// In which every signal will be instantiated
		if (signalsInit.length > 0) {
			fields.push({
				name: "new",
				doc: null,
				meta: [],
				access: [APrivate],
				kind: FFun({
					args: [],
					params: [],
					ret: null,
					expr: macro $b{signalsInit}
				}),
				pos: pos
			});
		}

		return fields;
	}

}

