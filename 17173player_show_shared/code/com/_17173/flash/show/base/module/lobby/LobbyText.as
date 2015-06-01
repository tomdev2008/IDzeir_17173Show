package com._17173.flash.show.base.module.lobby
{
	import com._17173.flash.show.base.utils.FontUtil;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class LobbyText extends TextField
	{
		public function LobbyText()
		{
			super();
			this.defaultTextFormat = new TextFormat(FontUtil.f);
			this.autoSize = "left";
			this.mouseEnabled = false;
			this.selectable = false;			
		}
		
		override public function set text(value:String):void
		{
			super.text = value;
		}
		
		override public function set htmlText(value:String):void
		{
			super.htmlText = value;
		}
	}
}