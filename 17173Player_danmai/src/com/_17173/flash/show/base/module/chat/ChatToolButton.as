package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.components.common.Button;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	public class ChatToolButton extends Button
	{
		public function ChatToolButton(_slabel:String = "",handler:Function = null)
		{
			super(_slabel);
			this.label = _slabel;
			width = 45;
			height = 20;
			this.buttonMode = true;
			if(handler!=null)
			{
				this.addEventListener(MouseEvent.CLICK,handler);
			}
		}
		
		override public function setSkin(source:DisplayObject):void
		{
			source.width = width;
			source.height = height;
			super.setSkin(source);
		}
		
		override public function set label(value:String):void
		{
			super.label = "<font size='12' color='#d0cfcf'>" + value + "</font>";
			width = 45;
			height = 20;
			this.onRePostionLabel();
		}
	}
}