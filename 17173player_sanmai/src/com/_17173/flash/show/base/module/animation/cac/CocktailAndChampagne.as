package com._17173.flash.show.base.module.animation.cac
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.module.animation.IAnimationFactory;
	import com._17173.flash.show.base.module.animation.base.AnimationType;
	import com._17173.flash.show.base.module.animation.base.IAnimationPlay;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.Event;
	
	/**
	 *鸡尾酒香槟动画
	 * @author zhaoqinghao
	 *
	 */
	public class CocktailAndChampagne extends BaseModule
	{
		/**
		 *动画控制器字典
		 */
		private var _bac:CACAmtControl = null;
		private var _layer:CACLayer = null;
		private var _lineLayer:CACLineLayer = null;
		private var _cacheMsg:Array = null;
		/**
		 *动画添加到舞台的间隔帧(正常30/S)
		 */		
		private const SHOW_DATA_SPACE_FR:int = 15;
		/**
		 *一次性添加到舞台的动画个数 
		 */		
		private const SHOW_AMCOUNT_LIMIT:int = 200;
		/**
		 *单组动画上限 
		 */		
		private const SING_COUNT_LIMIT:int = 66;
		
		public function CocktailAndChampagne()
		{
			super();
			_version = "0.0.1";
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		override protected function init():void
		{
			_cacheMsg = [];
			_layer = new CACLayer();
			_layer.x = CACConfig.getInstans().setX;
			_layer.y = CACConfig.getInstans().setY;
			this.addChild(_layer);
			
			_lineLayer = new CACLineLayer();
			_lineLayer.x = 0;
			_lineLayer.y = CACConfig.getInstans().lineY;
			this.addChild(_lineLayer);
			//创建控制类
			_bac = new CACAmtControl(AnimationType.ATYPE_FLOWER_MINI, _layer);
			_bac.startPlay();
			initLsn();
			run();
//			Ticker.tick(5000,test,1);
		}
		
		
		private function initLsn():void
		{
			var event:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			event.listen(SEvents.GIFT_EFFECT_CLOSE, onEffectClose);
			event.listen(SEvents.GIFT_EFFECT_OPEN, onEffectOpen);
		}
		
		
		private function removeLsn():void
		{
			var event:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			event.remove(SEvents.GIFT_EFFECT_CLOSE, onEffectClose);
			event.remove(SEvents.GIFT_EFFECT_OPEN, onEffectOpen);
		}

		
		private function onEffectClose(data:Object = null):void
		{
			this.visible = false;
			close2Clear();
		}
		
		private function onEffectOpen(data:Object = null):void
		{
			_bac.startPlay();
			_lineLayer.start();
			this.visible = true;
		}
		
		
//		private function test():void{
//			
//			var vo:MessageVo = new MessageVo();
//			vo.giftCount = int(Math.random() * 100)+"";
//			vo.giftId = "5702";
//			vo.giftSwfPath = "http://i2.v.17173cdn.com/upload/show/20140426/184336/521625b9-9d94-4534-ba93-8b2fc099cd85.swf";
//			vo.giftKey = "Normal_xiangbin";
//			addGiftAmt(vo);
//			if(_cacheMsg.length < 10000){
//				Ticker.tick(50,test,1);
//			}
//		}
		
		public function addGiftAmt(obj:Object):void
		{
			//判断是否有动画地址
			//			obj.giftKey = "Normal_xiangbin";
			var ac:IAnimationFactory = (Context.getContext(CEnum.ANIMATIONFACTORY) as IAnimationFactory);
			if (obj.giftSwfPath && obj.giftSwfPath != "")
			{
				var count:int = Math.min(obj.giftCount, CACConfig.getInstans().showLimit);
				var arr:Array = [];
				while (count > 0)
				{
					var at:IAnimationPlay = ac.getAmd(obj.giftSwfPath, AnimationType.ATYPE_CAC, _layer);
					at.data = obj;
					arr[arr.length] = at;
					count--;
				}
				//记录每个位置
				_layer.setupPostion(arr);
				//即时显示
//				addAmdData(arr);
				//队列显示
				addCacheData(arr);
			}
			//播放条动画
			if (obj.isSpecialGift == 1 && obj.giftSwfPath1 && obj.giftSwfPath1 != "")
			{
				var at1:IAnimationPlay = ac.getAmd(obj.giftSwfPath1, AnimationType.ATYPE_CAC_LINE, _lineLayer);
				at1.data = obj;
				addLineData(at1);
			}
			
			
		}
		/**
		 *添加飘带
		 * @param data
		 *
		 */
		public function addLineData(data:IAnimationPlay):void
		{
			_lineLayer.addMsg(data);
		}
		
		override protected function onRemove(event:Event):void
		{
			removeLsn();
		}
		
		
		/**
		 *添加动画
		 * @param amtd
		 *
		 */
		public function addAmdData(amtds:Array):void
		{
			var count:int = amtds.length - 1;
			while (count >= 0)
			{
				_bac.addData(amtds[count]);
				count--;
			}
		}
		
		
		/**
		 * 清空所有数据和当前动画 
		 */		
		private function close2Clear():void {
			//清空已缓存的
			try{
				_cacheMsg.splice(0, _cacheMsg.length);
				_bac.stopPlay();
				_lineLayer.stop();
			}catch(e:Error){
				Debugger.log(Debugger.ERROR, "[CAC]", "香槟清楚礼物效果");
			}
		}
		
		private function run(data:Object = null):void{
			toShowData();
			Ticker.tick(SHOW_DATA_SPACE_FR,run,1,true);
		}
		
		/**
		 *抛弃部分数据； 
		 * 
		 */		
		private function clearCacheData():void{
			var count:int = 0;
			var len:int = _cacheMsg.length;
			var gdata:Object;
			var newArra:Array = [];
			for (var i:int = len; i < 0 ; i--) 
			{
				//如果大于一秒渲染数量则抛弃掉
				if(count > SHOW_AMCOUNT_LIMIT * 3){
					break;
				}
				gdata = _cacheMsg[i];
				count = int(gdata.giftCount);
				newArra[newArra.length] = gdata;
			}
			//赋值为清理数据
			_cacheMsg = newArra;
		}
		
		/**
		 *显示缓存数据<br>
		 * 每次显示的动画数量会小于_showAmCount<br>
		 * 每人次送的动画数量计算上限为66（1人送999也只计算66）
		 */		
		private function toShowData():void{
			if(_cacheMsg.length <= 0) return;
			var cCount:int = 0;
			var len:int = _cacheMsg.length;
			var gdata:Object;
			var showdatas:Array = [];
			//是否超出本次显示数量
			if(_cacheMsg.length > SHOW_AMCOUNT_LIMIT){
				cCount = SHOW_AMCOUNT_LIMIT;
			}else{
				cCount = _cacheMsg.length;
			}
			showdatas = _cacheMsg.splice(0,cCount);
			//显示
			addAmdData(showdatas);
		}
		
		/**
		 *添加到缓存 
		 * 
		 */		
		private function addCacheData(datas:Array):void{
			_cacheMsg = _cacheMsg.concat(datas);
		}
		
	}
}
