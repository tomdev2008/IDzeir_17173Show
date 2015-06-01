package com._17173.flash.show.base.module.bottombar
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.base.model.MessageVo;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class BottomBarDelegate extends BaseModuleDelegate
	{
		private var _hornMsgs:Array = null;
		private var _moduleLoaded:Boolean = false;
		private var _cacheMsg:Array = null;

		public function BottomBarDelegate()
		{
			super();
			_hornMsgs = [];
			_cacheMsg = [];
			addLsn();
		}

		override protected function onModuleLoaded():void
		{
			super.onModuleLoaded();
			_moduleLoaded = true;
			sendCache();
		}

		private function addLsn():void
		{
//			_e.listen(SEvents.ADD_BOTTOM_BUTTON, onAddButton);
//			_e.listen(SEvents.REMOVE_BOTTOM_BUTTON, onRemoveButton);
			_s.socket.listen(SEnum.R_MIN_HORN.action, SEnum.R_MIN_HORN.type, hornBack);
			_s.socket.listen(SEnum.CHANGE_PUBLIC_CHAT.action, SEnum.CHANGE_PUBLIC_CHAT.type, publicChat);
			_s.socket.listen(SEnum.CHANGE_ROOM.action, SEnum.CHANGE_ROOM.type, changeRoom);
			_s.socket.listen(SEnum.R_HORN_MSG.action, SEnum.R_HORN_MSG.type, hornBack1);
			_s.socket.listen(SEnum.R_OFFLINEVIDEO_MSG.action, SEnum.R_OFFLINEVIDEO_MSG.type, offLineBack);
		}

		private function onAddButton(data:Object):void
		{
			//var ibutton:IButtonManager = _swf as IButtonManager;
			//ibutton.addButtons([data]);
			this.module.data = {"addButtons": [[data]]};
		}

		private function publicChat(data:Object):void
		{
			if(!cacheToMsg(publicChat,data)){
				var status:int = data.ct.flag;
				var showData:ShowData = Context.variables["showData"] as ShowData;
				showData.publicChat = status;
				_e.send(SEvents.PUBLIC_CHAT_CHANGE, data);
			}
			
		}

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
		 *小喇叭回来
		 * @param data
		 *
		 */
		private function hornBack(data:Object):void
		{
			if(!cacheToMsg(hornBack,data)){
				var msg:MessageVo = MessageVo.getMsgVo(data.ct);
				//派发广播消息（小喇叭消息）
				_e.send(SEvents.HORN_MESSAGE, msg);
			}
			
		}

		/**
		 *小喇叭缓存
		 * @param data
		 *
		 */
		private function hornBack1(data:Object):void
		{
			var msg:MessageVo = MessageVo.getMsgVo(data.ct);
			//派发广播消息（小喇叭消息）
			if (_moduleLoaded)
			{
				_e.send(SEvents.HORN_MESSAGE_CACHE, msg);
			}
			else
			{
				_hornMsgs[_hornMsgs.length] = msg
			}
		}

		/**
		 *派发缓存数据
		 *
		 */
		private function sendCache():void
		{
			var msg:Object;
			var len:int = _hornMsgs.length;
			for (var i:int = 0; i < len; i++)
			{
				msg = _hornMsgs[i];
				_e.send(SEvents.HORN_MESSAGE_CACHE, msg);
			}
			
			//所有缓存数据进行处理
			var fun:Function;
			var data:Object;
			len = _cacheMsg.length;
			for (var j:int = 0; j < len; j++) 
			{
				msg = _cacheMsg[j];
				fun = msg.back;
				data = msg.data;
				fun.apply(null,[data]);
			}
			

		}

		private function changeRoom(data:Object):void
		{
			if(!cacheToMsg(changeRoom,data)){
				var obj:Object = {};
				obj.url = data.ct.url;
				_e.send(SEvents.CHANGE_ROOM, obj);
				navigateToURL(new URLRequest(obj.url), "_self");
			}
		}

		private function onRemoveButton(data:Object):void
		{
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