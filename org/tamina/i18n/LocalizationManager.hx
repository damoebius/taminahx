package org.tamina.i18n;
import haxe.ds.StringMap;
/**
 * The LocalizationManager is a Singleton used to manage i18n capabilities.<br>
 * ## Initialization
 * You can initialize the LocalizationManager using an array of {{#crossLink "ITranslation"}}{{/crossLink}}.<br>
 *
 *     interface ITranslation {
 *          public var fieldName:String;
 *          public var locale:Locale;
 *          public var value:String;
 *     }
 *
 * Example of initialization<br>
 *
 *     LocalizationManager.instance.setTranslations(translations);
 *
 * ## Usage
 * To use a translation from your application, you just have to call the LocalizationManager.
 *
 *     var myTitle = LocalizationManager.instance.getString("title");
 *
* From the {{#crossLink "HTMLComponent"}}{{/crossLink}}'s view :
 *
 *     <div>
 *          <a href="#" class="btn btn-prev">
 *          \{{ title }}
 *          </a>
 *     </div>
 *
 * more info : http://happy-technologies.com/custom-elements-and-component-developement-en/
 * @class LocalizationManager
 */
class LocalizationManager {

/**
 * @property instance
 * @type LocalizationManager
 * @static
 * @readOnly
 */
    public static var instance(get, null):LocalizationManager;
    private static var _instance:LocalizationManager;

    private var _translations:StringMap<ITranslation>;


    public static function add(manager:LocalizationManager):Void {
        _instance = manager;
    }

/**
    * Initialize the ITransations dictionnary
    * @method setTranslations
    * @param translations {ITranslation[]} the dictionnay
    * @example
     *      LocalizationManager.instance.setTranslations(translations);
     *
    */
    public function setTranslations(translations:Array<ITranslation>) {
        for(translation in translations){
            _translations.set(translation.fieldName,translation);
        }
    }

/**
    * Initialize the ITransations dictionnary
    * @method getString
    * @param key {String} the filedName of the ITranslation
    * @return {String} the value
    * @example
     *      var myTitle = LocalizationManager.instance.getString("title");
     *
    */
    public function getString(key:String):String {
        var result = '';
        if(_translations.exists(key)){
            result = _translations.get(key).value;
        }
        return result ;
    }

    private function new() {
        _translations = new StringMap<ITranslation>();
    }

    private static function get_instance():LocalizationManager {
        if (_instance == null) {
            _instance = new LocalizationManager();
        }
        return _instance;
    }
}
