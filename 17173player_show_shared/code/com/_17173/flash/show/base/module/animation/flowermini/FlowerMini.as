package com._17173.flash.show.base.module.animation.flowermini
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.model.MessageVo;
	import com._17173.flash.show.base.module.animation.base.AnimationObject;
	import com._17173.flash.show.base.module.animation.base.AnimationType;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.Event;
	
	public class FlowerMini extends BaseModule
	{
		/**
		 *动画控制器字典 
		 */		
		private var _bac:FlowerMiniAmtControl = null;
		private var _layer:FlowerMiniLayer = null;
		public function FlowerMini()
		{
			super();
			_version = "0.0.1";
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		override protected function init():void{
			_layer = new FlowerMiniLayer();
			this.addChild(_layer);
			//创建控制类
			_bac = new FlowerMiniAmtControl(AnimationType.ATYPE_FLOWER_MINI,_layer);
			_bac.startPlay();
			initLsn();
			this.graphics.beginFill(0xff0000,0);
			this.graphics.drawRect(0,0,1,1);
			this.graphics.endFill();
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		private function initLsn():void{
			var event:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			event.listen(SEvents.GIFT_FLOWER_MINI,addGiftAmt);
			event.listen(SEvents.GIFT_ANIMATION_HX,addExtFlow);
			event.listen(SEvents.GIFT_EFFECT_CLOSE,onEffectClose);
			event.listen(SEvents.GIFT_EFFECT_OPEN,onEffectOpen);
		}
		
		
		private function removeLsn():void{
			var event:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			event.remove(SEvents.GIFT_FLOWER_MINI,addGiftAmt);
			event.remove(SEvents.GIFT_EFFECT_CLOSE,onEffectClose);
			event.remove(SEvents.GIFT_EFFECT_OPEN,onEffectOpen);
		}
		
		private function onEffectClose(data:Object = null):void{
			clear();
			_layer.closeEff();
		}
		
		/**
		 * 清空所有数据和当前动画 
		 */		
		private function clear():void {
			//停止小花动画
		}
		
		private function onEffectOpen(data:Object = null):void{
			_layer.openEff();
		}
		
		override protected function onRemove(event:Event):void{
			removeLsn();
		}
		
		private function addGiftAmt(obj:Object):void{
			//是否能够显示礼物
			var showGift:Boolean = Context.variables["showData"].showGift;
			if (showGift == false) return;
			
			var at:AnimationObject = AnimationObject.getAmd(obj.giftSwfPath1,AnimationType.ATYPE_FLOWER_MINI,_layer);
//			var at:AnimationObject = AnimationObject.getAmd("assets/fl1.swf",AnimationType.ATYPE_FLOWER_MINI,_layer);
			at.data = obj;
			addAmdData(at);
		}
		/**
		 *添加动画 
		 * @param amtd
		 * 
		 */		
		public function addAmdData(amtd:AnimationObject):void{
			_bac.addData(amtd);
		}
		/**
		 *已经存在的花 
		 * @param data
		 * 
		 */		
		private function addExtFlow(data:Array):void{
			if(data.length == 0) return;
			var msg:Array = checkArray(data);
			var len:int = msg.length;
			for (var i:int = 0; i < len; i++) 
			{
				var ct:int = msg[i].giftCount;
				for(var j:int = 0; j< ct ; j++){
					var at:AnimationObject = AnimationObject.getAmd(msg[i].giftSwfPath1,AnimationType.ATYPE_FLOWER_MINI,_layer);
					at.data = msg[i];
					_bac.addExtData(at);
				}
			}
		}
		/**
		 *整理数据，数量大于12则不显示 
		 * @param data
		 * @return 
		 * 
		 */		
		private function checkArray(data:Array):Array{
			var count:int = 0;
			var array:Array = [];
			var tmpVo:MessageVo;
			var len:int = data.length-1;
			while(len >= 0 && count < 12){
				var vo:MessageVo = data[len] as MessageVo;
				if((count + int(vo.giftCount)) > 12){
					tmpVo = vo.clone();
					tmpVo.giftCount = (12 - count) + "";
					count = 12;
					array[array.length] = tmpVo;
				}else{
					array[array.length] = vo;
				}
				count = count + int(vo.giftCount);
				len--;
			}
			return array;
		}
		
	}
}