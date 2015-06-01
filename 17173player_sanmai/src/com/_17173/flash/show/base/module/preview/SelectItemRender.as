package com._17173.flash.show.base.module.preview
{
	import com._17173.flash.show.base.components.common.AslTextField;
	import com._17173.flash.show.base.utils.FontUtil;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;

	/**
	 * 选择摄像头和麦克风Item
	 * @author qiuyue
	 * 
	 */	
	public class SelectItemRender extends Sprite
	{
		/**
		 * 文本 
		 */		
		private var textField:AslTextField = null;
		public function SelectItemRender(data:Object)
		{
			super();
			this.mouseChildren = false;
			this.graphics.beginFill(0xFFF000,0);
			this.graphics.drawRect(0,0,180,25);
			this.graphics.endFill();
			textField = new AslTextField(150);
			var textFormat:TextFormat = FontUtil.DEFAULT_FORMAT;
			textFormat.color = 0x4d4d4d;
			textFormat.size =12;
			textField.defaultTextFormat = textFormat;
			textField.x = 5;
			textField.y = 3;
			textField.width = 150;
			textField.height = 25;
			textField.text = data.name;
			textField.mouseEnabled = false;
			textField.selectable = false;
			var line:Line = new Line();
			this.addChild(line);
			line.y = 24;
			line.x = 0;
			this.addChild(textField);
		}
	}
}