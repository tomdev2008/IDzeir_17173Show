package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.show.base.utils.FontUtil;
	
	import flash.text.engine.TextElement;

	public class InfoVo extends BaseChatVo
	{
		private var _info:String;
		private var _color:uint;
		
		/**
		 * 在聊天框显示一条消息
		 * @param value 消息内容
		 * @param color 消息颜色
		 */
		public function InfoVo(value:String = "",color:uint = 0xec7218)
		{
			super();
			_info = value;
			_color = color;
		}
		
		/**
		 * 消息内容
		 */
		public function get info():String
		{
			return _info;
		}

		/**
		 * @private
		 */
		public function set info(value:String):void
		{
			_info = value;
		}

		/**
		 * 消息颜色
		 */
		public function get color():uint
		{
			return _color;
		}

		/**
		 * @private
		 */
		public function set color(value:uint):void
		{
			_color = value;
		}

		override protected function initVo():void
		{
			super.initVo();
			this._elems.push(this.timeStamp);
			
			var textElement:TextElement = new TextElement(_info, FontUtil.getFormat(this._color));
			this._elems.push(textElement);
		}
		
		override protected function dispose():void
		{
			super.dispose();
			_info = "";
			_color = 0xec7218;
		}
	}
}