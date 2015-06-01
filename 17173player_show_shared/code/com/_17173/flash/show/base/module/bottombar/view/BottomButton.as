package com._17173.flash.show.base.module.bottombar.view
{
	import com._17173.flash.core.components.common.Button;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	/**
	 *常用按钮 
	 * @author zhaoqinghao
	 * 
	 */	
	public class BottomButton extends Button
	{
		private var _data:ButtonBindData = null;
		private var _icon:DisplayObject = null;
		public function BottomButton(bindData:ButtonBindData)
		{
			_data = bindData;
			super(bindData.label,bindData.select);
		}
		

		public function get data():ButtonBindData
		{
			return _data;
		}

		public function set data(value:ButtonBindData):void
		{
			_data = value;
		}

		override protected function onInit():void{
			super.onInit();
			if(_data && _data.icon != null){
				_icon = _data.icon;
				if(_icon is DisplayObjectContainer){
					DisplayObjectContainer(_icon).mouseEnabled = false
				}
				this.addChild(_icon);
			}
		}
		
		override protected function onResize(e:Event=null):void{
			super.onResize(e);
			updateIconPot();
		}
		
		private function updateIconPot():void{
			if(_icon){
				_icon.x = (this.width - _icon.width )/2;
				_icon.y = (this.height - _icon.height )/2;
			}
		}
		
	}
}