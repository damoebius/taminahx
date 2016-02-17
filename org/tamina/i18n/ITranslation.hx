package org.tamina.i18n;
/**
 * An Interface to describe a Translation Data<br>
 * See {{#crossLink "LocalizationManager"}}{{/crossLink}}
 * @class ITranslation
 */
interface ITranslation {

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

}
