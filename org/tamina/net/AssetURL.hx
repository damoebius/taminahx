package org.tamina.net;

class AssetURL extends URL {
	public var assetType:AssetType;

	public function new(path:String, ?assetType:AssetType = AssetType.JS) {
		super(path);
		this.assetType = assetType;
	}
}