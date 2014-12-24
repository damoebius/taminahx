package org.tamina.net;
@:enum abstract ScriptLoadingType(String) from String to String {
    var SEQUENCE = 'sequence';
    var PARALLEL = 'parallel';
}
