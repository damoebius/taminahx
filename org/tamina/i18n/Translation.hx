package org.tamina.i18n;

/**
 * Transalation is an ITranslation's implementation<br>
 * See {{#crossLink "LocalizationManager"}}{{/crossLink}}
* @class Translation
* @interface ITranslation
* @module Tamina
*/
class Translation implements ITranslation {

/**
     * The translation's Id
     * @property fieldName
     * @type String
     */
    public var fieldName:String;

/**
     * The locale
     * @property locale
     * @type Locale
     */
    public var locale:Locale;

/**
     * The value
     * @property value
     * @type String
     */
    public var value:String;

/**
    * @constructor
    * @method new
    * @param [fieldName] {String}
    * @param [value] {String}
    * @param [locale] {Locale}
    */
    public function new(fieldName:String = "", value:String = "",locale:Locale = "") {
        this.locale = locale;
        this.fieldName = fieldName;
        this.value = value;
    }
}
