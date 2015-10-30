package org.tamina.i18n;
import haxe.ds.StringMap;
class LocalizationManager {

    public static var instance(get, null):LocalizationManager;
    private static var _instance:LocalizationManager;

    private var _translations:StringMap<ITranslation>;

    public function setTranslations(translations:Array<ITranslation>) {
        for(translation in translations){
            _translations.set(translation.fieldName,translation);
        }
    }

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
