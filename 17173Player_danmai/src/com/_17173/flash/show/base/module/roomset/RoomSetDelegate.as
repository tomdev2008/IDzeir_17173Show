package com._17173.flash.show.base.module.roomset
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	public class RoomSetDelegate extends BaseModuleDelegate
	{
		private var _moduleLoaded:Boolean = false;
		private var _cacheMsg:Array = null;
		public function RoomSetDelegate()
		{
			super();
			_cacheMsg = [];
			addListener();
		}
		
		override protected function onModuleLoaded():void
		{
			super.onModuleLoaded();
			_moduleLoaded = true;
		}
		/**
		 * 添加监听器 
		 * 
		 */		
		private function addListener():void
		{
			//房间设置
			this._e.listen(SEvents.OPEN_ROOM_SET, showRoomSet);		
			_s.socket.listen(SEnum.CHANGE_PUBLIC_CHAT.action, SEnum.CHANGE_PUBLIC_CHAT.type, publicChat);
			_s.socket.listen(SEnum.CHANGE_ROOM.action, SEnum.CHANGE_ROOM.type, changeRoom);
			_s.socket.listen(SEnum.R_OFFLINEVIDEO_MSG.action, SEnum.R_OFFLINEVIDEO_MSG.type, offLineBack);
		}

		/**
		 * 打开聊天 
		 * @param data
		 * 
		 */		
		private function publicChat(data:Object):void
		{
			if(!cacheToMsg(publicChat,data)){
				var status:int = data.ct.flag;
				var showData:ShowData = Context.variables["showData"] as ShowData;
				showData.publicChat = status;
				_e.send(SEvents.PUBLIC_CHAT_CHANGE, data);
			}
			
		}
		
		/**
		 * 显示房间设置
		 *
		 */
		private function showRoomSet(data:Object):void
		{
			//判断是否已经add到舞台，否则发送事件告诉场景添加
			if(!Context.stage.contains(module as DisplayObject))
			{
				this._e.send(SEvents.REG_SCENE_POS, this._swf);
				var timer:Timer = new Timer(10);
				timer.addEventListener(TimerEvent.TIMER,function timerHandler(event:TimerEvent):void
				{
					if(Context.stage.contains(module as DisplayObject))
					{
						timer.stop();
						timer.removeEventListener(TimerEvent.TIMER,timerHandler);
						timer=null;
						module.data = {"display":[data]};
					}
				});
				timer.start();
			}else
				this.module.data = {"display":[data]};//显示模块，data数据包含坐标信息
		}
		/**
		 * 设置离线录像 
		 * @param data
		 * 
		 */		
		private function offLineBack(data:Object):void
		{			
			if(!cacheToMsg(offLineBack,data)){
				var url:String = data.ct.offline;
				//更新数据
				var showData:ShowData = Context.variables["showData"] as ShowData;
				if (showData.hasOwnProperty("underLineVideoCid") && showData.hasOwnProperty("underLineVideoCid") != "")
				{
					Debugger.log(Debugger.INFO, "[离线录像]", "更新离线录像", "地址：" + url);
					var path:String = showData["underLineVideoCid"];
					showData["underLineVideoCid"] = url;
				}
				else
				{
					Debugger.log(Debugger.INFO, "[离线录像]", "更新离线录像失败showDate没有underLineVideoCid属性", "地址：" + url);
				}
				_e.send(SEvents.CHANGE_OL_VIDEO_PATH);
			}
			
		}
		
		/**
		 * 改变房间 
		 * @param data
		 * 
		 */		
		private function changeRoom(data:Object):void
		{
			if(!cacheToMsg(changeRoom,data)){
				var obj:Object = {};
				obj.url = data.ct.url;
				_e.send(SEvents.CHANGE_ROOM, obj);
				navigateToURL(new URLRequest(obj.url), "_self");
			}
		}

		/**
		 *是否缓存 如果模块没加载完毕则自动加入缓存中
		 * @param fun 缓存回调
		 * @param data 回调数据
		 * @return 
		 * 
		 */
		private function cacheToMsg(fun:Function, data:Object):Boolean
		{
			var iscache:Boolean = !_moduleLoaded;
			if(iscache){
				_cacheMsg[_cacheMsg.length] = {back:fun,data:data};
			}
			return iscache;
		}

	}
}