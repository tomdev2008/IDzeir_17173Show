package com._17173.flash.show.base.module.topbar
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.Event;
	
	public class TopBarDelegate extends BaseModuleDelegate
	{
		public function TopBarDelegate()
		{
			super();
			_e.listen(SEvents.USER_COUNT_CHANGED, onUserListUpdate);
			
			addServerLsn();
		}
		
		private function onUserListUpdate(data:Object):void {
			Context.variables["showData"].memberCount = data;
			
			_e.send(SEvents.MEMBER_COUNT_CHANGE);
		}		
		
		
		override protected function onModuleLoaded():void{
			super.onModuleLoaded();
			Context.stage.dispatchEvent(new Event(Event.RESIZE));
		}
		
		private function addServerLsn():void{
			//监听用户信息改变 如头像，名字，图标
			//监听广播消息
			//监听 按钮数据信息
			
		}
		
	}
}