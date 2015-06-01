package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.model.MessageVo;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.TextElement;

	/**
	 * 送礼物信息类
	 * @author idzeir
	 * 创建时间：2014-3-14  下午1:38:20
	 */
	public class GiftInfoVo extends BaseChatVo
	{
		private var _gift:MessageVo;
		/**
		 * 显示ico大小
		 */
		private const SIZE:uint = 26;
		/**
		 * 最大显示ico个数
		 */
		private const MAX_COUNT:uint = 100;

		/**
		 * 赠送礼物消息
		 * @param info
		 *
		 */
		public function GiftInfoVo(info:MessageVo = null)
		{
			super();
			_gift = info;
		}
		
		override protected function initVo():void
		{
			super.initVo();
			this._elems.push(this.timeStamp);
			
			var textElement:TextElement = new TextElement(_gift.sName, FontUtil.getFormat(0x63acff));
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = (Context.getContext(CEnum.USER) as IUser).getUser(_gift.sid);
			_elems.push(textElement);

			textElement = new TextElement(" 向 ", FontUtil.getFormat(0xd0cfcf));
			_elems.push(textElement);

			textElement = new TextElement(_gift.tName, FontUtil.getFormat(0x63acff));
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = (Context.getContext(CEnum.USER) as IUser).getUser(_gift.tid);
			_elems.push(textElement);
			
			textElement = new TextElement(" 送 ", FontUtil.getFormat(0xd0cfcf));
			_elems.push(textElement);
			
			var total:uint = Math.min(parseInt(_gift.giftCount), MAX_COUNT);
			var itemBox:Array = [];			
			var getBitmapCall:Function = function(value:Object):void
			{				
				for each(var i:Sprite in itemBox)
				{
					var bitmap:Bitmap = (value as IResourceData).newSource as Bitmap;
					bitmap.x = (giftBox.width-bitmap.width)>>1;
					bitmap.y = (giftBox.height-bitmap.height)>>1;
					i.addChild(bitmap);
					i.graphics.clear();
				}				
			};				
			for(var i:uint = 0; i < total; i++)
			{
				var giftBox:Sprite = new Sprite();
				giftBox.graphics.beginFill(0x000000, 0);
				giftBox.graphics.drawRect(0, 0, SIZE, SIZE);
				giftBox.graphics.endFill();
				
				itemBox.push(giftBox);
				giftBox.y = 3;				
				var graphic:GraphicElement = new GraphicElement(giftBox, SIZE, SIZE, FontUtil.getFormat());
				_elems.push(graphic)
			}			
			(Context.getContext(CEnum.SOURCE) as IResourceManager).loadResource(_gift.giftPicPath, getBitmapCall);
			
			textElement = new TextElement(" "+_gift.giftName+"，共", FontUtil.getFormat(0xd0cfcf));
			_elems.push(textElement);
			
			textElement = new TextElement(" " + _gift.giftCount, FontUtil.getFormat(0xefe46c));
			_elems.push(textElement);

			textElement = new TextElement(" 个 ", FontUtil.getFormat(0xd0cfcf));
			_elems.push(textElement);
		}

		/**
		 * 礼物数据
		 */
		public function set gift(value:MessageVo):void
		{
			_gift = value;
		}

		override protected function dispose():void
		{
			super.dispose();
			_gift = null;
		}
	}
}