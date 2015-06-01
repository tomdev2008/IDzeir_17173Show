package com._17173.flash.show.base.module.ad
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.module.ad.base.AdShowData;
	import com._17173.flash.show.base.module.ad.base.AdType;
	import com._17173.flash.show.base.module.ad.haoye.AdHaoyeParser;
	import com._17173.flash.show.base.module.ad.haoye.AdHaoyeProxy;
	import com._17173.flash.show.base.module.ad.haoye.AdPaths;
	import com._17173.flash.show.base.module.ad.ui.AdBaseShow;
	import com._17173.flash.show.base.module.ad.ui.AdShowRight;
	import com._17173.flash.show.base.module.ad.ui.AdShowRightB;
	import com._17173.flash.show.model.CEnum;
	
	import flash.events.Event;

	/**
	 *广告模块 
	 * @author zhaoqinghao
	 * 
	 */	
	public class AdModule extends BaseModule
	{
		/**
		 *好耶广告接口 
		 */		
		private var haoyeProxy:AdHaoyeProxy;
		/**
		 *数据解析 
		 */		
		private var haoyeParser:AdHaoyeParser;
		
		
		private var wait_b_cd:int = 1000 * 60 * 2
		private var waitCd:int = 2 * 1000;
		private var addatas:Object;
		private var ads:Object = {};
		public function AdModule()
		{
			super();
			haoyeProxy = new AdHaoyeProxy();
			haoyeParser = new AdHaoyeParser();
			Ticker.tick(waitCd,startup);
			(Context.getContext(CEnum.EVENT) as IEventManager).listen("ad_close_type",onRemoveAd);
			(Context.getContext(CEnum.EVENT) as IEventManager).listen("ad_a_cmp",waitBLun);
			Context.stage.addEventListener(Event.RESIZE,onStageResize);
//			test();
		}
		
		protected function onStageResize(event:Event):void
		{
			// TODO Auto-generated method stub
			rePostion();
		}
		
		private function onRemoveAd(data:Object):void
		{
			// TODO Auto Generated method stub
			removeAd(data as String);
		}
		
		private function test():void{
			this.graphics.beginFill(0xff0000,1);
			this.graphics.drawRect(0,0,100,100);
			this.graphics.endFill();
		}
		
		
		public function startup():void{
			
			haoyeProxy.resolve(onDateSucc,onError);
		}
		
		
		public function startB(data:Object = null):void{
			haoyeProxy.AD_HAOYE_PATH = AdPaths.AD_HAOYE2_PATH;
			haoyeProxy.AD_HAOYE_TEST_PATH = AdPaths.AD_HAOYE2_TEST_PATH;
			haoyeProxy.resolve(onDateSuccb,onError);
		}
		
		
		private function waitBLun(data:Object = null):void{
			Ticker.tick(wait_b_cd,startB);
		}
		
		private function onError(error:Object = null):void
		{
			// TODO Auto Generated method stub
			Debugger.log(Debugger.ERROR,"[广告数据加载错误]");
		}		
		
		private function onDateSucc(data:Object):void{
			addatas = haoyeParser.parse(data as Array);
			var tad:AdShowData = addatas[AdType.SHOW_RIGHT] as AdShowData;
			if(tad){
				showRight(tad);
			}else{
				Debugger.log(Debugger.ERROR,"[A轮广告没有加载B轮]");
				startB(null);
			}
		}
		
		
		private function showRight(data:AdShowData):void{
			var ad:AdBaseShow = new AdShowRight();
			ads[AdType.SHOW_RIGHT] = ad;
			this.addChild(ad);
			ad.data = data;
		}
		/**
		 *显示b轮 
		 * @param data
		 * 
		 */		
		private function onDateSuccb(data:Object):void{
			addatas = haoyeParser.parse(data as Array);
			var tad:AdShowData = addatas[AdType.SHOW_RIGHT_B] as AdShowData;
			if(tad){
				showRightb(tad);
			}
		}
		
		
		private function showRightb(data:AdShowData):void{
			Debugger.log(Debugger.ERROR,"[B轮广告数据返回]");
			var ad:AdBaseShow = new AdShowRightB();
			ads[AdType.SHOW_RIGHT_B] = ad;
			this.addChild(ad);
			ad.data = data;
		}
		
		
		private function rePostion():void{
			for each(var i:AdBaseShow in ads) 
			{
				i.rePostion(Context.getContext(CEnum.UI).sceneRect);
			}
		}
		/**
		 *移除广告 
		 * @param type
		 * 
		 */		
		public function removeAd(type:String):void{
			var ad:AdBaseShow = ads[type];
			if(ad){
				if(ad.parent){
					ad.parent.removeChild(ad);
				}
				delete ads[type];
			}
			
		}
	}
	
	
	
}