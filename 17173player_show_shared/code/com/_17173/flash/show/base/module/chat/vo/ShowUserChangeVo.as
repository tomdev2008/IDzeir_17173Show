package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;

	import flash.text.engine.TextElement;

	public class ShowUserChangeVo extends BaseChatVo
	{
		private var _data:Object;

		private var _micNames:Array = ["", "主麦", "二麦", "三麦"];

		public function ShowUserChangeVo(value:Object = null)
		{
			super();
			_data = value;
		}

		override protected function initVo():void
		{
			super.initVo();

			var iuser:IUser = Context.getContext(CEnum.USER) as IUser;

			this._elems.push(this.timeStamp);

			//切麦为2，抢麦为1，抱麦为0   切麦时，sorder和torder 都要用，抱麦和抢麦都用torder属性
			//suserinfo 是上麦的人， tuserinfo是原来麦上的人 , muserinfo 为操作的人
			switch(_data.type)
			{
				case 0:
					//抱麦
					giveMike(iuser.getUser(_data["muserinfo"].userId), iuser.getUser(_data["suserinfo"].userId), _data["torder"]);
					break;
				case 1:
					//抢麦
					grabMike(iuser.getUser(_data["muserinfo"].userId), iuser.getUser(_data["suserinfo"].userId), _data["torder"]);
					break;
				case 2:
					//切麦
					changeMike(iuser.getUser(_data["muserinfo"].userId), _data["sorder"], _data["torder"]);
					break;
			}
		}

		/**
		 * 抱麦操作
		 * @param opUser 操作员
		 * @param toUser 被操作用户
		 * @param torder 上麦的位置
		 *
		 */
		private function giveMike(opUser:IUserData, toUser:IUserData, torder:int):void
		{
			var textElement:TextElement = new TextElement(opUser.name, this.getNameTF(opUser));
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = opUser;
			_elems.push(textElement);
			textElement = new TextElement(" 将 ", FontUtil.getFormat(0xec7218));
			_elems.push(textElement);
			textElement = new TextElement(toUser.name, this.getNameTF(toUser));
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = toUser;
			_elems.push(textElement);
			textElement = new TextElement(" 抱上" + this._micNames[torder], FontUtil.getFormat(0xec7218));
			_elems.push(textElement);
		}
		/**
		 * 切麦操作
		 * @param opUser 操作员
		 * @param sorder 操作的麦
		 * @param torder 去到的麦
		 *
		 */
		private function changeMike(opUser:IUserData, sorder:int, torder:int):void
		{
			var textElement:TextElement = new TextElement(opUser.name, this.getNameTF(opUser));
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = opUser;
			_elems.push(textElement);
			textElement = new TextElement(" 将 " + this._micNames[sorder] + " 与 " + this._micNames[torder] + " 互换", FontUtil.getFormat(0xec7218));
			_elems.push(textElement);
		}
		/**
		 * 替麦操作
		 * @param opUser 操作员
		 * @param toUser 被操作用户
		 * @param torder 上麦位置
		 *
		 */
		private function grabMike(opUser:IUserData, toUser:IUserData, torder:int):void
		{
			var textElement:TextElement = new TextElement(opUser.name, this.getNameTF(opUser));
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = opUser;
			_elems.push(textElement);
			textElement = new TextElement(" 将 ", FontUtil.getFormat(0xec7218));
			_elems.push(textElement);
			textElement = new TextElement(toUser.name, this.getNameTF(toUser));
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = toUser;
			_elems.push(textElement);
			textElement = new TextElement(" 抱上" + this._micNames[torder], FontUtil.getFormat(0xec7218));
			_elems.push(textElement);
		}

		override public function reset():void
		{
			super.reset();
			this._elems.length = 0;
		}

		/**
		 * 麦上用户变更数据
		 */
		public function set data(value:Object):void
		{
			_data = value;
		}

		override protected function dispose():void
		{
			super.dispose();
			_data = null;
		}
	}
}