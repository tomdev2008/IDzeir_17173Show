package com._17173.flash.player.module.extrarecommand
{
	import com._17173.flash.core.util.Util;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	import com._17173.flash.player.ui.stream.extra.IExtraUIItem;
	
	/**
	 * 直播工具推荐链接
	 *  
	 * @author shunia-17173
	 */	
	public class VideoToolExtraItem extends Sprite implements IExtraUIItem
	{
		
		private var _tf:TextField = null;
		
		public function VideoToolExtraItem()
		{
			super();
			
			var fmt:TextFormat = new TextFormat(Util.getDefaultFontNotSysFont(), 12);
			fmt.underline = true;
			fmt.color = 0xBBBBBB;
			
			_tf = new TextField();
			_tf.defaultTextFormat = fmt;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.text = "视频助手";
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			addChild(_tf);
			
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, _tf.width, _tf.height);
			graphics.endFill();
			
			_tf.x = (width - _tf.width) / 2;
			_tf.y = (height - _tf.height) / 2;
			
			buttonMode = true;
			useHandCursor = true;
			
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			Util.toUrl("http://v.17173.com/vtool");
		}
		
		public function refresh(isFullScreen:Boolean=false):void
		{
		}
		
		public function get side():Boolean
		{
			return ExtraUIItemEnum.SIDE_RIGHT;
		}
	}
}