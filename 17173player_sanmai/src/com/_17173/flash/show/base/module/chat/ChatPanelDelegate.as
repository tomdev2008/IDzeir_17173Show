package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;

	/**
	 *  聊天面板delegate代理
	 * @author idzeir
	 * 创建时间：2014-2-18  下午1:34:41
	 */
	public class ChatPanelDelegate extends BaseModuleDelegate
	{

		//private var view:IChatManager;

		/**
		 * 缓存的消息
		 */
		private var _handlers:Array = [];
		/**
		 * 是否正在执行清理缓存操作
		 */
		private var isDealing:Boolean = false;

		public function ChatPanelDelegate()
		{
			super();
			this.addListeners();
		}

		private function addListeners():void
		{
			//-----------模块转的服务器业务消息
			// 用户进出
			this._e.listen(SEvents.USER_ENTER, onUserEntry);
			//this._e.listen(SEvents.USER_EXIT, onUserExit);
			//礼物消息
			this._e.listen(SEvents.NORMAL_GIFT_MESSAGE, onGiftMsg);
			//公聊状态改变
			this._e.listen(SEvents.PUBLIC_CHAT_CHANGE, onChangePublicChatStatus);
			//麦序消息
			this._e.listen(SEvents.USER_IN_MIC_LIST_SUCCESS, inMicList);
			this._e.listen(SEvents.USER_OUT_MIC_LIST_SUCCESS, outMicList);
			//开启关闭直播消息
			this._e.listen(SEvents.PUSH_VIDEO_START, onShowBegin);
			this._e.listen(SEvents.MIC_DOWN_MESSAGE, onShowFinish);
			//麦上用户变更
			this._e.listen(SEvents.UPDATE_MIC_MESSAGE, this.showUserUpdate);
			//禁言和恢复禁言
			this._e.listen(SEvents.USER_FORBID_CHAT, this.onForbidChat);
			this._e.listen(SEvents.USER_UNFORBID_CHAT, this.onUnForbidChat);
			//提升和取消管理员
			this._e.listen(SEvents.NORMAL_USER_TO_ADMIN, onUpgradeManager);
			this._e.listen(SEvents.ADMIN_TO_NORMAL_USER, onCancelManager);
			//踢人
			this._e.listen(SEvents.USER_KICK_OUT, this.onKickUser);
			//聊天面板显示错误消息
			this._e.listen(SEvents.ON_CHAT_ERROR_MESSAGE, onChatError);
			//用户升级
			this._e.listen(SEvents.USER_LEVEL_UP, onUserLevelUp);
			//开麦闭麦
			this._e.listen(SEvents.MUTE_MESSAGE, onMuteMessage);

			this._e.listen(SEvents.CHANGE_GONGGAO, onChanageGonggao);
			//添加一条聊天消息
			this._e.listen(SEvents.ADD_INFO_TO_CHAT,onAddInfoToChat);
			//大小烟花消息
			this._e.listen(SEvents.SUP_GIFT_MESSAGE,onFireworks);

			//-----------服务器socket消息
			//公聊
			_s.socket.listen(SEnum.R_CHAT_PUBLIC.action, SEnum.R_CHAT_PUBLIC.type, speakHandler);
			//公共私聊
			_s.socket.listen(SEnum.R_CHAT_PUBLIC_PRI.action, SEnum.R_CHAT_PUBLIC_PRI.type, speakHandler);
			//私聊
			_s.socket.listen(SEnum.R_CHAT_PRIVATE.action, SEnum.R_CHAT_PRIVATE.type, speakHandler);
			//聊天区公告
			_s.socket.listen(SEnum.R_CHAT_SYS_MSG.action, SEnum.R_CHAT_SYS_MSG.type, onSysMsg);
			//封ip
			_s.socket.listen(SEnum.R_KICK_IP.action, SEnum.R_KICK_IP.type,onIPKick);
			
			_s.socket.listen(SEnum.R_CHAT_LUCK.action,SEnum.R_CHAT_LUCK.type,onLucky);
			//烟花奖励
			_s.socket.listen(SEnum.R_FIREWORK_HIT.action,SEnum.R_FIREWORK_HIT.type,onFireworksHit);
		}
		
		/**
		 * 加载模块失败，清理delegate 监听
		 *
		 */
		override protected function clear():void
		{
			super.clear();
			this._handlers = null;
			//-----------模块转的服务器业务消息
			// 用户进出
			this._e.remove(SEvents.USER_ENTER, onUserEntry);
			//this._e.remove(SEvents.USER_EXIT, onUserExit);
			//礼物消息
			this._e.remove(SEvents.NORMAL_GIFT_MESSAGE, onGiftMsg);
			//公聊状态改变
			this._e.remove(SEvents.PUBLIC_CHAT_CHANGE, onChangePublicChatStatus);
			//麦序消息
			this._e.remove(SEvents.USER_IN_MIC_LIST_SUCCESS, inMicList);
			this._e.remove(SEvents.USER_OUT_MIC_LIST_SUCCESS, outMicList);
			//开启关闭直播消息
			this._e.remove(SEvents.PUSH_VIDEO_START, onShowBegin);
			this._e.remove(SEvents.MIC_DOWN_MESSAGE, onShowFinish);
			//麦上用户变更
			this._e.remove(SEvents.UPDATE_MIC_MESSAGE, this.showUserUpdate);
			//禁言和恢复禁言
			this._e.remove(SEvents.USER_FORBID_CHAT, this.onForbidChat);
			this._e.remove(SEvents.USER_UNFORBID_CHAT, this.onUnForbidChat);
			//提升和取消管理员
			this._e.remove(SEvents.NORMAL_USER_TO_ADMIN, onUpgradeManager);
			this._e.remove(SEvents.ADMIN_TO_NORMAL_USER, onCancelManager);
			//踢人
			this._e.remove(SEvents.USER_KICK_OUT, this.onKickUser);
			//聊天面板显示错误消息
			this._e.remove(SEvents.ON_CHAT_ERROR_MESSAGE, onChatError);
			//用户升级
			this._e.remove(SEvents.USER_LEVEL_UP, onUserLevelUp);
			//开麦闭麦
			this._e.remove(SEvents.MUTE_MESSAGE, onMuteMessage);

			this._e.remove(SEvents.CHANGE_GONGGAO, onChanageGonggao);
			
			this._e.remove(SEvents.ADD_INFO_TO_CHAT,onAddInfoToChat);
			//大小烟花消息
			this._e.remove(SEvents.SUP_GIFT_MESSAGE,onFireworks);
			//-----------服务器socket消息
			//公聊
			_s.socket.removeListen(SEnum.R_CHAT_PUBLIC.action, SEnum.R_CHAT_PUBLIC.type, speakHandler);
			//公共私聊
			_s.socket.removeListen(SEnum.R_CHAT_PUBLIC_PRI.action, SEnum.R_CHAT_PUBLIC_PRI.type, speakHandler);
			//私聊
			_s.socket.removeListen(SEnum.R_CHAT_PRIVATE.action, SEnum.R_CHAT_PRIVATE.type, speakHandler);
			//聊天区公告
			_s.socket.removeListen(SEnum.R_CHAT_SYS_MSG.action, SEnum.R_CHAT_SYS_MSG.type, onSysMsg);
			//封ip
			_s.socket.removeListen(SEnum.R_KICK_IP.action, SEnum.R_KICK_IP.type,onIPKick);
			
			//幸运礼物
			_s.socket.removeListen(SEnum.R_CHAT_LUCK.action,SEnum.R_CHAT_LUCK.type,onLucky);
			//烟花奖励
			_s.socket.removeListen(SEnum.R_FIREWORK_HIT.action,SEnum.R_FIREWORK_HIT.type,onFireworksHit);
		}

		override protected function onModuleLoaded():void
		{
			super.onModuleLoaded();

			this._e.listen(SEvents.USER_LIST_MOVE_COMPLETE, updatePos);
			this._e.listen(SEvents.USER_LIST_POSITION_UPDATE, updatePos);
			this._e.listen(SEvents.USER_LIST_SELECTED, onHistoryUser);
			this._e.listen(SEvents.USER_CARD_PUBLIC_CHAT_TO, onPublicChatTo);
			this._e.listen(SEvents.USER_CARD_PRIVATE_CHAT_TO, onPrivateChatTo);

			this._e.listen(SEvents.CLEAR_CHAT_MSG, onClearMsg);
			this._e.listen(SEvents.EXPAND_CHAT_PANEL, onExpand);
			this._e.listen(SEvents.LOCK_CHAT_SCROLL, onLock);
			//this._e.send(SEvents.ADD_INFO_TO_CHAT,{info:"看见个小妹恶魔",color:0x00ff00});
			this._e.send(SEvents.CHANGE_GONGGAO);
			//清楚缓存数据
			dealCache();
			
		}
		/**
		 * 清除模块加载完成之前的缓存消息
		 *
		 */
		private function dealCache():void
		{
			while(this._handlers.length > 0)
			{
				var cache:Object = this._handlers.shift();

				var handle:Function = cache._handle;
				handle.apply(null, [cache.data]);
			}
		}

		/**
		 * 验证接口
		 * @param value
		 * @return 可调用返回true否则返回false
		 *
		 */
		private function validate(value:Object):Boolean
		{
			if(!this._swf || isDealing)
			{
				this._handlers.push(value);
				return false;
			}
			return true;
		}
		
		/**
		 * 烟花效果 
		 * @param value
		 * 
		 */		
		private function onFireworksHit(value:Object):void
		{
			if(!this.validate({_handle:onFireworksHit, data:value}))
			{
				return;
			}	
			this.module.data={"onFireworksHit":[value]};
		}
		
		/**
		 * 大小烟花消息 
		 * @param value
		 * 
		 */		
		private function onFireworks(value:Object):void
		{
			if(!this.validate({_handle:onFireworks, data:value}))
			{
				return;
			}	
			this.module.data={"onFireworks":[value]};
		}
		
		/**
		 * 添一条消息到聊天面板
		 */
		private function onAddInfoToChat(value:Object):void
		{
			if(!this.validate({_handle:onAddInfoToChat, data:value}))
			{
				return;
			}	
			this.module.data={"showMsg":[value,ChatMessageType.MESSAGE_INFO]};
		}
		
		private function onLucky(value:*):void
		{
			if(!this.validate({_handle:onLucky, data:value}))
			{
				return;
			}
			this.module.data={"luckGiftback":[value]};
		}
		
		/**
		 * 封ip公告
		 */
		private function onIPKick(value:Object):void
		{
			if(!this.validate({_handle:onIPKick, data:value}))
			{
				return;
			}
			this.module.data={"showMsg":[value,ChatMessageType.IP_KICK]};
		}
		/**
		 * 公告信息展示
		 * @param value
		 *
		 */
		private function onChanageGonggao(value:*):void
		{
			if(!this.validate({_handle:onChanageGonggao, data:value}))
			{
				return;
			}
			var showData:ShowData = Context.variables["showData"] as ShowData;
			this.module.data={"showRoomNotice":[Utils.formatToString(showData.announcement.text),showData.announcement.link]};
		}
		/**
		 * 开闭麦消息
		 * @param value
		 *
		 */
		private function onMuteMessage(value:*):void
		{
			if(!this.validate({_handle:onMuteMessage, data:value}))
			{
				return;
			}
			if(Utils.validate(value,"toUser")&&Utils.validate(value,"opUser"))
			{
				//view.showMsg(value, ChatMessageType.CLOSE_MIC_SOUND);
				this.module.data = {"showMsg":[value,ChatMessageType.CLOSE_MIC_SOUND]};
			}
		}
		/**
		 * 用户升级消息
		 * @param value
		 *
		 */
		private function onUserLevelUp(value:*):void
		{
			if(!this.validate({_handle:onUserLevelUp, data:value}))
			{
				return;
			}
			if(value)
			{
				//view.showMsg(value, ChatMessageType.USER_LEVEL_UP);	
				this.module.data = {"showMsg":[value,ChatMessageType.USER_LEVEL_UP]};
			}				
		}
		/**
		 * 聊天失败消息
		 * @param value
		 *
		 */
		private function onChatError(value:String):void
		{
			if(!this.validate({_handle:onChatError, data:value}))
			{
				return;
			}
			//view.showMsg(value, ChatMessageType.ERROR);
			this.module.data = {"showMsg":[value,ChatMessageType.ERROR]};
		}
		/**
		 * 用户信息卡取消管理操作
		 * @param value
		 *
		 */
		private function onCancelManager(value:*):void
		{
			if(!this.validate({_handle:onCancelManager, data:value}))
			{
				return;
			}
			//view.showMsg({data:value, bool:false, timestamp:value["timestamp"]}, ChatMessageType.UPGRADE_USER);
			this.module.data = {"showMsg":[{data:value, bool:false, timestamp:value["timestamp"]},ChatMessageType.UPGRADE_USER]};
		}
		/**
		 * 用户信息卡提升管理员操作
		 * @param value
		 *
		 */
		private function onUpgradeManager(value:*):void
		{
			if(!this.validate({_handle:onUpgradeManager, data:value}))
			{
				return;
			}
			//view.showMsg({data:value, bool:true, timestamp:value["timestamp"]}, ChatMessageType.UPGRADE_USER);
			this.module.data = {"showMsg":[{data:value, bool:true, timestamp:value["timestamp"]},ChatMessageType.UPGRADE_USER]};
		}
		/**
		 * 麦上用户变更
		 * @param value
		 *
		 */
		private function showUserUpdate(value:*):void
		{
			if(!this.validate({_handle:showUserUpdate, data:value}))
			{
				return;
			}
			//Debugger.log(Debugger.INFO,"[ChatPanel]","showUserUpdate",JSON.stringify(value));
			//view.showMsg(value, ChatMessageType.SHOW_USER_CHANGE);
			this.module.data = {"showMsg":[value,ChatMessageType.SHOW_USER_CHANGE]};
		}

		/**
		 * 退出麦序
		 * @param value
		 *
		 */
		private function outMicList(value:IUserData):void
		{
			if(this.validate({_handle:outMicList, data:value}))
			{
				//trace(value.name,"退出麦序");
				//this.view.showMsg({data:value, bool:false}, ChatMessageType.IN_OUT_MIC_LIST);
				this.module.data = {"showMsg":[{data:value, bool:false},ChatMessageType.IN_OUT_MIC_LIST]};
			}
		}
		/**
		 * 进入麦序
		 * @param value
		 *
		 */
		private function inMicList(value:IUserData):void
		{
			if(this.validate({_handle:inMicList, data:value}))
			{
				//trace(value.name,"进入麦序");
				//this.view.showMsg({data:value, bool:true}, ChatMessageType.IN_OUT_MIC_LIST);
				this.module.data = {"showMsg":[{data:value, bool:true},ChatMessageType.IN_OUT_MIC_LIST]};
			}
		}

		/**
		 * 直播状态改变（直播结束）
		 * @param value
		 *
		 */
		private function onShowFinish(value:*):void
		{
			if(!this.validate({_handle:onShowFinish, data:value}))
			{
				return;
			}
			/*var _user:IUserData = (Context.getContext(CEnum.USER) as IUser).getUser(value.masterId);
			if(_user)
			{
				_user = (Context.getContext(CEnum.USER) as IUser).createUserFromData(value);
				//view.showMsg({data:_user, bool:false, timestamp:value["timestamp"]}, ChatMessageType.SHOW_STATUS);
				this.module.data = {"showMsg":[{data:_user, bool:false, timestamp:value["timestamp"]},ChatMessageType.SHOW_STATUS]};
			}*/
			this.module.data = {"showMsg":[{data:value, bool:false, timestamp:value["timestamp"]},ChatMessageType.SHOW_STATUS]};
		}
		/**
		 * 直播状态改变（直播开始）
		 * @param value
		 *
		 */
		private function onShowBegin(value:*):void
		{
			if(!this.validate({_handle:onShowBegin, data:value}))
			{
				return;
			}
			//var _user:IUserData = (Context.getContext(CEnum.USER) as IUser).getUser(value.masterId);
			//view.showMsg({data:_user, bool:true, timestamp:value["timestamp"]}, ChatMessageType.SHOW_STATUS);
			this.module.data = {"showMsg":[{data:value, bool:true, timestamp:value["timestamp"]}, ChatMessageType.SHOW_STATUS]}
		}
		/**
		 * 用户信息卡取消禁言
		 * @param value
		 *
		 */
		private function onUnForbidChat(value:*):void
		{
			if(!this.validate({_handle:onUnForbidChat, data:value}))
			{
				return;
			}
			//view.showMsg({data:value, bool:false, timestamp:value["timestamp"]}, ChatMessageType.FORBID_USER_CHAT);
			this.module.data = {"showMsg":[{data:value, bool:false, timestamp:value["timestamp"]}, ChatMessageType.FORBID_USER_CHAT]}
		}
		/**
		 * 用户信息卡禁言
		 * @param value
		 *
		 */
		private function onForbidChat(value:*):void
		{
			if(!this.validate({_handle:onForbidChat, data:value}))
			{
				return;
			}
			//view.showMsg({data:value, bool:true, timestamp:value["timestamp"]}, ChatMessageType.FORBID_USER_CHAT);
			this.module.data = {"showMsg":[{data:value, bool:true, timestamp:value["timestamp"]}, ChatMessageType.FORBID_USER_CHAT]}
		}
		/**
		 * 用户信息卡踢人
		 * @param value
		 *
		 */
		private function onKickUser(value:Object):void
		{
			if(!this.validate({_handle:onKickUser, data:value}))
			{
				return;
			}
			//view.showMsg(value, ChatMessageType.KICK_USER);
			this.module.data = {"showMsg":[value, ChatMessageType.KICK_USER]}
		}
		/**
		 * 开关房间公聊
		 * @param value
		 *
		 */
		private function onChangePublicChatStatus(value:*):void
		{
			//改变房间私聊状态
			//var showData:ShowData=Context.variables["showData"] as ShowData;
			var rData:Object = {userId:value.ct.userId,userName:value.ct.userName, bool:value.ct.flag,timestamp:value.timestamp};
			if(!this.validate({_handle:onChangePublicChatStatus, data:value}))
			{
				return;
			}

			//view.showMsg({data:rData, bool:rData.bool}, ChatMessageType.CHAT_PUBLIC_CHANGE);
			this.module.data = {"showMsg":[{data:rData, bool:rData.bool}, ChatMessageType.CHAT_PUBLIC_CHANGE]}
		}
		/**
		 * 用户送礼消息
		 * @param value
		 *
		 */
		private function onGiftMsg(value:*):void
		{
			if(!this.validate({_handle:onGiftMsg, data:value}))
			{
				return;
			}
			//view.showMsg(value, ChatMessageType.GIFT_INFO);
			this.module.data = {"showMsg":[value, ChatMessageType.GIFT_INFO]}
		}
		/**
		 * 系统消息
		 * @param value
		 *
		 */
		private function onSysMsg(value:Object):void
		{
			if(!this.validate({_handle:onSysMsg, data:value}))
			{
				return;
			}
			if(value)
			{
				//系统公告
				value.type = (Context.getContext(CEnum.LOCALE) as ILocale).get("msg_sys","chatPanel");;
				//view.showMsg(value, ChatMessageType.SYS_INFO);
				this.module.data = {"showMsg":[value, ChatMessageType.SYS_INFO]}
			}
		}
		/**
		 * 用户进入消息
		 * @param value
		 *
		 */
		private function onUserEntry(value:*):void
		{
			if(!this.validate({_handle:onUserEntry, data:value}))
			{
				return;
			}
			if(value.user.id&&value.user.isLogin)
			{
				//view.showMsg({data:value.user, bool:true, timestamp:value["timestamp"]}, ChatMessageType.USER_ENTRY_EXIT);
				this.module.data = {"showMsg":[{data:value.user, bool:true, timestamp:value["timestamp"]}, ChatMessageType.USER_ENTRY_EXIT]}
			}				
		}
		/**
		 * 用户退出
		 * @param value
		 *
		 */
		private function onUserExit(value:*):void
		{
			if(!this.validate({_handle:onUserExit, data:value}))
			{
				return;
			}
			if(value.user.id)
			{
				//view.showMsg({data:value.user, bool:false, timestamp:value["timestamp"]}, ChatMessageType.USER_ENTRY_EXIT);
				this.module.data = {"showMsg":[{data:value.user, bool:false, timestamp:value["timestamp"]}, ChatMessageType.USER_ENTRY_EXIT]}
			}				
		}
		/**
		 * 用户信息卡对ta私聊
		 * @param value
		 *
		 */
		private function onPrivateChatTo(value:*):void
		{
			var user:IUserData = (Context.getContext(CEnum.USER) as IUser).getUser(String(value));
			if(!this.validate({_handle:onPrivateChatTo, data:value}))
			{
				return;
			}
			//view.onPrivateChatTo(user);
			this.module.data = {"onPrivateChatTo":[user]}
		}
		/**
		 * 用户信息卡对ta说
		 * @param value
		 *
		 */
		private function onPublicChatTo(value:*):void
		{
			var user:IUserData = (Context.getContext(CEnum.USER) as IUser).getUser(String(value));
			if(!this.validate({_handle:onPublicChatTo, data:value}))
			{
				return;
			}
			//view.onPublicChatTo(user);
			this.module.data = {"onPublicChatTo":[user]}
		}
		/**
		 * 锁屏功能
		 * @param value
		 *
		 */
		private function onLock(value:* = null):void
		{
			if(!this.validate({_handle:onLock, data:value}))
			{
				return;
			}
			//view.lock();
			this.module.data = {"lock":null}
		}
		/**
		 * 展开合上功能
		 * @param value
		 *
		 */
		private function onExpand(value:* = null):void
		{
			if(!this.validate({_handle:onExpand, data:value}))
			{
				return;
			}
			//view.expand(false);
			this.module.data = {"expand":[false]}
		}
		/**
		 * 清屏功能
		 * @param value
		 *
		 */
		private function onClearMsg(value:* = null):void
		{
			if(!this.validate({_handle:onClearMsg, data:value}))
			{
				return;
			}
			//view.clearHistoryMsg();
			this.module.data = {"clearHistoryMsg":null}
		}
		/**
		 * 历史聊天对象
		 * @param data
		 *
		 */
		private function onHistoryUser(data:Object = null):void
		{
			if(!this.validate({_handle:onHistoryUser, data:data}))
			{
				return;
			}
			//view.historyUser = data;
			this.module.data = {"historyUser":[data]}
		}
		/**
		 * 用户聊天消息
		 * @param value
		 *
		 */
		private function speakHandler(value:Object):void
		{
			if(!this.validate({_handle:speakHandler, data:value}))
			{
				return;
			}
			//如果说话表面此人在房间添加到用户列表
			if(value["userInfo"])
			{
				(Context.getContext(CEnum.USER) as IUser).addUserFormSpeaker(value.userInfo);
			}
			//view.showChatMsg(value);
			this.module.data = {"showChatMsg":[value]}
		}
		/**
		 * 聊天面板跟随动画
		 * @param value
		 *
		 */
		private function updatePos(value:Object):void
		{
			if(!this.validate({_handle:updatePos, data:value}))
			{
				return;
			}
			//view.updatePos(value);
			this.module.data = {"updatePos":[value]}
		}
	}
}