package com._17173.flash.show.base.module.gameact
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	public class GameAct extends BaseModule
	{
		/**
		 *五分钟显示砸蛋 
		 */		
		public var showTime:int = 60 * 5;
		public function GameAct()
		{
			super();
			Ticker.tick(showTime*1000,showEgg);
//			showEgg(false)
			addlsn();
		}
		
		private var egg:LinkEgg;
		
		private function addlsn():void{
			var s:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			s.listen(SEvents.CHAT_GAME_CLICK,onChatCheck);
			s.listen(SEvents.VIDEO_LINK_CLICK,onVideoCheck);
		}
		
		private function onVideoCheck(data:Object):void
		{
			// TODO Auto Generated method stub
			if(data && data.type == "ZA_DAN"){
				Ticker.stop(showEgg);
				showEgg(true);
			}
		}
		
		private function onChatCheck(data:Object):void
		{
			// TODO Auto Generated method stub
			if(data && data.type == "chatToZadan"){
				Ticker.stop(showEgg);
				showEgg(true);
			}
		}
		
		private function showEgg(showLogin:Boolean = true):void{
			//判断是否登录
			var showdata:Object = Context.variables["showData"];
			if(showLogin){
				if(showdata.masterID !=null && int(showdata.masterID) > 0){
					
				}else{
					//打开登录
					(Context.getContext(CEnum.EVENT)as IEventManager).send(SEvents.LOGINPANEL_SHOW);
					return;
				}
			}
			if(egg == null){
				egg = new LinkEgg();
				egg.x = 1120;
				egg.y = 250;
			}
			
			if(egg.parent == null){
				this.addChild(egg);
			}
		}
	}
}