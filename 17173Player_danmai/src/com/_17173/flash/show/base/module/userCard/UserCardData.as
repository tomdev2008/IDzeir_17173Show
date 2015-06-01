package com._17173.flash.show.base.module.userCard
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.authority.AuthorityStaitc;
	import com._17173.flash.show.base.context.authority.IAuthorityData;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	/**
	 * 用户卡片的数据类.
	 *  
	 * @author shunia-17173
	 */	
	public class UserCardData implements IUserCardData
	{
		
		/**
		 * 用户选项卡的基本操作:
		 * 	赠送礼物
		 * 	对Ta公开说
		 * 	对Ta悄悄说
		 * 	屏蔽此人私聊 
		 */		
		private var BASE_ACTIONS:Array = [];
		/**
		 * 用户选项卡的管理操作.
		 */		
		private var EXPAND_ACTIONS:Array = [];
		
		/**
		 * 隐藏对麦操作相关
		 */		
		public static const HIDE_MIC_LIST:int = 1;
		
		/**
		 * 隐藏对发言操作相关
		 */		
		public static const HIDE_TALK_list:int = 2;
		
		/**
		 * 隐藏踢人相关
		 */		
		public static const HIDE_KICK_LIST:int = 3;
		
		/**
		 * 隐藏提升/移除管理相关
		 */	
		public static const HIDE_MANGER_LIST:int = 4;
		
		private var _uid:String = null;
		
		private var local:ILocale = null;
		
		/**
		 * 显示模块的列别，模块有：麦克操作、发言操作、踢人
		 */		
		private var _showListArr:Array = [];
		
		public function UserCardData(list:Array = null)
		{
			_showListArr = list;
			local = Context.getContext(CEnum.LOCALE) as ILocale;
		}
		
		private function initAction():void {
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			var userIsFilter:Boolean = Util.validateStr(user.privateChatFilterDic[uid]);
			BASE_ACTIONS = new Array();
			var a:Object = {"label":local.get("giveGift","userCard"), "event":SEvents.ADD_TO_GIFT_SELECT_USERS, "auth":[AuthorityStaitc.THING_6]};
			BASE_ACTIONS.push(a);
			a = {"label":local.get("tellHe","userCard"), "event":SEvents.USER_CARD_PUBLIC_CHAT_TO, "auth":[AuthorityStaitc.THING_40]};
			BASE_ACTIONS.push(a);
			a = {"label":local.get("shieldHe","userCard"), "event":SEvents.USER_CARD_PRIVATE_CHAT_TO, "auth":[AuthorityStaitc.THING_3]};
			BASE_ACTIONS.push(a);
			var o4:Object = null;
			if (userIsFilter) {
				//开启对其私聊
				a = {"label":local.get("openPrivateChat","userCard"), "event":SEvents.USER_CARD_OPEN_PRIVATE_CHAT_TO, "auth":[AuthorityStaitc.THING_41]};
			} else {
				//关闭对其私聊
				a = {"label":local.get("shieldPrivateChat","userCard"), "event":SEvents.USER_CARD_FORBID_PRIVATE_CHAT_TO, "auth":[AuthorityStaitc.THING_41]};
			}
//			BASE_ACTIONS.push(a);本期不用此功能
			
			EXPAND_ACTIONS = new Array();
			var o5:Object = {"label":local.get("quitMic","userCard"), "event":SEvents.USER_CARD_QUIT_MIC, "auth":[AuthorityStaitc.THING_43]};
			var o6:Object = {"label":local.get("firstMic","userCard"), "event":SEvents.USER_CARD_FIRST_MIC, "auth":[AuthorityStaitc.THING_16]};
			var o7:Object = {"label":local.get("secondMic","userCard"), "event":SEvents.USER_CARD_SECOND_MIC, "auth":[AuthorityStaitc.THING_16]};
			var o8:Object = {"label":local.get("thirdMic","userCard"), "event":SEvents.USER_CARD_THIRD_MIC, "auth":[AuthorityStaitc.THING_16]};
			var o9:Object = {"label":local.get("kickOneHour","userCard"), "event":SEvents.USER_CARD_KICK_OUT, "auth":[AuthorityStaitc.THING_23]};
			var o10:Object = {"label":local.get("gag","userCard"), "event":SEvents.USER_CARD_FORBID_CHAT, "auth":[AuthorityStaitc.THING_24]}; 
			var o11:Object = {"label":local.get("RecoveryOfSpeech","userCard"), "event":SEvents.USER_CARD_UNFORBID_CHAT, "auth":[AuthorityStaitc.THING_25]};
			var o12:Object = {"label":local.get("upManager","userCard"), "event":SEvents.USER_CARD_UPGRADE_MANAGER, "auth":[AuthorityStaitc.THING_30]};
			var o13:Object = {"label":local.get("cancleManager","userCard"), "event":SEvents.USER_CARD_CANCEL_MANAGER, "auth":[AuthorityStaitc.THING_31]};
			var o14:Object = {"label":local.get("removeMic","userCard"), "event":SEvents.USER_CARD_REMOVE_MIC, "auth":[AuthorityStaitc.THING_39]};
			var o15:Object = {"label":local.get("bannedIP","userCard"), "event":SEvents.USER_CARD_BANNED, "auth":[AuthorityStaitc.THING_28]};
			EXPAND_ACTIONS.push(o5);
			EXPAND_ACTIONS.push(o6);
			EXPAND_ACTIONS.push(o7);
			EXPAND_ACTIONS.push(o8);
			EXPAND_ACTIONS.push(o9);
			EXPAND_ACTIONS.push(o10);
			EXPAND_ACTIONS.push(o11);
			EXPAND_ACTIONS.push(o12);
			EXPAND_ACTIONS.push(o13);
			EXPAND_ACTIONS.push(o14);
			EXPAND_ACTIONS.push(o15);
		}
		
		public function set uid(value:String):void {
			_uid = value;
			initAction();
		}
		
		public function get uid():String {
			return _uid;
		}
		
		/**
		 * 通过用户数据自动封装一个用户选项卡数据.
		 *  
		 * @param user
		 * @return 
		 */		
		public static function wrapperUser(user:IUserData, list:Array = null):IUserCardData {
			var d:UserCardData = new UserCardData(list);
			
			d.uid = user.id;
			
			return d;
		}
		
		public function get baseActions():Array
		{
			var actions:Array = [];
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			var userData:IUserData = user.getUser(_uid);
			for each (var action:Object in BASE_ACTIONS) {
				action.uid = _uid;
				if (action.auth) {
					if (validateAction(action.auth, userData)) {
						actions.push(action);
					} 
				} else {
					actions.push(action);
				}
			}
			return actions;
		}
		
		public function get expandActions():Array
		{
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			var userData:IUserData = user.getUser(_uid);
			var actions:Array = [];
			var inMic:int = user.getUserMicStatus(_uid);
			var micIndex:int = user.getMicIndex(_uid);
			var me:IUserData = user.me;
			var hideMic:Boolean =  (_showListArr && _showListArr.indexOf(HIDE_MIC_LIST) != -1) ? true : false;
			var hideTalk:Boolean = (_showListArr && _showListArr.indexOf(HIDE_TALK_list) != -1) ? true : false;
			var hideKick:Boolean = (_showListArr && _showListArr.indexOf(HIDE_KICK_LIST) != -1) ? true : false;
			var hideManger:Boolean = (_showListArr && _showListArr.indexOf(HIDE_MANGER_LIST) != -1) ? true : false;
			Debugger.log(Debugger.INFO, "[UserCard]" + "uid:" + _uid + "   filterList:" + _showListArr + "  mic状态:" + inMic);
			for each (var action:Object in EXPAND_ACTIONS) {
				var addFlag:Boolean = true;
				if (action["event"] == SEvents.USER_CARD_QUIT_MIC) {
					//如果对应用户不在任何麦上，没有下麦操作
					if (hideMic || inMic < 2) {
						addFlag = false;
					}
				}
				if (action["event"] == SEvents.USER_CARD_FIRST_MIC) {
					//如果用户在一麦，不显示上一麦
					if (hideMic || (inMic != 0 && micIndex == 1)) {
						addFlag = false;
					}
				}
				if (action["event"] == SEvents.USER_CARD_SECOND_MIC) {
					//如果用户在二麦，不显示上二麦
					if (hideMic || (inMic != 0 && micIndex == 2)) {
						addFlag = false;
					}
				}
				if (action["event"] == SEvents.USER_CARD_THIRD_MIC) {
					//如果用户在三麦，不显示上三麦
					if (hideMic || (inMic != 0 && micIndex == 3)) {
						addFlag = false;
					}
				}
				if (action["event"] == SEvents.USER_CARD_REMOVE_MIC) {
					//用户必须是在麦序，没在麦上才能显示此项
					if (hideMic || inMic != 1) {
						addFlag = false;
					}
				}
				if (action["event"] == SEvents.USER_CARD_UPGRADE_MANAGER) {
					if (hideManger || (action.auth == AuthorityStaitc.THING_30 && userData.auth.indexOf(AuthorityStaitc.USER_5) != -1)) {
						//如果是房间管理员，就不显示提升为房管的选项卡
						addFlag = false;
					}
				}
				if (action["event"] == SEvents.USER_CARD_CANCEL_MANAGER) {
					if (hideManger || (action.auth == AuthorityStaitc.THING_31 && userData.auth.indexOf(AuthorityStaitc.USER_5) == -1)) {
						//如果是不房间管理员，就不显示隐藏房管的选项卡
						addFlag = false;
					}
				}
				if (action["event"] == SEvents.USER_CARD_FORBID_CHAT) {
					if (hideTalk) {
						addFlag = false;
					}
				}
				if (action["event"] == SEvents.USER_CARD_UNFORBID_CHAT) {
					if (hideTalk) {
						addFlag = false;
					}
				}
				if (action["event"] == SEvents.USER_CARD_KICK_OUT) {
					if (hideKick) {
						addFlag = false;
					}
				}
				//判断如果是自己则不添加
				if (action["event"] == SEvents.USER_CARD_BANNED) {
					if(me.id == userData.id){
						addFlag = false;
					}
				}
				if (addFlag && validateAction(action.auth, userData)) {
					action.uid = _uid;
					actions.push(action);
				}
			}
			
			return actions;
		}
		
		/**
		 * 验证权限.
		 *  
		 * @param auths
		 * @param target
		 * @return 
		 */		
		private function validateAction(auths:Array, target:IUserData):Boolean {
			var validated:Boolean = false;
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			for each (var auth:String in auths) {
				//拿自己和当前传入的用户进行对比,看权限是否满足
				var data:IAuthorityData = user.validateAuthorityTo(user.me, auth, target);
				if (data.can) {
					validated = true;
					break;
				}
			}
			return validated;
		}
		
		/**
		 * 获取某用户当前在麦上的状态
		 * @param user 用户信息
		 * @return 
		 * 
		 */		
		private function getMicStata(user:IUserData):String {
			var re:String = "-1";
			var sd:ShowData = Context.variables["showData"] as ShowData;
			var micOb:Object = sd.order;
			for (var item:String in micOb) {
				if (item && micOb[item] && micOb[item].hasOwnProperty("masterId") && micOb[item]["masterId"] == user.id) {
					re = item;
					break;
				}
			}
			return re;
		}
		
	}
}