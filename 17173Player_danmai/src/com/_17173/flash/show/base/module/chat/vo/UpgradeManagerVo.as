package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;

	import flash.text.engine.TextElement;

	/**
	 * 提升管理员信息类
	 * @author idzeir
	 * 创建时间：2014-3-14  上午11:16:48
	 */
	public class UpgradeManagerVo extends BaseChatVo
	{
		private var _toUser:IUserData;
		private var _opUser:IUserData;

		private var _isUpgrade:Boolean;
		/**
		 * ALL(0),  房主OWNER(1), 副房主SUB(2), 主播MASTER(3), 管理ADMIN(4);
		 */
		private var _type:uint = 0;

		/**
		 * 提升取消管理员消息
		 * @param to 提升的用户
		 * @param op 执行操作的用户
		 * @param bool 是否为提升
		 *
		 */
		public function UpgradeManagerVo(to:IUserData = null, op:IUserData = null, type:uint = 0, bool:Boolean = true)
		{
			super();
			_toUser = to;
			_opUser = op;
			_isUpgrade = bool;
			_type = type;
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
			
			textElement = new TextElement(_toUser.name, this.getNameTF(_toUser));
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = _toUser;
			this._elems.push(textElement);
			
			var roleType:String = _type == 0 ? "神秘人" : _ilocal.get("role" + _type, "chatPanel");
			var info:String = " " + ((_isUpgrade ? _ilocal.get("msg_role_admin", "chatPanel") : _ilocal.get("msg_role_normal", "chatPanel")).replace("{0}", roleType));
			textElement = new TextElement(info, FontUtil.getFormat(0xec7218));
			this._elems.push(textElement);
		}

		override protected function dispose():void
		{
			super.dispose();
			_toUser = null;
			_opUser = null;
		}

		/**
		 * 操作类型
		 * @param value
		 *
		 */
		public function set type(value:uint):void
		{
			_type = value;
		}

		/**
		 * 执行操作的用户
		 */
		public function set opUser(value:IUserData):void
		{
			_opUser = value;
		}

		/**
		 * 被提升用户
		 */
		public function set toUser(value:IUserData):void
		{
			_toUser = value;
		}

		/**
		 * 是否为提升
		 */
		public function set isUpgrade(value:Boolean):void
		{
			_isUpgrade = value;
		}
	}
}