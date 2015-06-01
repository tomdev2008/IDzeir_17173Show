package com._17173.flash.show.base.module.topbar
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.HtmlUtil;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.module.topbar.view.TopBarUI;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	public class TopBar extends BaseModule
	{
		private var topBarUI:TopBarUI = null;
		public function TopBar()
		{
			super();
			_version = "0.0.1";
		}
		
		override protected function init():void{
			this.mouseEnabled = false;
			topBarUI = new TopBarUI();
			this.addChild(topBarUI);
			
			var showData:ShowData = Context.variables["showData"];
			updateRoomName(showData.roomName);
			updateMemberCount();
			addEvents();
		}
		
		private function addEvents():void{
			var event:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			event.listen(SEvents.MEMBER_COUNT_CHANGE,updateMemberCount);
			event.listen(SEvents.ROOM_NAME,updateRoomName);
//			event.listen(SEvents.SHOW_GLOBAL_GIFT_MESSAGE,addGlobalGiftMessage);
		}
		
		
		
		private function updateRoomName(obj:Object = null):void{
			var name:String = Context.variables["showData"].roomName;
			if(name == null){
				name = "";
			}
			
			//反转义特殊符号
			name = HtmlUtil.decodeHtml(name);
			topBarUI.updateName(name);
		}
		
		private function updateMemberCount(obj:Object = null):void{
			var count:int = Context.variables["showData"].memberCount;
			topBarUI.updateCount(count);
		}
		
//		private function addGlobalGiftMessage(msg:Object):void{
//			//拼接字符串
//			topBarUI.addGiftMessage(msg);
//		}
	}
}