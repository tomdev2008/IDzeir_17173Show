package com._17173.flash.show.base.module.video.base
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;

	public class LoadOtherModules
	{
		private var _e:IEventManager = null;
		private var _loadArray:Array = null;
		public function LoadOtherModules()
		{
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
		}
		
		public function start(loadArray:Array):void{
			_loadArray = loadArray;
			if(_loadArray.length <= 0){
				loadOtherModules();
			}else{
				Ticker.tick(1000 * 10, sendMessage, 1);
				_e.listen(SEvents.SHOW_LIVE_VIDEO,showLiveVideo);
			}
		}
		
		private function loadOtherModules():void{
			sendMessage();
		}
		
		private function sendMessage():void{
			Ticker.stop(sendMessage);
			_e.remove(SEvents.SHOW_LIVE_VIDEO,showLiveVideo);
			Ticker.tick(1000,load,1);
			
		}
		
		private function load():void{
			Ticker.stop(load);
			_e.send(SEvents.APP_LOAD_SUBDELEGATE);
		}
		
		private function showLiveVideo(data:Object):void{
			if(data && data.hasOwnProperty("index")){
//				if(_loadArray.indexOf(data.index)){
				for(var i:* in _loadArray){
					if(_loadArray[i] == data.index){
						_loadArray.splice(i,1);
					}
				}
					
//				}
			}
			if(_loadArray.length <= 0){
				sendMessage();
			}
		}
	}
}