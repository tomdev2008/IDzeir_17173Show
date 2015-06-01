package com._17173.flash.show.module.video.weekgiftstar
{
	import com._17173.flash.core.components.common.List;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.components.common.Grid9Skin;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.ShowData;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class WeekGiftStarPanel extends Sprite
	{
		/** 周星图标 **/
		private var _giftStarMc:WeekRankIconMc;
		/** 周星列表 **/
		private var _list:List;
		/** 遮罩 **/
		private var _maskOver:Shape;
		
		public function WeekGiftStarPanel()
		{
			super();
			this.graphics.clear();
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0,0,46,362);
			this.graphics.endFill();
			
			_giftStarMc=new WeekRankIconMc();
			this.addChild(_giftStarMc);
			_giftStarMc.x = 4;
			_giftStarMc.y = 4;
//			_giftStarMc.visible=false;

			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			ui.registerTip(_giftStarMc,"TA的礼物周星");
			
			_list = new List(319,false,GiftItemRender);
			var s:Sprite = new Grid9Skin(Slider_thumb);
			s.width = 3;
			_list.sliderSkin(s);
			_list.width = 46;
			_list.y = 45;
			_list.bglayerAlpha = 0;
			_list.scrollBar.policy = "auto";
			this.addChild(_list);
			
			_maskOver = new Shape();
			_maskOver.graphics.clear();
			_maskOver.graphics.beginFill(0,.3);
			_maskOver.graphics.drawRect(1,0,45,365);
			_maskOver.graphics.endFill();			
			this.addChild(_maskOver);
			
			_list.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			_list.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			_giftStarMc.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			_giftStarMc.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
		}
		/**
		 * 设置周星数据
		 * 礼物数组，以礼物类型为主键的数据集合
		 * 每个礼物包含主播的id 礼物id等
		 * @param value
		 * 
		 */		
		public function setWeedGiftStarData(value:Object):void
		{
			_giftStarMc.visible=true;
			/** 礼物之星 **/
		    var giftStarArray:Array = new Array();
			var showData:ShowData = Context.variables.showData;
//			var giftArray:Array = value.weekGiftStar as Array;
			var giftArray:Array = value as Array;
			var max:int = 10;
			var index:int = 0;
			for each(var item:Object in giftArray)
			{
//				if(item.masterId == showData.roomOwnMasterID)
//				{
//					var giftDisplay:DisplayObject = Utils.getURLGraphic(item.giftPath,true,24,24);					
//					giftStarArray.push({"display":giftDisplay,"giftData":item});
//				}
				var giftDisplay:DisplayObject = Utils.getURLGraphic(item.smallPic,true,24,24);					
				giftStarArray.push({"display":giftDisplay,"giftData":item});
				index++;
				if(index == max)
					break;
			}
			if(giftStarArray.length>0)
			{
				_list.dataProvider = giftStarArray;
				_list.scrollBar.visible=false;
			}
			else
				_list.clear();
		}
		
//		private function hasGiftStar(data:Object):Boolean
//		{
//			return _giftStarArray.some(function (item:Object,index:int,array:Array):Boolean{
//				if(item.giftId == data.giftId)return true;
//				else return false;
//			});
//		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			_maskOver.alpha = 0;
			if(_list.scrollBar.enable)
			_list.scrollBar.visible=true;
		}
			
		private function mouseOutHandler(event:MouseEvent):void
		{
			_maskOver.alpha = 1;
			_list.scrollBar.visible=false;
		}
	}
}