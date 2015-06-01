package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	
	import flash.text.engine.ElementFormat;
	import flash.text.engine.TextElement;
	
	/**
	 * 直播状态改变消息类
	 * @author idzeir
	 * 创建时间：2014-3-14  上午11:42:43
	 */
	public class VideoStatusVo extends BaseChatVo
	{
		private var _isBegin:Boolean;
		private var _data:*;

		/**
		 * 直播开启关闭 信息
		 * @param value
		 * @param bool 是否开启
		 *
		 */
		public function VideoStatusVo(value:* = null, bool:Boolean = true)
		{
			super();
			_data = value;
			_isBegin = bool;
		}

		override protected function initVo():void
		{
			super.initVo();
			this._elems.push(this.timeStamp);
			
			var tf:ElementFormat = FontUtil.getFormat(0x63acff);
			var textElement:TextElement;
			
			//code==3是被人下麦
			if(_data["code"]==3){
				var op:IUserData = (Context.getContext(CEnum.USER) as IUser).getUser(_data["userId"]);
				textElement = new TextElement(this.getUserName(op),tf);
				textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
				textElement.userData = op;
				this._elems.push(textElement);
				
				textElement = new TextElement(" 将 ", FontUtil.getFormat(0xec7218));
				this._elems.push(textElement);
			}
			
			textElement = new TextElement(Utils.formatToString(_data.nickName), tf);
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = (Context.getContext(CEnum.USER) as IUser).getUser(_data["masterId"]);
			this._elems.push(textElement);
			
			var info:String = _isBegin ? " 开始直播" : " 结束直播";
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
		 * 是否为开启
		 */
		public function set isBegin(value:Boolean):void
		{
			_isBegin = value;
		}
	}
}