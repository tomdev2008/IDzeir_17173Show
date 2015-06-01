package com._17173.flash.show.base.module.bottombar.view
{
	import com._17173.flash.core.components.common.Button;
	
	import flash.events.Event;
	
	public class OnlyLabelButton extends Button
	{
		
		private var _overColor:uint = 0;
		private var _outColor:uint = 0;
		/**
		 *只有label的按钮 
		 * @param label
		 * @param color1 正常颜色
		 * @param color2 移入颜色
		 * 
		 */		
		public function OnlyLabelButton(label:String="", color1:uint = 0x8B7D98, color2:uint =0xFFFFFF)
		{
			_overColor = color2;
			_outColor = color1;
			super(label);
			this.setSkin(null);
		}
		
//		override protected function initSource():void{
//			super.initSource();
//			if(_bg){
//				_bg.alpha = .01;
//			}
//		}
		
		override protected function initTextField():void{
			super.initTextField();
			_labelTxt.textColor = _outColor;
		}
		
		override protected function onOver(e:Event):void{
			super.onOver(e);
			_labelTxt.textColor = _overColor;
		}
		
		override protected function onOut(e:Event):void{
			super.onOut(e);
			_labelTxt.textColor = _outColor;
		}
	}
}