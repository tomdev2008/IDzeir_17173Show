package com._17173.flash.show.base.init
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.init.base.BaseInit;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.ShowData;
	
	import flash.net.URLVariables;
	
	/**
	 * 初始化房间数据,即showData.
	 *  
	 * @author shunia-17173
	 */	
	public class InitRoom extends BaseInit
	{
		public function InitRoom()
		{
			super();
			
			_name = "房间信息";
			_weight = 20;
		}
		
		override public function enter():void {
			super.enter();
			
			Debugger.log(Debugger.INFO, "[init]", "房间数据开始加载!");
			
			var roomData:URLVariables = new URLVariables();
			roomData["roomId"] = Context.variables["roomId"];
			_s.http.getData(
				SEnum.GET_ROOM, 
				roomData, 
				onRoomDataGot, onRoomDataError);
		}
		
		/**
		 * 房间数据成功获取
		 *  
		 * @param data
		 */		
		protected function onRoomDataGot(data:Object):void {
			var showData:ShowData = null;
			if (Context.variables["showData"]) {
				showData = Context.variables["showData"];
			} else {
				showData = new ShowData();
			}
			showData.update(data);
			Context.variables["showData"] = showData;
			
			var u:IUser = IUser(Context.getContext(CEnum.USER));
			u.addUserFromData(data.userInfo);
			
			if("userId" in data.userInfo)
			Context.variables["userId"] = data.userInfo.userId;

			Debugger.log(Debugger.INFO, "[init]", "房间数据加载并解析完成!");
			
			//登录用户
			if (u.me && u.me.isLogin) {
				startRetriveUser(data.userInfo.userId);
			} else {
				complete();
			}
		}
		
		/**
		 * 获取用户数据.
		 *  
		 * @param userId
		 */		
		private function startRetriveUser(userId:String):void {
			Debugger.log(Debugger.INFO, "[init]", "用户数据开始加载!");
			//取用户数据
			_s.http.getData(
				SEnum.GET_USER, 
				null, 
				onUserDataGot, onUserDataFail);
		}
		
		/**
		 * 用户数据获取失败. 如果未登录,这里也是获取不到用户数据的.
		 *  
		 * @param err
		 */		
		private function onUserDataFail(err:Object):void {
			Debugger.log(Debugger.ERROR, "[init]", "用户数据获取失败!");
		}
		
		/**
		 * 用户数据已经获取.
		 *  
		 * @param data
		 */		
		private function onUserDataGot(data:Object):void {
			Debugger.log(Debugger.INFO, "[init]", "用户数据加载完成!");
			
			IUser(Context.getContext(CEnum.USER)).addUserFromData(data);
			
			complete();
		}
		
		/**
		 * 房间数据获取失败
		 *  
		 * @param data
		 */		
		protected function onRoomDataError(data:Object):void {
			Debugger.log(Debugger.ERROR, "[init]", "房间数据获取失败!");
		}
		
	}
}