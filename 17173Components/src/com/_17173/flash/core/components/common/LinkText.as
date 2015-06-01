package com._17173.flash.core.components.common
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;

	/**
	 *可点击文本 
	 * @author zhaoqinghao
	 * 
	 */	
	public class LinkText extends Sprite
	{
		
		public var labelTf:TextField = null;
		private var _link:String = null;
		/**
		 * 可点击文本 
		 * @param outColor 正常颜色
		 * @param overColor 相应鼠标颜色
		 * 
		 */		
		public function LinkText(label:TextField)
		{
			super();
			label.selectable = false;
			label.mouseEnabled = false;
			this.addChild(label);
			this.buttonMode = true;
			labelTf = label;
		}
		
		/**
		 * 设置超链接的地址
		 * @param line url地址
		 */
		public function setLink(link:String):void{
			_link = link;
			if (_link == null || _link.length == 0)
			{
				if (this.hasEventListener(MouseEvent.CLICK))
				{
					this.removeEventListener(MouseEvent.CLICK, onClick);
				}
			}
			else
			{
				if (!this.hasEventListener(MouseEvent.CLICK))
				{
					this.addEventListener(MouseEvent.CLICK, onClick);
				}
			}			
		}
		
		private function onClick(e:Event):void{
			flash.net.navigateToURL(new URLRequest(_link));
		}
	}
}