package org.tamina.net;
@:enum abstract AssetLoadingType(String) from String to String {
    var SEQUENCE = 'sequence';
    var PARALLEL = 'parallel';
}
