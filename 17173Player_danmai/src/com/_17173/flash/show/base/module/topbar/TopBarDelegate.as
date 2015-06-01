package com._17173.flash.show.base.module.topbar
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.base.model.MessageVo;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.Event;
	
	public class TopBarDelegate extends BaseModuleDelegate
	{
		protected var cacheMsg:Array = null;
		protected var moduleLoaded:Boolean = false;
		public function TopBarDelegate()
		{
			super();
			_e.listen(SEvents.USER_COUNT_CHANGED, onUserListUpdate);
			addServerLsn();
			cacheMsg = [];
		}
		
		private function onUserListUpdate(data:Object):void {
			Context.variables["showData"].memberCount = data;
			
			_e.send(SEvents.MEMBER_COUNT_CHANGE);
		}		
		
		
		override protected function onModuleLoaded():void{
			super.onModuleLoaded();
			Context.stage.dispatchEvent(new Event(Event.RESIZE));
			moduleLoaded = true;
			var data:Object;
			var len:int = cacheMsg.length;
			for (var i:int = 0; i < len; i++) 
			{
				_e.send(SEvents.SHOW_GLOBAL_GIFT_MESSAGE,cacheMsg[i]);
			}
			cacheMsg = [];
		}
		
		private function addServerLsn():void{
			//监听用户信息改变 如头像，名字，图标
			//监听广播消息
			//监听 按钮数据信息
			_s.socket.listen(SEnum.R_GIFT_GLOBAL.action, SEnum.R_GIFT_GLOBAL.type,function(value:Object):void{
				excute(onGiftGonggao,value);});
			
			_s.socket.listen(SEnum.R_GONGGAO_MSG.action,SEnum.R_GONGGAO_MSG.type,function(value:Object):void{
				excute(onGiftGonggao,value);});
			
		}
		
		private function onGiftGonggao(data:Object):void{
			data.ct.time = data.timestamp;
			data = MessageVo.getMsgVo(data.ct);
				//转发业务消息
			_swf["addGlobalGiftMessage"](data);
			
		}
		
	}
}