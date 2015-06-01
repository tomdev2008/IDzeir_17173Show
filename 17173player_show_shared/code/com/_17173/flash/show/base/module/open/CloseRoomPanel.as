package com._17173.flash.show.base.module.open
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.Locale;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;

	public class CloseRoomPanel extends Sprite
	{
		private var _s:IServiceProvider = null;
		
		public function CloseRoomPanel(){
			super();
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider;
		}
		
		public function popAlert():void{
			var locale:Locale = Context.getContext(CEnum.LOCALE) as Locale;
			(Context.getContext(CEnum.UI) as IUIManager).popupAlert(locale.get("closeTitle","openModule"),locale.get("closeInfo","openModule"), -1, Alert.BTN_OK|Alert.BTN_CANCEL, closeRoom);
		}
		
		private function closeRoom(e:MouseEvent = null):void{
			Debugger.log(Debugger.INFO,"[OpenModule]","发送关闭房间消息");
			var urlVa:URLVariables = new URLVariables;
			urlVa["roomId"] = Context.variables.showData.roomID;
			urlVa["result"] = "json";
			_s.http.getData(
				SEnum.domain + "/fr_switchStatus.action", urlVa, 
				onRoomResult, onRoomFault);
		}
		private function onRoomResult(data:Object):void
		{
			Debugger.log(Debugger.INFO,"[OpenModule]","关闭房间成功");
		}
		
		private function onRoomFault(data:Object):void
		{
			Debugger.log(Debugger.INFO,"[OpenModule]","关闭房间失败");
		}
	}
}