package com._17173.flash.show.base.module.flyscreen
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	public class FlyScreenDelegate extends BaseModuleDelegate
	{
		
		public function FlyScreenDelegate()
		{
			super();
			_s.socket.listen(SEnum.FLY_SCREEN.action, SEnum.FLY_SCREEN.type, function (data:Object):void{
				excute(showFlyScreen,data.ct);
			});

		}
		
		/**
		 * 飞屏列表数据
		 * 
		 */		
		private function getFlyScreenData():void
		{
			_s.http.getData(SEnum.GET_FLY_SCREEN,null,function (data:Object):void{
				module["initObjectPool"](data);
				_e.send(SEvents.FLY_SCREEN_DATA,data);//向聊天模块发送飞屏数据初始化聊天功能面板
			});
		}
		
		override protected function onModuleLoaded():void
		{
			super.onModuleLoaded();
			//获得飞屏数据
			getFlyScreenData();
		}
		
		/**
		 * 展示飞屏效果 
		 * @param data
		 * msg: 消息内容
		  flyId: 飞屏类型
		  userId: 发送者ID
		  userName: 发送者名字
		  receiverId：接收人ID
		  receiverName：接收人名字
		  roomId：房间ID
		 * 
		 */		
		private function showFlyScreen(data:Object):void
		{
			/** 只有当前房间可以收到飞屏 **/
			if((Context.variables["showData"] as ShowData).roomID == data.roomId)
			   this.module["showFlyScreen"](data);
		}
	}
}