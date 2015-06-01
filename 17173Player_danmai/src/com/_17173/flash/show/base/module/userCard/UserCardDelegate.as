package com._17173.flash.show.base.module.userCard
{
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	import flash.net.URLVariables;
	
	/**
	 * 用户卡片代理类.
	 *  
	 * @author shunia-17173
	 */	
	public class UserCardDelegate extends BaseModuleDelegate
	{
		
		/**
		 * 缓存的卡片数据.当模块未加载成功但是已经发出了显示卡片事件的时候有用. 
		 */		
		private var _card:Object = null;
		
		private var local:ILocale = null;
		
		public function UserCardDelegate()
		{
			super();
			local = Context.getContext(CEnum.LOCALE) as ILocale;
			
			_e.listen(SEvents.SHOW_USER_CARD, onShow);
			_e.listen(SEvents.HIDE_USER_CARD,function():void
			{
				/*if(_swf)
				{
					(_swf as IUserCard).autoHide = true;
				}*/
				if(module)
				{
					module.data = {"autoHide":[true]};
				}
			});
			_e.listen(SEvents.BOTTOM_BUTTON_CLICK,function():void
			{
				if(module)
				{
					module.data = {"onHide":null};
				}
			});
			
			//监听业务事件
			_e.listen(SEvents.USER_CARD_UPGRADE_MANAGER, onUpgradeManager);
			_e.listen(SEvents.USER_CARD_CANCEL_MANAGER, onCancelManager);
			_e.listen(SEvents.USER_CARD_FORBID_CHAT, onForbidChat);
			_e.listen(SEvents.USER_CARD_UNFORBID_CHAT, onUnforbidChat);
			_e.listen(SEvents.USER_CARD_KICK_OUT, onKickOut);
			_e.listen(SEvents.USER_CARD_BANNED, onBanned);
			_e.listen(SEvents.USER_CARD_QUIT_MIC, onQuitMic);
			_e.listen(SEvents.USER_CARD_FIRST_MIC, onFirstMic);
			_e.listen(SEvents.USER_CARD_SECOND_MIC, onSecondMic);
			_e.listen(SEvents.USER_CARD_THIRD_MIC, onThirdMic);
			_e.listen(SEvents.USER_CARD_REMOVE_MIC, onRemoveMic);
			_e.listen(SEvents.USER_CARD_OPEN_PRIVATE_CHAT_TO, openPrivateChat);
			_e.listen(SEvents.USER_CARD_FORBID_PRIVATE_CHAT_TO, forbidPrivateChat);
			
			_e.listen(SEvents.USER_KICK_OUT,onKickUserManager);
			
			_s.socket.listen(SEnum.R_UPGRADE_MANAGER.action, SEnum.R_UPGRADE_MANAGER.type, onUpdataManager);
			_s.socket.listen(SEnum.R_FORBID_CHAT.action, SEnum.R_FORBID_CHAT.type, onForbidChatManager);
			_s.socket.listen(SEnum.R_UNFORBID_CHAT.action, SEnum.R_UNFORBID_CHAT.type, onUnForbidChatManager);
			//_s.socket.listen(SEnum.R_KICK_USER.action, SEnum.R_KICK_USER.type, onKickUserManager);
		}
		
		/**
		 * socket 返回的设置/取消各种房间角色消息
		 * type：1是设置，2是取消
		 */		
		private function onUpdataManager(data:Object):void {
			var obj:Object = {};
			obj["timestamp"] = data["timestamp"];
			if (data.hasOwnProperty("ct") && data["ct"].hasOwnProperty("operatorUserInfo")) {
				obj["opUser"] = data["ct"]["operatorUserInfo"];
			} else {
				obj["opUser"] = null;
			}
			if (data.hasOwnProperty("ct") && data["ct"].hasOwnProperty("targetUserInfo")) {
				obj["toUser"] = data["ct"]["targetUserInfo"];
			} else {
				obj["toUser"] = null;
			}
			//当前操作的权限
			if (data.hasOwnProperty("ct") && data["ct"].hasOwnProperty("role")) {
				// 房主、副房主、主播(艺人)、管理员
				//OWNER(1), SUB(2), MASTER(3), ADMIN(4);
				obj["role"] = data["ct"]["role"];
			} else {
				obj["role"] = -1;
			}
			if (data.hasOwnProperty("ct") && data["ct"].hasOwnProperty("type") && obj["toUser"]) {
				var user:IUser = Context.getContext(CEnum.USER) as IUser;
				if (obj["toUser"]) {
					user.addUserFromData(obj["toUser"]);
				}
				if (data["ct"]["type"] == "1") {
					//设置权限
					_e.send(SEvents.NORMAL_USER_TO_ADMIN, obj);
				} else if (data["ct"]["type"] == "2") {
					//取消权限
					_e.send(SEvents.ADMIN_TO_NORMAL_USER, obj);
				}
			}
		}
		
		/**
		 * 禁言socket返回
		 * 派发全局事件
		 */		
		private function onForbidChatManager(data:Object):void {
			var obj:Object = {};
			obj["timestamp"]=data["timestamp"];
			obj["opUser"] = data.hasOwnProperty("userInfo") ? data["userInfo"] : null;
			obj["toUser"] = data.hasOwnProperty("toUserInfo") ? data["toUserInfo"] : null;
			_e.send(SEvents.USER_FORBID_CHAT, obj);
		}
		
		/**
		 * 接触禁言socket返回
		 * 派发全局事件
		 */	
		private function onUnForbidChatManager(data:Object):void {
			var obj:Object = {};
			obj["timestamp"]=data["timestamp"];
			obj["opUser"] = data.hasOwnProperty("userInfo") ? data["userInfo"] : null;
			obj["toUser"] = data.hasOwnProperty("toUserInfo") ? data["toUserInfo"] : null;
			_e.send(SEvents.USER_UNFORBID_CHAT, obj);
		}
		
		/**
		 * 踢人socket返回
		 * 派发全局事件
		 */	
		private function onKickUserManager(data:Object):void {
			if (data.hasOwnProperty("toUser")) {
				//如果提出的用户为当前用户，刷新浏览器
				var user:IUser = Context.getContext(CEnum.USER) as IUser;
				if (data["toUser"]["userId"] == user.me.id) {
					var alert:Alert = new Alert(local.get("tip","userCard"), local.get("tipKicked","userCard"),Alert.ICON_STATE_FAIL);
					alert.showCloseBtn = false;
					(Context.getContext(CEnum.UI) as IUIManager).popupAlertPanel(alert);
					Ticker.tick(3000, toHomePage);
				}
			}
		}
		
		/**
		 * 跳转到秀场首页
		 */		
		private function toHomePage():void {
			Ticker.stop(toHomePage);
			Util.toUrl(SEnum.domain, "_self");
		}
		
		override protected function onModuleLoaded():void {
			super.onModuleLoaded();
			
			//加载完成后确认一次
			check();
		}
		
		/**
		 * 显示卡片.
		 *  
		 * @param data
		 */		
		private function onShow(data:Object):void {
			_card = data;
			check();
		}
		
		private function check():void {
			//模块加载完成并且有数据的话,显示
			if (module && _card) {
				module.data = {"initData":[_card]};
				_card = null;
			}
		}
		
		private function onCancelSucc(data:Object):void {
			Debugger.log(Debugger.INFO, "[userCard]" + "操作请求成功");
		}
		
		private function onCancelFail(data:Object):void {
			Debugger.log(Debugger.INFO, "[userCard]"  + "操作请求失败");
		}
		
		/**
		 * 获取派发请求的参数
		 */	
		private function getV(data:Object):URLVariables {
			var v:URLVariables = new URLVariables();
			var showData:ShowData = Context.variables["showData"] as ShowData;
			v["roomId"] = showData.roomID;
			v["targetUserId"] = data as String;
			v["ip"] = Context.getContext(CEnum.USER).getUser(data).userIp;
			v["result"] = "json";
			return v;
		}
		
		/**
		 * 发送禁言请求
		 */	
		private function onForbidChat(data:Object):void {
			(Context.getContext(CEnum.UI) as IUIManager).popupAlert(local.get("tipGay","userCard"), local.get("tipGayContext","userCard"), -1, Alert.BTN_OK|Alert.BTN_CANCEL, okHandler);
			function okHandler():void {
				Debugger.log(Debugger.INFO, "[userCard]"  + "禁言：" + (data as String));
				_s.http.getData(SEnum.FORBID_CHAT, getV(data), onCancelSucc, onCancelFail);
			}
		}
		
		/**
		 * 发送解除禁言请求
		 */	
		private function onUnforbidChat(data:Object):void {
			(Context.getContext(CEnum.UI) as IUIManager).popupAlert(local.get("tipRecoveryOfSpeech","userCard"), local.get("tipRecoveryOfSpeechContext","userCard"), -1, Alert.BTN_OK|Alert.BTN_CANCEL, okHandler);
			function okHandler():void {
				Debugger.log(Debugger.INFO, "[userCard]"  + "解除禁言：" + (data as String));
				_s.http.getData(SEnum.UNFORBID_CHAT, getV(data), onCancelSucc, onCancelFail);
			}
		}
		
		/**
		 * 发送提升为管理员请求
		 */	
		private function onUpgradeManager(data:Object):void {
			(Context.getContext(CEnum.UI) as IUIManager).popupAlert(local.get("tipUpManager","userCard"), local.get("tipUpManagerContext","userCard"), -1, Alert.BTN_OK|Alert.BTN_CANCEL, okHandler);
			function okHandler():void {
				Debugger.log(Debugger.INFO, "[userCard]"  + "提升为管理员：" + (data as String));
				_s.http.getData(SEnum.UPGRADE_MANAGER, getV(data), onCancelSucc, onCancelFail);
			}
		}
		
		/**
		 * 发送撤销管理员请求
		 */	
		private function onCancelManager(data:Object):void {
			(Context.getContext(CEnum.UI) as IUIManager).popupAlert(local.get("tipCancleManager","userCard"), local.get("tipCancleManagerContext","userCard"), -1, Alert.BTN_OK|Alert.BTN_CANCEL, okHandler);
			function okHandler():void {
				Debugger.log(Debugger.INFO, "[userCard]"  + "撤销管理员：" + (data as String));
				_s.http.getData(SEnum.CANCEL_MANAGER, getV(data), onCancelSucc, onCancelFail);
			}
		}
		
		/**
		 * 发送踢人请求
		 */	
		private function onKickOut(data:Object):void {
			(Context.getContext(CEnum.UI) as IUIManager).popupAlert(local.get("tipKick","userCard"), local.get("tipKickContext","userCard"), -1, Alert.BTN_OK|Alert.BTN_CANCEL, okHandler);
			function okHandler():void {
				Debugger.log(Debugger.INFO, "[userCard]"  + "踢出用户：" + (data as String));
				_s.http.getData(SEnum.KICK_OUT, getV(data), onCancelSucc, onCancelFail);
			}
		}
		
		/**
		 *封IP 
		 * @param data
		 * 
		 */		
		private function onBanned(data:Object):void{
			(Context.getContext(CEnum.UI) as IUIManager).popupAlert(local.get("bannedIP","userCard"), local.get("bannedIPtip","userCard"), -1, Alert.BTN_OK|Alert.BTN_CANCEL, okHandler);
			function okHandler():void {
				Debugger.log(Debugger.INFO, "[userCard]"  + "封IP用户：" + (data as String));
				_s.http.getData(SEnum.BANNED_IP, getV(data), onCancelSucc, onCancelFail);
			}
		}
		
		/**
		 * 发送下麦事件
		 */	
		private function onQuitMic(data:Object):void {
			var sd:ShowData = Context.variables["showData"] as ShowData;
			var micOb:Object = sd.order;
			var micIndex:int = -1;
			for (var item:String in micOb) {
				if (micOb[item] && micOb[item]["masterId"] == (data as String)) {
					micIndex = int(item);
					break;
				}
			}
			if (micIndex != -1) {
				Debugger.log(Debugger.INFO, "[UserCard]" + "下麦" +　micIndex);
				_e.send(SEvents.MIC_DOWN, {"micIndex": micIndex});
			}
		}
		
		/**
		 * 发送上一麦事件
		 */	
		private function onFirstMic(data:Object):void {
			var order:Object = (Context.variables["showData"] as ShowData).order["1"];
			if (order) {
				(Context.getContext(CEnum.UI) as IUIManager).popupAlert(local.get("tipfirstMic","userCard"), local.get("tipfirstMicContext","userCard"), -1, Alert.BTN_OK|Alert.BTN_CANCEL, okHandler);
			} else {
				okHandler();
			}
			
			function okHandler():void {
				_e.send(SEvents.MIC_UP, {"micIndex": 1, "userId": (data as String)});
			}
		}
		
		/**
		 * 发送上二麦事件
		 */	
		private function onSecondMic(data:Object):void {
			var order:String = (Context.variables["showData"] as ShowData).order["2"];
			if (order) {
				(Context.getContext(CEnum.UI) as IUIManager).popupAlert(local.get("tipsecondMic","userCard"), local.get("tipsecondMicContext","userCard"), -1, Alert.BTN_OK|Alert.BTN_CANCEL, okHandler);
			} else {
				okHandler();
			}
			
			function okHandler():void {
				_e.send(SEvents.MIC_UP, {"micIndex": 2, "userId": (data as String)});
			}
		}
		
		/**
		 * 发送上三麦事件
		 */	
		private function onThirdMic(data:Object):void {
			var order:String = (Context.variables["showData"] as ShowData).order["3"];
			if (order) {
				(Context.getContext(CEnum.UI) as IUIManager).popupAlert(local.get("tipthirdMic","userCard"), local.get("tipthirdMicContext","userCard"), -1, Alert.BTN_OK|Alert.BTN_CANCEL, okHandler);
			} else {
				okHandler();
			}
			
			function okHandler():void {
				_e.send(SEvents.MIC_UP, {"micIndex": 3, "userId": (data as String)});
			}
		}
		
		
		private function onRemoveMic(data:Object):void {
			var order:String = (Context.variables["showData"] as ShowData).order["3"];
			if (order) {
				(Context.getContext(CEnum.UI) as IUIManager).popupAlert(local.get("tipremoveMic","userCard"), local.get("tipremoveMicContext","userCard"), -1, Alert.BTN_OK|Alert.BTN_CANCEL, okHandler);
			} else {
				okHandler();
			}
			
			function okHandler():void {
				_e.send(SEvents.MIC_DOWN_LIST, {"userId": (data as String)});
			}
		}
		
		/**
		 * 开启此人私聊
		 * 不能对自己操作
		 * @param data
		 * 
		 */		
		private function openPrivateChat(data:Object):void {
			var id:String = data as String;
			if (Util.validateStr(id)) {
				var user:IUser = Context.getContext(CEnum.USER) as IUser;
				if (user.me.id != id && Util.validateStr(user.privateChatFilterDic[id])) {
					delete user.privateChatFilterDic[id];
				}
			}
		}
		
		/**
		 * 屏蔽此人私聊
		 * 不能对自己操作
		 * @param data
		 * 
		 */		
		private function forbidPrivateChat(data:Object):void {
			var id:String = data as String;
			
			if (Util.validateStr(id)) {
				var user:IUser = Context.getContext(CEnum.USER) as IUser;
				if (user.me.id != id) {
					user.privateChatFilterDic[id] = id;
				}
			}
		}
	}
}