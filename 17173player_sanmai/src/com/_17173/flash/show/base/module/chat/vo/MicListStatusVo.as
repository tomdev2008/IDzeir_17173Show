package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;

	import flash.text.engine.ElementFormat;
	import flash.text.engine.TextElement;

	public class MicListStatusVo extends BaseChatVo
	{
		private var _isEntry:Boolean;
		private var _data:*;

		public function MicListStatusVo(value:* = null, bool:Boolean = true)
		{
			super();
			_data = value;
			_isEntry = bool;
		}

		override protected function initVo():void
		{
			super.initVo();
			this._elems.push(this.timeStamp);
			var tf:ElementFormat = FontUtil.getFormat(0x63acff);
			var textElement:TextElement;
			textElement = new TextElement(_data.name, tf)
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = _data;
			this._elems.push(textElement);
			var info:String = _isEntry ? " 开始直播" : " 结束直播";
			textElement = new TextElement(info, FontUtil.getFormat(0xec7218));
			_elems.push(textElement);
		}

		override protected function dispose():void
		{
			super.dispose();
			_data = null;
		}

		public function set data(value:*):void
		{
			_data = value;
		}

		/**
		 * 是否为进入
		 */
		public function set isEntry(value:Boolean):void
		{
			_isEntry = value;
		}
	}
}