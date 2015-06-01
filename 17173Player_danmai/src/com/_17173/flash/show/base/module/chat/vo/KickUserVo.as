package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.context.user.UserData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	
	import flash.text.engine.TextElement;

	/**
	 * 管理员踢人信息类
	 * @author idzeir
	 * 创建时间：2014-3-14  下午12:06:59
	 */
	public class KickUserVo extends BaseChatVo
	{
		private var _toUser:IUserData;
		private var _opUser:IUserData;

		/**
		 * 踢出房间消息
		 * @param to 被踢的用户
		 * @param op 执行操作的用户
		 *
		 */
		public function KickUserVo(to:IUserData = null, op:IUserData = null)
		{
			super();
			_toUser = to;
			_opUser = op;
		}

		override protected function initVo():void
		{
			super.initVo();
			this._elems.push(this.timeStamp);
			
			var textElement:TextElement = new TextElement(this.getUserName(_opUser), this.getNameTF(_opUser));
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = _opUser;
			_elems.push(textElement);
			
			textElement = new TextElement(" 将 ", FontUtil.getFormat(0xec7218));
			_elems.push(textElement);
			
			textElement = new TextElement(_toUser.name, this.getNameTF(_toUser));
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = new UserData();
			_elems.push(textElement);
			
			textElement = new TextElement(" 踢出1小时。", FontUtil.getFormat(0xec7218));
			_elems.push(textElement);
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
		 * 被踢的用户
		 */
		public function set toUser(value:IUserData):void
		{
			_toUser = value;
		}
	}
}