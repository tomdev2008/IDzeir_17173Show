package com._17173.flash.player.ui.comps.def
{
	import com._17173.flash.core.skin.ISkinObject;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ControlBarDefBar extends Sprite
	{
		private var _bg:DisplayObject = null;
		private var _bgBottom:ISkinObject = null;
		private var _defItem:ControlBarDefBarItem = null;
		
		public function ControlBarDefBar()
		{
			super();
			
			_bg = new mc_def_back_bg();
			addChild(_bg);
			
			_defItem = new ControlBarDefBarItem();
			addChild(_defItem);
			
			init();
		}
		
		/**
		 * 设置都有那些清晰度
		 */
		public function setDefInfo(value:String):void{
			_defItem.setDefInfo(value);
			resize();
		}
		
		private function thisMouseOutHanlder(evt:MouseEvent):void
		{
			closeThis();
		}
		
		private function thisMouseOverHanlder(evt:MouseEvent):void
		{
			dispatchEvent(new Event("mouseInBarDef"));
		}
		
		private function closeThis():void
		{
			dispatchEvent(new Event("closeThis"));
		}
		
		private function init():void
		{
			_defItem.callBack = setCurrent;
			addEventListener(MouseEvent.ROLL_OUT, thisMouseOutHanlder);
			addEventListener(MouseEvent.ROLL_OVER, thisMouseOverHanlder);
		}
		
		private function setCurrent(value:String):void
		{
			var e:DataEvent = new DataEvent("changeDefName");
			e.data = value;
			this.dispatchEvent(e);
		}
		
		public function resize():void
		{
			if(_bg && this.contains(_bg))
			{
				_bg.height = _defItem.height;
			}
			if(_defItem && this.contains(_defItem))
			{
				_defItem.x = 0;
				_defItem.y = 0;
			}
//			if(_bgBottom && this.contains(_bgBottom.display))
//			{
//				_bgBottom.display.x = 0;
//				_bgBottom.display.y = _defItem.y + _defItem.height;
//			}
		}
	}
}