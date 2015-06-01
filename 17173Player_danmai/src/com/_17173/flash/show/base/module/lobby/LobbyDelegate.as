package com._17173.flash.show.base.module.lobby
{
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.base.module.guidetask.GuideManager;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	public class LobbyDelegate extends BaseModuleDelegate
	{
		//private var _view:ILobby;
		
		/**
		 * 是否正在执行清理缓存操作
		 */
		private var isDealing:Boolean = false;
		
		/**
		 * 缓存的消息
		 */
		private var _handlers:Array = [];
		
		private const ACTIVATE_TIME:uint = 20000;
		private const DEACTIVATE_TIME:uint = 60000;
		
		public function LobbyDelegate()
		{
			super();
			addListeners();
		}
		
		private function addListeners():void
		{			
			this._e.listen(SEvents.LOBBY_SWITCH,onLobbySwitch);
			this._e.listen(SEvents.BOTTOM_BUTTON_CLICK,hidenWarp);
			this._e.listen(SEvents.MIC_DOWN_MESSAGE,onVideoShowFinished);
		}
		
		private function onVideoShowFinished(value:*):void
		{
			/** 如果正在做新手引导不弹出推荐 **/
			if(GuideManager.runningGuide)return;
			if(!this.validate({_handle:onVideoShowFinished, data:value}))
			{
				loadModule();
				return;
			}
			Ticker.stop(getRoomInfo);
			if(_swf["isHiden"])
			{				
				//this._view.show();
				module.data = {"show":null};
				Ticker.tick(ACTIVATE_TIME,getRoomInfo,0);
			}
		}
		
		private function hidenWarp(value:* = null):void
		{
			if(!this.validate({_handle:hidenWarp, data:value}))
			{
				return;
			}
			if(value!=SEvents.LOBBY_SWITCH)module.data = {"hiden":null};
		}
		
		private function getRoomInfo():void
		{
			/*_s.http.postData(SEnum.G_ROOM_INFO,{liveNum:10},function(value:*):void
			{
				//trace("获取到了游戏大厅数据",JSON.stringify(value[0]["items"][0]));
				gInfo(value[0]["items"]);
			},function():void{trace("加载游戏失败");});*/	
			_s.http.getData(SEnum.V_ROOM_INFO,{num:23},function(value:*):void
			{
				//trace("获取到了娱乐大厅数据",JSON.stringify(value));
				vInfo(value);
			},function():void{trace("加载娱乐失败");});	
		}
		
		override protected function clear():void
		{
			super.clear();
			_e.remove(SEvents.LOBBY_SWITCH,onLobbySwitch);
			_e.remove(SEvents.MIC_DOWN_MESSAGE,onVideoShowFinished);
		}
		
		override protected function onModuleLoaded():void
		{
			super.onModuleLoaded();
			if(!this._swf)
			{
				return;
			}			
			//this._view = this._swf  as ILobby;	
			getRoomInfo();

			//加载成功清楚缓存的数据
			this.dealCache();			
		}		
		/**
		 * 清除模块加载完成之前的缓存消息
		 *
		 */
		private function dealCache():void
		{
			while(this._handlers.length > 0)
			{
				var cache:Object = this._handlers.shift();
				
				var handle:Function = cache._handle;
				handle.apply(null, [cache.data]);
			}
		}
		
		/**
		 * 验证接口
		 * @param value
		 * @return 可调用返回true否则返回false
		 *
		 */
		private function validate(value:Object):Boolean
		{
			if(!this._swf || isDealing)
			{
				this._handlers.push(value);
				return false;
			}
			return true;
		}
		
		private function onLobbySwitch(value:Object):void
		{
			if(!this.validate({_handle:onLobbySwitch, data:value}))
			{
				loadModule();
				return;
			}
			Ticker.stop(getRoomInfo);
			if(this._swf["isHiden"])
			{				
				//this._view.show();
				this.module.data = {"show":null};
				Ticker.tick(ACTIVATE_TIME,this.getRoomInfo,0);
			}else{				
				//this._view.hiden();
				this.module.data = {"hiden":null};
				Ticker.tick(DEACTIVATE_TIME,this.getRoomInfo,0);
			}			
		}
		
		private function gInfo(value:Object):void
		{
			if(!this.validate({_handle:gInfo, data:value}))
			{
				return;
			}
			//this._view.gInfo = value;
			this.module.data = {"gInfo":[value]};
		}
		
		private function vInfo(value:Object):void
		{
			if(!this.validate({_handle:vInfo, data:value}))
			{
				return;
			}
			//this._view.vInfo = value;
			this.module.data = {"vInfo":[value]};
		}
	}
}