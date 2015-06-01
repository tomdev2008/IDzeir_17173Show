package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;

	import flash.text.engine.ElementFormat;
	import flash.text.engine.TextElement;

	/**
	 * 公聊状态改变信息类
	 * @author idzeir
	 * 创建时间：2014-3-14  下午2:30:55
	 */
	public class PublicChatStatusVo extends BaseChatVo
	{
		private var _opUser:IUserData;
		private var _isAllow:Boolean;

		/**
		 * 公聊状态改变信息
		 * @param name 执行操作用户
		 * @param bool 公聊状态
		 *
		 */
		public function PublicChatStatusVo(_user:IUserData = null, bool:Boolean = false)
		{
			super();
			_opUser = _user;
			_isAllow = bool;
		}

		override protected function initVo():void
		{
			super.initVo();
			this._elems.push(this.timeStamp);

			var tf:ElementFormat = FontUtil.getFormat(0x63acff);
			var textElement:TextElement = new TextElement(_opUser.name, tf);
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = _opUser;
			this._elems.push(textElement);
			var info:String = " " + (!_isAllow ? _ilocal.get("msg_close_chat", "chatPanel") : _ilocal.get("msg_open_chat", "chatPanel"));
			textElement = new TextElement(info, FontUtil.getFormat(0xec7218));
			_elems.push(textElement);
		}

		override protected function dispose():void
		{
			super.dispose();
			_opUser = null;
		}

		/**
		 * 是否允许公聊
		 */
		public function set isAllow(value:Boolean):void
		{
			_isAllow = value;
		}

		/**
		 * 执行操作用户
		 */
		public function set opUser(value:IUserData):void
		{
			_opUser = value;
		}

	}
}