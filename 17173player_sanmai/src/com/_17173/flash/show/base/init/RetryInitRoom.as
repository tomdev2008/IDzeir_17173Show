package com._17173.flash.show.base.init
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SError;
	import com._17173.flash.show.model.SEvents;

	import flash.net.URLVariables;

	public class RetryInitRoom extends InitRoom
	{
		public function RetryInitRoom()
		{
			super();
		}

		override public function enter():void
		{
			_e.send(SEvents.FW_INIT_ITEM_START, name);
			Debugger.log(Debugger.INFO, "[init]", "房间数据开始加载!");

			var roomData:URLVariables = new URLVariables();
			roomData["roomId"] = Context.variables["roomId"];
			//标记重连，防止重连聊天，服务器刷新流
			roomData["retry"] = true;
			_s.http.getData(SEnum.GET_ROOM, roomData, onRoomDataGot, onRoomDataError);
		}
		/**
		 * 房间数据加载失败回调
		 * @param data
		 *
		 */
		override protected function onRoomDataError(data:Object):void
		{
			//清除状态机后续状态
			//this._owner.cleanUp();
			Debugger.log(Debugger.INFO, "[init]", "房间数据开始失败，清空后续状态!", this._owner.currentState);
			SError.handleServerError({"code":"-000004"});
		}
	}
}