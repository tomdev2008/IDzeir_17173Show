package com._17173.flash.show.base.components.common
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	
	/**
	 * 解决滚动条九宫格缩放失效问题
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 16, 2014||10:49:46 AM
	 */
	public class Grid9Skin extends Sprite
	{
		private var _skin:DisplayObject;
		
		public function Grid9Skin(cls:Class)
		{
			super();
			_skin = new cls();
			
			this.addChild(_skin);
		}
		
		override public function set width(value:Number):void
		{
			_skin.width = value;
		}
		
		override public function set height(value:Number):void
		{
			_skin.height = value;
		}
		
		override public function get width():Number
		{
			return _skin?_skin.width:0;
		}
		
		override public function get height():Number
		{
			return _skin?_skin.height:0;
		}
	}
}