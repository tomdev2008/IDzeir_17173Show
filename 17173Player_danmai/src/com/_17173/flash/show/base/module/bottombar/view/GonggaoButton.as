package com._17173.flash.show.base.module.bottombar.view
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.CompEnum;
	import com._17173.flash.show.base.utils.FontUtil;
	
	import flash.display.MovieClip;
	import flash.text.TextFormat;

	/**
	 *公告 按钮
	 * @author zhaoqinghao
	 * 
	 */	
	public class GonggaoButton extends Button
	{
		private var _icon:MovieClip = null;
		public function GonggaoButton(label:String="", isSelected:Boolean=false)
		{
			super("房间公告", isSelected);
		}
		
		override protected function onInit():void{
			super.onInit();
			this.width = 60;
			this.height = 49;
			_icon = new Bottom_Gonggao();
			_icon.x = (this.width - _icon.width)/2;
			_icon.y = 8;
			_icon.mouseEnabled = false;
			this.addChild(_icon);
		}
		
		override protected function initTextField():void{
			super.initTextField();
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = CompEnum.LABEL_BUTTON_COLOR;
			textFormat.font = FontUtil.f;
			textFormat.size = 10;
			_labelTxt.setTextFormat(textFormat);
			_labelTxt.alpha = .7;
			_labelTxt.defaultTextFormat = textFormat;
		}
		
		override protected function onRePostionLabel():void{
			_labelTxt.x = (width - _labelTxt.width)/2;
			_labelTxt.y = 26;
		}
		
	}
}