package  {
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import flash.events.MouseEvent;
	import flash.display.Stage;
	import flash.geom.Point;
	
	/*
	*
	* 带管理功能的拖拽类
	*
	*/
	public class DragUtil {
		
		protected var _dict:DragDict = null;
		protected var _stage:Stage = null;
		protected var _current:DisplayObject = null;
		
		protected var _original:Point = null;
		protected var _delta:Point = null;
		
		public function DragUtil(stage:Stage) {
			_stage = stage;
			_original = new Point();
			_delta = new Point();
			_dict = new DragDict();
		}
		
		public function addWatch(item:DisplayObject, callback:Function):Object {
			return _dict.add(createWatch(item), callback).proxy;
		}
		
		public function removeWatch(item:DisplayObject, callback:Function):Boolean {
			var r:Boolean = false;
			
			if (_dict.has(item)) {
				r = _dict.remove(item, callback);
				if (_dict.get(item).isEmpty) {
					clearWatch(item);
				}
			}
			return r;
		}
		
		public function dispose():void {
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			_current = null;
			_dict.foreach(function (item:DisplayObject):void {
						  	item.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
						  });
			_dict.dispose();
			_dict = null;
			_stage = null;
		}
		
		protected function createWatch(item:DisplayObject):DisplayObject {
			item.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			
			return item;
		}
		
		protected function onDown(e:MouseEvent):void {
			_current = e.target as DisplayObject;
			
			_delta.x = _delta.y = 0;
			_original.x = e.stageX;
			_original.y = e.stageY;
			
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
		}
		
		protected function onMove(e:MouseEvent):void {
			_delta.x = e.stageX - _original.x;
			_delta.y = e.stageY - _original.y;
			
			_original.x = e.stageX;
			_original.y = e.stageY;
			
			onCallback([_delta, false]);
		}
		
		protected function onUp(e:MouseEvent):void {
			
			_delta.x = e.stageX - _original.x;
			_delta.y = e.stageY - _original.y;
			
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			onCallback([_delta, true]);
			
			_current = null;
		}
		
		protected function onCallback(params:Array):void {
			_dict.get(_current).onCallback(params);
		}
		
		protected function clearWatch(item:DisplayObject):void {
			item.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			if (item == _current) {
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
				_stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
				_current = null;
			}
		}
		
	}
	
}
import flash.utils.Dictionary;

class DragDict {
	
	protected var _dict:Dictionary = null;
	
	public function DragDict() {
		_dict = new Dictionary();
	}
	
	public function add(item:*, callback:Function):DragCache {
		var cache:DragCache = _dict[item];
		if (cache) {
			cache.addCallback(callback);
		} else {
			cache = new DragCache();
			cache.addCallback(callback);
			_dict[item] = cache;
		}
		return cache;
	}
	
	public function remove(item:*, callback:Function):Boolean {
		var cache:DragCache = _dict[item];
		if (cache) {
			return cache.removeCallback(callback);
		}
		return false;
	}
	
	public function foreach(func:Function):void {
		for (var item:* in _dict) {
			func.apply(null, [item]);
		}
	}
	
	public function has(item:*):Boolean {
		return _dict[item];
	}
	
	public function get(item:*):DragCache {
		var cache:DragCache = _dict[item];
		return cache;
	}
	
	public function dispose():void {
		for (var item:* in _dict) {
			get(item).dispose();
		}
		_dict = null;
	}
	
}

class DragCache {
	
	protected var callbacks:Vector.<Function> = null;
	public var proxy:DragProxy = null;
	
	public function DragCache() {
		callbacks = new Vector.<Function>();
		proxy = new DragProxy();
	}
	
	public function get isEmpty():Boolean {
		return !(callbacks && callbacks.length != 0);
	}
	
	public function addCallback(value:Function):void {
		if (callbacks.indexOf(value) == -1) {
			callbacks.push(value);
		}
	}
	
	public function removeCallback(value:Function):Boolean {
		var index:int = callbacks.indexOf(value);
		if (index != -1) {
			callbacks.splice(index, 1);
			return true;
		}
		return false;
	}
	
	public function onCallback(params:Array):void {
		callbacks.forEach(function (element:Function, index:int, arr:Vector.<Function>):void {
						  	element.apply(null, params);
						  });
	}
	
	public function dispose():void {
		proxy.lockRect = null;
		proxy = null;
		
		while (callbacks.length) {
			callbacks.pop();
		}
		callbacks = null;
	}
	
}

import flash.geom.Rectangle;

class DragProxy {
	
	public var lockRect:Rectangle = null;
	public var locked:Boolean = false;
	
}
