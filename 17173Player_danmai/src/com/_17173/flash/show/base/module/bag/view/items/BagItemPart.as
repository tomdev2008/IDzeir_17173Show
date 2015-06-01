package com._17173.flash.show.base.module.bag.view.items
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 *背包item 基类 
	 * @author yeah
	 */	
	public class BagItemPart extends Sprite implements IBagItemPart
	{
		public function BagItemPart()
		{
			super();
		}
		
		private var _data:Object;
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
//			if(_data == value) return;
			_data = value;
			onRender();
		}
		
		public function get type():String
		{
//			throw new IllegalOperationError("子类必须覆盖");
			return null;
		}
		
		public function get autoAlign():Boolean
		{
			return true;
		}
		
		/**
		 *渲染 
		 */		
		protected function onRender():void
		{
		}
		
		public function get self():DisplayObject
		{
			return this;
		}
	}
}