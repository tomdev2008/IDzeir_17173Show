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
	 * 用户进出消息类
	 * @author idzeir
	 * 创建时间：2014-3-14  上午10:56:55
	 */
	public class UserEntryExitVo extends BaseChatVo
	{
		private var _user:IUserData;
		private var _isEntry:Boolean;

		/**
		 * 用户进出聊天数据
		 * @param user 用户
		 * @param bool 是否为进入
		 *
		 */
		public function UserEntryExitVo(user:IUserData = null, bool:Boolean = true)
		{
			super();
			_user = user;
			_isEntry = bool;
		}

		override protected function initVo():void
		{
			super.initVo();
			this._elems.push(this.timeStamp);

			var tf:ElementFormat = FontUtil.getFormat(0x63acff);
			var textElement:TextElement;
			//trace(this,_user.name,_user.hidden)
			if (!_user.hidden)
			{
				textElement = new TextElement(_user.name, tf);
				textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
				textElement.userData = _user;
				this._elems.push(textElement);
				textElement = new TextElement(" " + (_isEntry ? _ilocal.get("msg_userEntry", "chatPanel") : _ilocal.get("msg_userExit", "chatPanel")), FontUtil.getFormat());
			}
			else
			{
				textElement = new TextElement(_ilocal.get("msg_hidenEntry", "chatPanel"), FontUtil.getFormat(0xec7218));
			}
			this._elems.push(textElement);
		}

		override protected function dispose():void
		{
			super.dispose();
			_user = null;
		}

		/**
		 * 是否为进入
		 */
		public function set isEntry(value:Boolean):void
		{
			_isEntry = value;
		}

		/**
		 * 数据包含的用户
		 */
		public function set user(value:IUserData):void
		{
			_user = value;
		}
	}
}