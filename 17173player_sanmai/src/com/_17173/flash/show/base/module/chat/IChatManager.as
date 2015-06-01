package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.show.base.context.user.IUserData;

	/**
	 * @author idzeir
	 * 创建时间：2014-2-19  上午10:58:30
	 */
	public interface IChatManager
	{
		/**
		 * 聊天面板展示聊天信息接口
		 * @param value
		 *
		 */
		function showChatMsg(value:* = null):void;

		/**
		 * 移动聊天面板
		 * @param value
		 *
		 */
		function updatePos(value:Object):void;

		/**
		 * 添加一个最近的聊天对象
		 * @param value
		 *
		 */
		function set historyUser(value:Object):void;

		/**
		 * 清除当前聊天窗口的聊天内容
		 *
		 */
		function clearHistoryMsg():void;

		/**
		 * 聊天面板展开关闭接口
		 *
		 */
		function expand(inner:Boolean = true):void;

		/**
		 * 滚屏开关
		 *
		 */
		function lock():void;

		/**
		 * 用户信息卡对ta公聊
		 * @param user
		 *
		 */
		function onPublicChatTo(user:IUserData):void;
		/**
		 * 用户信息卡对ta私聊
		 * @param user
		 *
		 */
		function onPrivateChatTo(user:IUserData):void;
		/**
		 * 用户进出房间消息
		 * @param user
		 * @param bool true为进入，false为出去
		 *
		 */
		//function onUserEntryExit(user:IUserData,bool:Boolean):void;
		/**
		 * 聊天区公告
		 * @param value
		 *
		 */
		//function onSysMsg(value:Object):void;
		/**
		 * 礼物消息
		 * @param value MessageVo类型
		 *
		 */
		//function onGiftMsg(value:Object):void;
		/**
		 * 公聊开启状态改变
		 * @param bool
		 *
		 */
		//function onChangePublicChatStatus(bool:Boolean):void;
		/**
		 * 管理员踢人
		 * @param value
		 *
		 */
		//function onKickUser(value:*):void;
		/**
		 * 直播开启关闭
		 * @param value 接收的事件数据
		 * @param bool 直播状态，true为开启，false为结束
		 *
		 */
		//function onShowStatus(value:*, bool:Boolean):void;

		/**
		 * 禁言和恢复用户禁言消息接口
		 * @param value 接收的事件数据
		 * @param bool 禁言状态true为禁言，false为恢复禁言
		 *
		 */
		//function onForbidChatStatus(value:*, bool:Boolean):void;
		/**
		 * 提升管理员和取消管理员
		 * @param value 接收的事件数据
		 * @param bool true为提升管理员，false为取消管理员
		 *
		 */
		//function onUserUpgradeManager(value:*, bool:Boolean):void;
		/**
		 * 聊天面板展现错误消息
		 * @param value
		 *
		 */
		//function onErrorMsg(value:String):void;

		/**
		 * 聊天面板展示消息统一接口
		 * @param value
		 * @param type
		 *
		 */
		function showMsg(value:*, type:uint = 0):void;
		
		function showRoomNotice(value:String,link:String= ""):void;
	}
}