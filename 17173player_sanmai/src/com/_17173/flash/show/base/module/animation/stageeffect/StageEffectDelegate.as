package com._17173.flash.show.base.module.animation.stageeffect
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class StageEffectDelegate extends BaseModuleDelegate
	{
		public function StageEffectDelegate()
		{
			super();
		}
		
		override protected function onModuleLoaded():void
		{
			Ticker.tick(2000,function ():void{
				addListeners();
			});
		}
		
		private function addListeners():void
		{
			//礼物消息
			this._e.listen(SEvents.STAGE_GIFT_SEAT_COOR,onGiftMsg);
		}
		
		private function onGiftMsg(data:Object):void
		{
			var point:Point = data.point;
			var msg:Object = data.msg;
			
			var giftVector:Vector.<DisplayObject> = getMesstByGift(msg);
			if(giftVector == null){
				return;
			}
			if(this.module)
				this.module["showGift"]({"giftVector":giftVector,"point":point});
		}
        private var _giftObj:Object = new Object();
		private function getMesstByGift(data:Object):Vector.<DisplayObject>{

			var giftDisplay:DisplayObject;
			var giftVector:Vector.<DisplayObject>; 
			if(data != null){
				giftVector = new Vector.<DisplayObject>;
				var textManager:IGraphicTextManager = Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager;			
				var giftId:String = data.giftId;
				var giftName:String = data.giftName;
				var giftCount:int = int(data.giftCount);
				var giftPicPath:String = data.giftPicPath;
				if(giftCount>10)
					giftCount = 10;
				var i:int;
				if(giftId in _giftObj)
				{
					var giftVectorTemp:Vector.<DisplayObject> = _giftObj[giftId];
					if(giftVectorTemp.length < 200)
					{
						for(i = 0; i<giftCount;i++)
						{
							giftDisplay = Utils.getURLGraphic(giftPicPath,true,40,40);
							giftDisplay.visible=false;
							giftVectorTemp.push(giftDisplay);
							giftVector.push(giftDisplay);
							//trace("giftVectorTemp: "+giftVectorTemp.length);
						}
						
						_giftObj[giftId] = giftVectorTemp;
					}else
					{
						for(i = 0; i<giftCount;i++)
						{
							giftVector.push(giftVectorTemp.shift());
						}
					}
				}else
				{
					for(i = 0; i<giftCount;i++)
					{
						giftDisplay = Utils.getURLGraphic(giftPicPath,true,40,40);
						giftDisplay.visible=false;
						giftVector.push(giftDisplay);
					}
					
					_giftObj[giftId] = giftVector;
				}
				
			}
			return giftVector;
		}
	}
}