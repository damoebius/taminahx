package org.tamina.i18n;
class Translation implements ITranslation {

    public var fieldName:String;
    public var locale:Locale;
    public var value:String;

    public function new(fieldName:String = "", value:String = "",locale:Locale = "") {
        this.locale = locale;
        this.fieldName = fieldName;
        this.value = value;
    }
}
