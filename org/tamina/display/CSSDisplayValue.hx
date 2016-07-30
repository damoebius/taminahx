package org.tamina.display;

@:enum abstract CSSDisplayValue(String) from String to String {
    var UNDEFINED:String = "";

    var NONE:String = "none";
    var INITIAL:String = "initial";
    var INHERIT:String = "inherit";

    var BLOCK:String = "block";
    var FLEX:String = "flex";
    
    var INLINE:String = "inline";
    var INLINE_BLOCK:String = "inline-block";
    var INLINE_FLEX:String = "inline-flex";
    var INLINE_TABLE:String = "inline-table";

    var LIST_ITEM:String = "list-item";
    var RUN_IN:String = "run-in";

    var TABLE:String = "table";
    var TABLE_CAPTION:String = "table-caption";
    var TABLE_COLUMN_GROUP:String = "table-column-group";
    var TABLE_HEADER_GROUP:String = "table-header-group";
    var TABLE_FOOTER_GROUP:String = "table-footer-group";
    var TABLE_ROW_GROUP:String = "table-row-group";
    var TABLE_CELL:String = "table-cell";
    var TABLE_COLUMN:String = "table-column";
    var TABLE_ROW:String = "table-row";
}
