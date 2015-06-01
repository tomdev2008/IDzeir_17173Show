package com._17173.flash.show.base.module.animation.biganimation
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.module.animation.base.AnimationObject;
	import com._17173.flash.show.base.module.animation.base.AnimationType;
	import com._17173.flash.show.base.module.animation.base.BaseAmtControl;
	import com._17173.flash.show.base.module.gift.data.GiftData;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.Event;
	
	public class BigAnimation extends BaseModule
	{
		private var _bac:BaseAmtControl = null;
		private var _layer:BigAnimationLayer = null;
		private var _event:IEventManager = null;
		private var _cacheMsg:Array = null;
		public function BigAnimation()
		{
			super();
			_version = "0.0.1";
			mouseChildren = false;
			mouseEnabled = false;
			_cacheMsg = [];
		}
		
		
		private function initLsn():void{
			_event = Context.getContext(CEnum.EVENT) as IEventManager;
			_event.listen(SEvents.GIFT_BIG_ANIMATION,addGiftAmt);
			_event.listen(SEvents.GIFT_ANIMATION_PLAY_END,onPlayEnd);
			_event.listen(SEvents.GIFT_EFFECT_CLOSE,onEffectClose);
			_event.listen(SEvents.GIFT_EFFECT_OPEN,onEffectOpen);
		}
		
		private function removeLsn():void{
			_event = Context.getContext(CEnum.EVENT) as IEventManager;
			_event.remove(SEvents.GIFT_BIG_ANIMATION,addGiftAmt);
			_event.remove(SEvents.GIFT_ANIMATION_PLAY_END,onPlayEnd);
			_event.remove(SEvents.GIFT_EFFECT_CLOSE,onEffectClose);
			_event.remove(SEvents.GIFT_EFFECT_OPEN,onEffectOpen);
		}
		
		override protected function onRemove(event:Event):void{
			removeLsn();
		}
		
		private function onEffectClose(data:Object = null):void{
			clear();
			this.visible = false;
		}
		
		private function onEffectOpen(data:Object = null):void{
			_bac.startPlay();
			this.visible = true;
		}
		
		override protected function init():void{
			_layer = new BigAnimationLayer();
			this.addChild(_layer);
			//创建控制类
			_bac = new BigAmtControl(AnimationType.ATYPE_CAR,_layer);
			_bac.startPlay();
			_bac.playEndCallBack = onNext;
			initLsn();
		}
		/**
		 *动画结束 
		 * @param array
		 * 
		 */		
		private function onPlayEnd(array:Array):void{
			var type:String = array[0];
			var data:Object = array[1];
			if(type == AnimationType.ATYPE_CAR){
				//播放小动画
				_event.send(SEvents.GIFT_CAR_RUNWAY,data);
			}
			else if(type == AnimationType.ATYPE_FLOWER){
				_event.send(SEvents.GIFT_FLOWER_MINI,data);
			}
		}
		
		private function addGiftAmt(obj:Object):void{
			//是否能够显示礼物
			if(obj.giftType == AnimationType.ATYPE_TUZI || obj.giftType == AnimationType.ATYPE_TECH){
				_cacheMsg.push(obj);
			}else{
				var count:int = obj.giftCount;
				while(count > 0){
					_cacheMsg.push(obj);
					count--;
				}
			}
		
			if(!_bac.playItem && !_bac.loading){
				onNext();
			}
		}
		
		private function onNext():void{
			if(_cacheMsg && _cacheMsg.length > 0){
				var obj:Object = _cacheMsg.shift();
				var at:AnimationObject
				if(obj.giftType == GiftData.GIFT_TYPE_FLOWER){
//					obj.giftKey = "Flower_lanseyaoji";
					at = AnimationObject.getAmd(obj.giftSwfPath,AnimationType.ATYPE_FLOWER,_layer);
//					at = AnimationObject.getAmd("assets/fl.swf",AnimationType.ATYPE_FLOWER,_layer);
					at.data = obj;
				}else if(obj.giftType == GiftData.GIFT_TYPE_CAR){
					at = AnimationObject.getAmd(obj.giftSwfPath,AnimationType.ATYPE_CAR,_layer);
//					at = AnimationObject.getAmd("assets/car.swf",AnimationType.ATYPE_CAR,_layer);
					at.data = obj;
				}else if(obj.giftType == AnimationType.ATYPE_TUZI){
//					obj.giftKey = "yutu_20140822";
					at = AnimationObject.getAmd(obj.giftSwfPath,AnimationType.ATYPE_TUZI,_layer);
//					at = AnimationObject.getAmd("assets/yutu.swf",AnimationType.ATYPE_TUZI,_layer);
					at.data = obj;
				}else if(obj.giftType == AnimationType.ATYPE_TECH){
//					obj.giftKey = "juhua_20140825";
					at = AnimationObject.getAmd(obj.giftSwfPath,AnimationType.ATYPE_TECH,_layer);
//					at = AnimationObject.getAmd("assets/juhua.swf",AnimationType.ATYPE_TECH,_layer);
					at.data = obj;
				}
				addAmdData(at);
			}
		}
		
		/**
		 * 清空所有数据和当前动画 
		 */		
		private function clear():void {
			//清空已缓存的
			clearCacheData();
			_bac.stopPlay();
		}
		
		/**
		 *清理缓存数据 <br>
		 * 如果数据属于花篮，需要收集数据后显示小花,注意此处需要将giftcount修改成1否则小花篮计算数量会错误
		 */		
		private function clearCacheData():void{
			var len:int = _cacheMsg.length;
			var data:Object;
			var arr:Array = [];
			for (var i:int = 0; i < len; i++) 
			{
				data = _cacheMsg[i];
				
				if(data.giftType == GiftData.GIFT_TYPE_FLOWER){
					data.giftCount = 1;
					arr[arr.length] = data;
				}
			}
			_cacheMsg.splice(0, _cacheMsg.length);
			if(arr && arr.length>0){
				len = arr.length;
				//判断如果数量大于12个则只保留最后12个，因为舞台只能显示小花12个
				if(len > 12){
					arr = arr.slice(len - 12,len);
				}
				//派发显示小花事件(该事件不执行动画)
				Context.getContext(CEnum.EVENT).send(SEvents.GIFT_ANIMATION_HX,arr);
			}
		}
		
		/**
		 *添加动画 
		 * @param amtd
		 * 
		 */		
		public function addAmdData(amtd:AnimationObject):void{
			_bac.addData(amtd);
		}
	}
}