package com._17173.flash.show.base.module.animation.biganimation
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.module.animation.IAnimationFactory;
	import com._17173.flash.show.base.module.animation.base.AnimationType;
	import com._17173.flash.show.base.module.animation.base.BaseAmtControl;
	import com._17173.flash.show.base.module.animation.base.IAnimationPlay;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.Event;
	
	public class BigAnimation extends BaseModule
	{
		private var _bac:BaseAmtControl = null;
		private var _layer:BigAnimationLayer = null;
		private var _event:IEventManager = null;
		private var _cacheMsg:Array = null;
		private var _filters:Array = null;
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
			_event.listen(SEvents.GIFT_ANIMATION_PLAY_END,onPlayEnd);
			_event.listen(SEvents.GIFT_EFFECT_CLOSE,onEffectClose);
			_event.listen(SEvents.GIFT_EFFECT_OPEN,onEffectOpen);
		}
		
		private function removeLsn():void{
			_event = Context.getContext(CEnum.EVENT) as IEventManager;
			_event.remove(SEvents.GIFT_ANIMATION_PLAY_END,onPlayEnd);
			_event.remove(SEvents.GIFT_EFFECT_CLOSE,onEffectClose);
			_event.remove(SEvents.GIFT_EFFECT_OPEN,onEffectOpen);
		}
		/**
		 * 是否需要启用count进行动画
		 * 
		 */		
		private function initCountFilter():void{
			_filters = [];
			_filters[_filters.length] = AnimationType.ATYPE_CAR;//车
			_filters[_filters.length] = AnimationType.ATYPE_FLOWER;//花
			_filters[_filters.length] = AnimationType.ATYPE_GUOQING2;//国庆
			_filters[_filters.length] = AnimationType.ATYPE_D11;//组图
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
			initCountFilter();
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
		
		public function addGiftAmt(obj:Object):void{
			//是否能够显示礼物
			if(filterPass(obj.effectType))
			{
				var count:int = obj.giftCount;
				while(count > 0){
					addtoCache(obj);
					count--;
				}
				
			}else{
				addtoCache(obj);
			}
			
			if(!_bac.playItem && !_bac.loading){
				onNext();
			}
		}
		
		
		
		/**
		 *添加数据并进行简单检测 
		 * @param data
		 * 
		 */		
		private function addtoCache(data:Object):void{
			if(data.giftSwfPath == null || data.giftSwfPath == ""){
				Debugger.log(Debugger.INFO, "[biganimation]", "没有动画地址:"+data);
				return ;
			}
			_cacheMsg.push(data);
		}
		/**
		 *检测是否可以通过 
		 * @param type
		 * @return 
		 * 
		 */		
		private function filterPass(type:String):Boolean{
			var result:Boolean = false;
			var tmptype:String;
			var len:int = _filters.length;
			for (var i:int = 0; i < len; i++) 
			{
				tmptype = _filters[i] as String;
				if(type == tmptype){
					result = true;
				}
			}
			return result;
			
		}
		
		
		private function onNext():void{
			var ac:IAnimationFactory = (Context.getContext(CEnum.ANIMATIONFACTORY) as IAnimationFactory);
			if(_cacheMsg && _cacheMsg.length > 0){
				var obj:Object = _cacheMsg.shift();
				var at:IAnimationPlay;
				//执行测试
//				obj.effectType = AnimationType.GROUP_AM;
//				obj.giftSwfPath = "assets/xiao.swf";
//				obj.giftKey = "yanhua_20150115_1";
//				
				
				at = ac.getAmd(obj.giftSwfPath,obj.effectType,_layer);
				at.data = obj;
				addAmdData(at);
			}
		}
		/**
		 *以前用的测试数据 
		 * 
		 */		
		private function test():void{
//				if(obj.effectType == AnimationType.ATYPE_FLOWER){
//					at = ac.getAmd(obj.giftSwfPath,AnimationType.ATYPE_FLOWER,_layer);
//					//obj.giftKey = "juhua_20140825";
////					at = ac.getAmd(("assets/feiji.swf",AnimationType.ATYPE_FLOWER,_layer);
//					at.data = obj;
//				}else if(obj.effectType == AnimationType.ATYPE_CAR){
//					at = ac.getAmd(obj.giftSwfPath,AnimationType.ATYPE_CAR,_layer);
////					obj.giftKey = "feiji20140917";
////					at = ac.getAmd("assets/feiji.swf",AnimationType.ATYPE_CAR,_layer);
//					at.data = obj;
//				}else if(obj.effectType == AnimationType.ATYPE_TUZI){
////					obj.giftKey = "yutu_20140822";
//					at = ac.getAmd(obj.giftSwfPath,AnimationType.ATYPE_TUZI,_layer);
////					at = ac.getAmd("assets/yutu.swf",AnimationType.ATYPE_TUZI,_layer);
//					at.data = obj;
//				}else if(obj.effectType == AnimationType.ATYPE_TECH){
////					obj.giftKey = "juhua_20140825";
//					at = ac.getAmd(obj.giftSwfPath,AnimationType.ATYPE_TECH,_layer);
////					at = ac.getAmd("assets/juhua.swf",AnimationType.ATYPE_TECH,_layer);
//					at.data = obj;
//				}else if(obj.effectType == AnimationType.ATYPE_GUOQING1){
////					obj.giftKey = "chaojilipao_20140920";
//					at = ac.getAmd(obj.giftSwfPath,AnimationType.ATYPE_GUOQING1,_layer);
////					at = ac.getAmd("assets/chaojilipao.swf",AnimationType.ATYPE_GUOQING1,_layer);
//					at.data = obj;
//				}else if(obj.effectType == AnimationType.ATYPE_GUOQING2){
////					obj.giftKey = "putonglibao_20140821";
//					at = ac.getAmd(obj.giftSwfPath,AnimationType.ATYPE_GUOQING2,_layer);
////					at = Aac.getAmd("assets/putonglipao.swf",AnimationType.ATYPE_GUOQING2,_layer);
//					at.data = obj;
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
				
				if(data.effectType == AnimationType.ATYPE_FLOWER){
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
		public function addAmdData(amtd:IAnimationPlay):void{
			try{
				_bac.addData(amtd);
			}catch(e:Error){
			}
		}
	}
}