package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;

	import flash.text.engine.TextElement;

	/**
	 * 管理员开闭麦类
	 * @author idzeir
	 * 创建时间：2014-3-14  上午11:30:37
	 */
	public class MuteVideoVo extends BaseChatVo
	{
		private var _toUser:IUserData;
		private var _opUser:IUserData;

		private var _isMute:Boolean;

		private var _micNames:Array = ["", "主麦", "二麦", "三麦"];

		private var _order:Object = null;

		/**
		 * 关闭麦消息
		 * @param to 提升的用户
		 * @param op 执行操作的用户
		 * @param bool 是否为闭麦
		 *
		 */
		public function MuteVideoVo(to:IUserData = null, op:IUserData = null, bool:Boolean = true, micIndex:Object = null)
		{
			super();
			_toUser = to;
			_opUser = op;
			_isMute = bool;
			_order = micIndex;
		}

		override protected function initVo():void
		{
			super.initVo();
			this._elems.push(this.timeStamp);
			var textElement:TextElement;
			/*textElement=new TextElement(this.getUserName(_toUser),this.getNameTF(_toUser));
			   textElement.eventMirror=(Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			   textElement.userData=_toUser;
			   this._elems.push(textElement);
			   textElement=new TextElement(" 被 ", FontUtil.getFormat(0xec7218));
			 this._elems.push(textElement);*/
			textElement = new TextElement(_opUser.name, this.getNameTF(_opUser));
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = _opUser;
			this._elems.push(textElement);
			if(this._order)
			{
				textElement = new TextElement((_isMute ? " 关闭了" : " 打开了") + this._micNames[_order] + "声音。", FontUtil.getFormat(0xec7218));
			}
			else
			{
				textElement = new TextElement(_isMute ? " 关闭麦上声音。" : " 打开麦上声音。", FontUtil.getFormat(0xec7218));
			}
			this._elems.push(textElement);
		}

		override protected function dispose():void
		{
			super.dispose();
			_order = null;
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
		 * 被闭麦用户
		 */
		public function set toUser(value:IUserData):void
		{
			_toUser = value;
		}

		/**
		 * 是否为闭麦
		 */
		public function set isMute(value:Boolean):void
		{
			_isMute = value;
		}

		/**
		 * 三麦操作的麦序1,2,3. 单麦房默认为null
		 * @param value
		 *
		 */
		public function set order(value:Object):void
		{
			_order = value;
		}
	}
}