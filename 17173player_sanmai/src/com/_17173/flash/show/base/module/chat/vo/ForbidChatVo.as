package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;

	import flash.text.engine.TextElement;

	/**
	 * 禁言信息类
	 * @author idzeir
	 * 创建时间：2014-3-14  上午11:36:27
	 */
	public class ForbidChatVo extends BaseChatVo
	{
		private var _toUser:IUserData;
		private var _opUser:IUserData;

		private var _isForbid:Boolean;

		/**
		 * 禁言消息
		 * @param to 禁言的用户
		 * @param op 执行操作的用户
		 * @param bool 是否为禁言
		 *
		 */
		public function ForbidChatVo(to:IUserData = null, op:IUserData = null, bool:Boolean = true)
		{
			super();
			_toUser = to;
			_opUser = op;
			_isForbid = bool;
		}

		override protected function initVo():void
		{
			super.initVo();
			this._elems.push(this.timeStamp);
			
			var textElement:TextElement = new TextElement(this.getUserName(_opUser), this.getNameTF(_opUser));
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = _opUser;
			this._elems.push(textElement);
			
			textElement = new TextElement(" 将 ", FontUtil.getFormat(0xec7218));
			this._elems.push(textElement);
			
			textElement = new TextElement(_toUser?_toUser.name:"神秘人", this.getNameTF(_toUser));
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = _toUser;
			this._elems.push(textElement);
			
			textElement = new TextElement(_isForbid ? " 禁言了5分钟。" : " 恢复发言", FontUtil.getFormat(0xec7218));
			this._elems.push(textElement);
		}

		override protected function dispose():void
		{
			super.dispose();
			_toUser = null;
			_opUser = null;
		}

		/**
		 * 执行操作的用户
		 */
		public function set opUser(value:IUserData):void
		{
			_opUser = value;
		}

		/**
		 * 被禁言用户
		 */
		public function set toUser(value:IUserData):void
		{
			_toUser = value;
		}

		/**
		 * 是否为禁言
		 */
		public function set isForbid(value:Boolean):void
		{
			_isForbid = value;
		}
	}
}