package com._17173.flash.show.base.init
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.init.base.BaseInit;
	import com._17173.flash.show.model.SEvents;

	public class InitRoomStatus extends BaseInit
	{
		public function InitRoomStatus()
		{
			super();
			_name = "检测房间状态";
			_weight = 20;
		}

		override public function enter():void
		{
			super.enter();
			var showData:Object = Context.variables["showData"];
			if(showData)
			{
				if(showData.limit == 0 || showData.limit == 5)
				{
					complete();
				}
				else
				{
					Debugger.log(Debugger.INFO, "[init]", "弹出房间权限面板");

					_e.send(SEvents.ENTER_ROOM_MESSAGE);
					_e.listen(SEvents.ENTER_ROOM_SUCC, function(data:Object):void
						{
							complete();
						});
				}
			}
		}


	}
}