package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.SkinComponent;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ChatNotify extends SkinComponent
	{
		private var _close:Button;
		private var _title:TextField;
		
		public function ChatNotify()
		{
			super();	
			this.setSkin_Bg(new chatNotifyBg());
			_close = new Button();
			_close.setSkin(new chatNotifyCloseBtn());
			_title = new TextField();
			width = 24;
			height = 35;
			
			this.addChild(_title);
			this.addChild(_close);	
			_close.addEventListener(MouseEvent.CLICK,onClose);
		}
		
		protected function onClose(event:MouseEvent):void
		{
			this.visible = false;
		}
		
		public function set titleStr(value:String):void
		{
			(this._title as TextField).autoSize = "left";
			(this._title as TextField).textColor = 0xff5afe;
			_title.text = value;
			width = this._title.width + 22;
			updatePos();		
		}
	
		private function updatePos():void
		{
			_title.x = 5;
			_title.y = 5;
			_close.width = _close.height = 8;
			_close.x = this.width - _close.width - 5;
			_close.y = 5;
		}
		
	}
}