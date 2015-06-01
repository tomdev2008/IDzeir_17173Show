package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.show.base.utils.FontUtil;

	import flash.text.engine.TextElement;

	/**
	 * 错误信息类
	 * @author idzeir
	 * 创建时间：2014-3-14  上午11:10:25
	 */
	public class ErrorInfoVo extends BaseChatVo
	{
		private var _info:String = "";


		/**
		 * 错误消息
		 * @param msg
		 *
		 */
		public function ErrorInfoVo(msg:String = "")
		{
			super();
			_info = msg;
		}

		/**
		 * 显示的信息
		 */
		public function set info(value:String):void
		{
			_info = value;
		}

		override protected function initVo():void
		{
			super.initVo();
			this._elems.push(this.timeStamp);
			var textElement:TextElement = new TextElement(_info, FontUtil.getFormat(0xec7218));
			this._elems.push(textElement);
		}

		override protected function dispose():void
		{
			super.dispose();
		}
	}
}