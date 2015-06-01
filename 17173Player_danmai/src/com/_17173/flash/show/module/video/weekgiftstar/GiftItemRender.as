package com._17173.flash.show.module.video.weekgiftstar
{
	import com._17173.flash.core.components.interfaces.IItemRender;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.HtmlUtil;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.module.gift.data.GiftData;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class GiftItemRender extends Sprite implements IItemRender
	{
		public function GiftItemRender()
		{
			super();
//			this.mouseChildren=false;
//			this.mouseEnabled=false;
			this.graphics.clear();
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0,0,46,30);
			this.graphics.endFill();
		}
		
		private var _giftDisplay:DisplayObject;
		public function startUp(value:Object):void
		{
			_giftDisplay = value["display"] as DisplayObject;
			this.addChild(_giftDisplay);
			_giftDisplay.x = (this.width - _giftDisplay.width)/2;
			_giftDisplay.y = (this.height - _giftDisplay.height)/2;
			
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			ui.registerTip(this,getTipString(value["giftData"]));
		}
		
		/**
		 *获取tip 
		 * @param data
		 * @return 
		 * 
		 */		
		private function getTipString(data:Object):String{
			var htmlString:String = "";
			htmlString = "<font color='#F8F8F8'>礼物: "+data.giftName+ "</font><br>";
			if(parseInt(data.rank)>30)
				htmlString += "<font color='#F8F8F8'>排名: 30+</font><br>";
			else
			    htmlString += "<font color='#F8F8F8'>排名: "+data.rank+"</font><br>";
			htmlString += "<font color='#F8F8F8'>数量: "+data.goods_number+"</font><br>";
			return htmlString;
		}
		
		public function onMouseOver():void
		{
			
		}
		
		public function onMouseOut():void
		{
		}
		
		public function onSelected():void
		{
		}
		
		public function unSelected():void
		{
		}
	}
}