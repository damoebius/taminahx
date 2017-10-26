package org.tamina.utils;

import haxe.Timer;

/**
* The BindingUtils class defines utility methods for performing data binding from Haxe code. You can use the methods defined in this class to configure data bindings.
* @class BindingUtils
**/
class BindingUtils {

    private static var _instance:BindingUtils;

    private var _timer:Timer;
    private var _bindings:Array<BindingModel>;

    private function new() {
        _bindings = new Array<BindingModel>();
        _timer = new Timer(2);
        _timer.run = evalBindings;
    }

    private function evalBindings():Void {
        for (model in _bindings) {
            var currentValue = Reflect.getProperty(model.source, model.sourceProperty);
            if (model.value != currentValue) {
                model.value = currentValue;
                Reflect.setProperty(model.target, model.targetProperty, model.value);
            }
        }
    }

    public function registerBinding(model:BindingModel):Void {
        _bindings.push(model);
    }

    public function unRegisterBinding(model:BindingModel):Void {
        _bindings.remove(model);
    }

    /**
    * Binds a public property, sourceProperty on the source Object, to a bindable property on the target Object.
    * @method bindProperty
    * @static
    * @param {Any} source
    * @param {String} sourceProperty
    * @param {Any} target
    * @param {String} targetProperty
    * @return {BindingModel}
    **/
    public static function bindProperty(source:Any, sourceProperty:String, target:Any, targetProperty:String):BindingModel {
        if (_instance == null) {
            _instance = new BindingUtils();
        }
        var model = new BindingModel(source, sourceProperty, target, targetProperty);
        _instance.registerBinding(model);
        return model;
    }

    /**
    * Remove a binding
    * @method remove
    * @static
    * @param {BindingModel} model
    **/
    public static function remove(model:BindingModel):Void {
        _instance.unRegisterBinding(model);
    }
}

/**
* The BindingModel represent the result of a data binding.
* @class BindingModel
* @private
**/
private class BindingModel {
    public var source(default, null):Any;
    public var sourceProperty(default, null):String;
    public var target(default, null):Any;
    public var targetProperty(default, null):String;
    public var value:Any;

    public function new(source:Any, sourceProperty:String, target:Any, targetProperty:String) {
        this.source = source;
        this.sourceProperty = sourceProperty;
        this.target = target;
        this.targetProperty = targetProperty;
        this.value = Reflect.getProperty(source, sourceProperty);
    }


}
