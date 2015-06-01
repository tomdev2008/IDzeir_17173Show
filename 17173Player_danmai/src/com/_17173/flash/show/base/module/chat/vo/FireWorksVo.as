package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.components.common.BitmapMovieClip;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.model.MessageVo;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;

	import flash.text.engine.GraphicElement;
	import flash.text.engine.TextElement;

	/**
	 * 烟花公聊,私聊显示
	 * @author idzeir
	 */	
	public class FireWorksVo extends BaseChatVo
	{
		private var _gift:MessageVo;		

		public function FireWorksVo()
		{
			super();
		}

		/**
		 * 大小眼花数据
		 */
		public function set gift(value:MessageVo):void
		{
			_gift = value;
		}

		private function get toPersons():String
		{
			return _ilocal.get("fireworks_"+_gift.giftId,"chatPanel");
		}

		override protected function initVo():void
		{
			var iUser:IUser = Context.getContext(CEnum.USER) as IUser;

			super.initVo();
			this._elems.push(this.timeStamp);

			var textElement:TextElement = new TextElement(" "+_gift.sName+" ",FontUtil.getFormat(0x63acff))
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = iUser.getUser(_gift.sid);
			this._elems.push(textElement);

			this._elems.push(new TextElement("为",FontUtil.getFormat(0xFF9900)));

			this._elems.push(new TextElement(" "+toPersons+" ",FontUtil.getFormat(0x63acff)));

			this._elems.push(new TextElement("点燃了 ",FontUtil.getFormat(0xFF9900)));


			var total:uint = uint(_gift.giftCount);
			for(var i:uint = 0;i<total;++i)
			{
				var giftShape:BitmapMovieClip = new BitmapMovieClip(true,24,24);
				if(_gift.giftDyEffect!="")
				{
					giftShape.url = _gift.giftDyEffect;
				}else{
					giftShape.url = _gift.giftPicPath;
				}
				this._elems.push(new GraphicElement(giftShape,giftShape.width,giftShape.height,FontUtil.getFormat()));
			}			

			this._elems.push(new TextElement(" " + _gift.giftCount,FontUtil.getFormat(0xFFFF00)));

			this._elems.push(new TextElement(" 个 ",FontUtil.getFormat(0xFF9900)));		

			this._elems.push(new TextElement(_gift.giftName,FontUtil.getFormat(0xCCCCCC)));
		}

		override protected function dispose():void
		{
			super.dispose();
			_gift = null;
		}
	}
}

