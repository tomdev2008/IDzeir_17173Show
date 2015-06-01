package com._17173.flash.show.base.module.animation.carmini
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.module.animation.IAnimationFactory;
	import com._17173.flash.show.base.module.animation.base.AnimationType;
	import com._17173.flash.show.base.module.animation.base.BaseAmtControl;
	import com._17173.flash.show.base.module.animation.base.BaseAnimationLayer;
	import com._17173.flash.show.base.module.animation.base.IAnimationPlay;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.Event;
	
	public class CarRunway extends BaseModule
	{
		/**
		 *动画控制器字典 
		 */		
		private var _bac:BaseAmtControl = null;
		private var _layer:BaseAnimationLayer = null;
		public function CarRunway()
		{
			super();
			_version = "0.0.1";
			mouseChildren = false;
			mouseEnabled = false;
			//425 534;
		}
		
		override protected function init():void{
			_layer = new BaseAnimationLayer();
			this.addChild(_layer);
			//创建控制类
			_bac = new BaseAmtControl(AnimationType.ATYPE_CAR_MINI,_layer);
			_bac.startPlay();
			initLsn();
		}
		
		private function initLsn():void{
			var event:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
//			event.listen(SEvents.GIFT_CAR_RUNWAY,addGiftAmt1);
			event.listen(SEvents.GIFT_EFFECT_CLOSE,onEffectClose);
			event.listen(SEvents.GIFT_EFFECT_OPEN,onEffectOpen);
		}
		
		
		private function removeLsn():void{
			var event:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
//			event.remove(SEvents.GIFT_CAR_RUNWAY,addGiftAmt1);
			event.remove(SEvents.GIFT_EFFECT_CLOSE,onEffectClose);
			event.remove(SEvents.GIFT_EFFECT_OPEN,onEffectOpen);
		}
		
		private function onEffectClose(data:Object = null):void{
			clear();
			this.visible = false;
		}
		
		/**
		 * 清空所有数据和当前动画 
		 */		
		private function clear():void {
			if (_bac) {
				_bac.stopPlay();
			}
		}
		
		private function onEffectOpen(data:Object = null):void{
			this.visible = true;
		}
		
		override protected function onRemove(event:Event):void{
			removeLsn();
		}
		
		private function addGiftAmt1(obj:Object):void{
			//是否能够显示礼物
			var showGift:Boolean = Context.variables["showData"].showGift;
			if (showGift == false) return;
			var ac:IAnimationFactory = (Context.getContext(CEnum.ANIMATIONFACTORY) as IAnimationFactory);
		    var at:IAnimationPlay = ac.getAmd(obj.giftSwfPath1,AnimationType.ATYPE_CAR_MINI,_layer);
//			at = ac.getAmd("assets/car1.swf",AnimationType.ATYPE_CAR_MINI,_layer);
			at.data = obj;
			addAmdData(at);
		}
		/**
		 *添加动画 
		 * @param amtd
		 * 
		 */		
		public function addAmdData(amtd:IAnimationPlay):void{
			_bac.addData(amtd);
		}
		
	}
}