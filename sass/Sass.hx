#if macro
package sass;

import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.TypeTools;
import sys.io.File;
using sys.FileSystem;
using haxe.io.Path;
using StringTools;

typedef SassApplication = {
	var cls:ClassType;
	var name:String;
	var sassSourcePath:String;
	var sassDestPath:String;
	var components:Array<SassComponent>;
}

typedef SassComponent = {
	var cls:ClassType;
	var name:String;
	var sassSourcePath:String;
}

class Sass { 

	private static var sassDir:String = null;
	private static var sassApp:SassApplication = null;

	private static function use() {
		#if sassdir
		Context.onGenerate(function(types) {
			if (sassDir == null) {
				sassDir = Compiler.getDefine("sassdir");

				sassApp = {
					cls: null,
					name: null,
					sassSourcePath: null,
					sassDestPath: null,
					components: []
				};
			}

			for (type in types) {
				switch(type) {
					case TInst(t, params):
					var cls = t.get();
					var sup = cls.superClass;
					if (sup != null) {
						var sassMeta = cls.meta.extract(":sass");
						if (sassMeta.length > 0) {
							var params:Array<String> = sassMeta[0].params.map(ExprTools.getValue);

							if ("" + sup.t == "org.tamina.html.component.HTMLComponent") {
								if (params.length >= 1) {
									var component:SassComponent = {
										cls: cls,
										name: cls.name,
										sassSourcePath: parseSassPath(cls, params[0])
									};

									sassApp.components.push(component);
								}

							} else if ("" + sup.t == "org.tamina.html.component.HTMLApplication") {
								if (params.length >= 2) {
									sassApp.cls = cls;
									sassApp.name = cls.name;
									sassApp.sassSourcePath = parseSassPath(cls, params[0]);
									sassApp.sassDestPath = parseSassPath(cls, params[1]);
								}
							}
						}
					}

					default:
				}
			}

			if (sassApp.cls != null) {
				if (checkFileExists(sassApp.sassSourcePath, sassApp.cls.pos)) {
					var appSassSource:String = File.getContent(sassApp.sassSourcePath);

					var hasReplaceString:Bool = appSassSource.indexOf("@components@") != -1;
					var componentsSassSource:String = "";

					var indent:String = "";
					if (hasReplaceString) {
						var indentRegex = ~/\n(\s*)@components@/;
						if (indentRegex.match(appSassSource)) {
							indent = indentRegex.matched(1);
						}
					}

					for (component in sassApp.components) {
						if (checkFileExists(component.sassSourcePath, component.cls.pos)) {
							var source:String = "\n\n/* Component: " + component.name + " */\n"
							+ File.getContent(component.sassSourcePath);

							componentsSassSource = componentsSassSource + addIndent(source, indent);
						}
					}

					if (hasReplaceString) {
						appSassSource = appSassSource.replace("@components@", componentsSassSource);
					} else {
						appSassSource = appSassSource + "\n\n" + componentsSassSource;
					}

					var out = File.write(sassApp.sassDestPath);
					out.writeString(appSassSource);
					out.close();

					#if DEBUG_SASS
					Context.warning(
						"Application " + sassApp.name + ": sass file '"
						+ Path.withoutDirectory(sassApp.sassDestPath)
						+ "' generated from components:",
						sassApp.cls.pos
					);

					for (component in sassApp.components) {
						Context.warning("- " + component.name, component.cls.pos);
					}
					#end
				}
			}
		});
		#end
	}

	private static function checkFileExists(path:String, pos:Position):Bool {
		if (!FileSystem.exists(path)) {
			Context.error("Cannot find file: '" + path + "'", pos);
			return false;
		}

		return true;
	}

	private static function parseSassPath(cls:ClassType, path:String):String {
		var dir:String = Path.directory(Context.getPosInfos(cls.pos).file);
		var ret:String = Path.join([sassDir, path]);

		// If first argument is empty,
		// the corresponding sass file must have the same name,
		// an "sass" extension, and be in the same directory as its component class
		if (path == "") {
			var filename:String = cls.name + ".scss";
			return Path.join([dir, filename]);

		// If first arguments starts with "./",
		} else if (path.startsWith("./")) {
			ret = Path.join([dir, path]);
		}

		if (!ret.endsWith(".scss")) {
			ret = Path.join([ret, cls.name + ".scss"]);
		}

		return ret;
	}

	private static function addIndent(source:String, indent:String):String {
		if (indent == "") return source;

		var lines:Array<String> = source.split("\n");
		var ret:String = "";

		for (line in lines) {
			if (line.trim() != "") {
				line = indent + line;
			}

			ret += line + "\n";
		}

		return ret;
	}

}

#end