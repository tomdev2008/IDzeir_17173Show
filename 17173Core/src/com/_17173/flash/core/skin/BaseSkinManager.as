package com._17173.flash.core.skin
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	/**
	 * 皮肤管理类,需要单独实现皮肤注册的过程,才可以获取进行使用. 
	 * @author shunia-17173
	 */	
	public class BaseSkinManager implements ISkinManager
	{
		
		protected var _registered:Dictionary = null;
		protected var _skins:Dictionary = null;
		protected var _attachedSkins:Vector.<ISkinObject> = null;
		
		public function BaseSkinManager()
		{
			_registered = new Dictionary();
			_skins = new Dictionary();
			_attachedSkins = new Vector.<ISkinObject>();
		}
		
		//////////////////////////////
		//
		// implements
		//
		///////////////
		public function addSkinConfig(prototype:SkinObjectPrototype):void {
			_registered[prototype.name] = prototype;
		}
		
		public function hasSkin(name:String):Boolean {
			return _skins.hasOwnProperty(name) && _skins[name] && _skins[name] is ISkinObject;
		}
		
		public function attachSkinByName(name:String, parent:DisplayObjectContainer, num:int = -1):ISkinObject {
			var skin:ISkinObject = getSkin(name);
			return attachSkin(skin, parent, num);
		}
		
		public function notify(event:String, data:Object):void {
			for each (var item:ISkinObject in _attachedSkins) {
				if (item.display is ISkinObjectListener) {
					ISkinObjectListener(item.display).listen(event, data);
				}
			}
		}
		
		public function attachSkin(item:ISkinObject, parent:DisplayObjectContainer, num:int = -1):ISkinObject {
			if (item && item.display && parent) {
				_attachedSkins.push(item);
				if (num > -1) {
					if (num > parent.numChildren) {
						parent.addChild(item.display);
					} else {
						parent.addChildAt(item.display, num);
					}
				} else {
					parent.addChild(item.display);
				}
			}
			return item;
		}
		
		public function getSkin(name:String, create:Boolean = false):ISkinObject {
			var item:ISkinObject = null;
			if (hasSkinConfig(name) && create) {
				item = new SkinObject().init(_registered[name]);
			} else if (hasSkin(name)) {
				item = _skins[name];
			} else if (hasSkinConfig(name)) {
				item = new SkinObject().init(_registered[name]);
				if (item) {
					_skins[name] = item;
				}
			} else {
				//给一个默认的
				//当在获取的时候如果这个skin没有被注册,使用默认的sprite作为skin元素.
				item = new SkinObject().init(new SkinObjectPrototype(name, Sprite));
			}
			
			return item;
		}
		
		public function hasSkinConfig(name:String):Boolean {
			return _registered.hasOwnProperty(name) && _registered[name] && _registered[name] is SkinObjectPrototype;
		}
		
		public function resize():void {
		}
		
		public function deattachSkin(item:ISkinObject):ISkinObject {
			if (item.display && item.display.parent) {
				item.display.parent.removeChild(item.display);
			}
			while (_attachedSkins.indexOf(item) != -1) {
				_attachedSkins.splice(_attachedSkins.indexOf(item), 1);
			}
			return item;
		}
		
		public function deattachSkinByName(name:String):ISkinObject {
			var item:ISkinObject = getSkin(name);
			deattachSkin(item);
			return item;
		}
		
		
	}
}