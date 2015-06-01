package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.components.common.BitmapMovieClip;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.UserData;
	import com._17173.flash.show.base.model.MessageVo;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Shape;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextElement;
	
	/**
	 * 聊天区显示送礼记录
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 1, 2014||2:44:50 PM
	 */
	public class GiftHistoryVo extends BaseChatVo
	{
		private var _gift:MessageVo;
		
		private var _isExpensive:Boolean = false;
		
		public function GiftHistoryVo()
		{
			super();
		}
		
		/**
		 * 是否大于30块 区域显示
		 * @param value
		 * 
		 */		
		public function set isExpensive(value:Boolean):void
		{
			_isExpensive = value;
		}

		override protected function initVo():void
		{
			super.initVo();
			var iUser:IUser = Context.getContext(CEnum.USER) as IUser;
			
			var dot:Shape = createDot();
			
			this._elems.push(new GraphicElement(dot,dot.width,dot.height,FontUtil.getFormat()));
			
			this._elems.push(new TextElement(" ",FontUtil.getFormat()));
			this._elems.push(this.timeStamp);
			this._elems.push(new TextElement(" ",FontUtil.getFormat()));
			
			var has:Boolean = this.createGraphicFromArray(this.getUsericon(iUser.getUser(_gift.sid)));
			
			var textElement:TextElement = new TextElement((has?" ":"")+_gift.sName,FontUtil.getFormat(0x63ACFF));
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = iUser.getUser(_gift.sid)||(new UserData());
			this._elems.push(textElement);
			
			this._elems.push(new TextElement(" 送给 ",FontUtil.getFormat(0xCCCCCC)));
			
			textElement = new TextElement(_gift.tName,FontUtil.getFormat(0x63ACFF));
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = iUser.getUser(_gift.tid)||(new UserData());
			this._elems.push(textElement);
			
			this._elems.push(new TextElement(" "+_gift.giftCount+" ",this._isExpensive?FontUtil.getFormat(0xFFFF00):FontUtil.getFormat(0xFF9900)));//大于30块FFFF00
			this._elems.push(new TextElement("个 "+_gift.giftName+" ",FontUtil.getFormat(0xCCCCCC)));
			
			var giftIcon:BitmapMovieClip = new BitmapMovieClip(true,24,24);
			giftIcon.y = 3;
			giftIcon.url = _gift.giftDyEffect!=""?_gift.giftDyEffect:_gift.giftPicPath;
			this._elems.push(new GraphicElement(giftIcon,giftIcon.width,giftIcon.height,FontUtil.getFormat()));
		}
		
		override public function get elements():GroupElement
		{
			var ge:GroupElement = super.elements;
			ge.userData = {indent:55};
			return ge;
		}
		
		private function createDot():Shape
		{
			var dot:Shape = new Shape();
			dot.graphics.beginFill(0xffffff,.4);
			dot.graphics.drawCircle(0,0,2.5);
			dot.graphics.endFill();
			//dot.y = 1;
			return dot;
		}
		
		/**
		 * 礼物消息 
		 * @param value
		 * 
		 */		
		public function set gift(value:MessageVo):void
		{
			_gift = value;
		}
		
		override protected function dispose():void
		{
			super.dispose();
			_isExpensive = false;
			_gift = null;
		}
	}
}