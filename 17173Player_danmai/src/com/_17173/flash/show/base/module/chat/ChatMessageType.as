package com._17173.flash.show.base.module.chat
{

	/**
	 * @author idzeir
	 * 创建时间：2014-3-10  下午3:28:23
	 */
	public class ChatMessageType
	{
		/**
		 * 系统消息 0
		 */
		public static const SYS_INFO:uint = 0;
		/**
		 * 礼物消息 1
		 */
		public static const GIFT_INFO:uint = 1;
		/**
		 * 管理员踢用户 2
		 */
		public static const KICK_USER:uint = 2;
		/**
		 * 管理员关闭房间公聊 3
		 */
		public static const CHAT_PUBLIC_CHANGE:uint = 3;
		/**
		 * 直播开启 4
		 */
		public static const SHOW_STATUS:uint = 4;
		/**
		 * 禁止某用户文字聊天 5
		 */
		public static const FORBID_USER_CHAT:uint = 5;
		/**
		 * 用户提管或者降管 6
		 */
		public static const UPGRADE_USER:uint = 6;
		/**
		 * 用户进出 7
		 */
		public static const USER_ENTRY_EXIT:uint = 7;
		/**
		 * 错误消息 8
		 */
		public static const ERROR:uint = 8;
		/**
		 * 用户升级 9
		 */
		public static const USER_LEVEL_UP:uint = 9;

		/**
		 * 开麦闭麦 10
		 */
		public static const CLOSE_MIC_SOUND:uint = 10;
		/**
		 * 进出麦序 11
		 */
		public static const IN_OUT_MIC_LIST:uint = 11;

		/**
		 * 直播用户变更 12
		 */
		public static const SHOW_USER_CHANGE:uint = 12;
		
		/**
		 * 封ip 13
		 */
		public static var IP_KICK:uint = 13;
		
		/**
		 * 显示消息 14
		 */
		public static var MESSAGE_INFO:uint = 14;

	}
}