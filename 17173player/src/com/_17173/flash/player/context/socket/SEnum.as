package com._17173.flash.player.context.socket
{
	/**
	 * 数据服务定义类
	 * 
	 * s_开头代表发送出去的消息接口
	 * r_开头代表接收的消息接口
	 *  
	 * @author shunia-17173
	 */	
	public class SEnum
	{
		
		/**
		 * 心跳 
		 */		
		public static const HEART_BEAT:Object = {"action":3, "type":0};
		/**
		 * 握手 
		 */		
		public static const S_ENTER:Object = {"action":0, "type":0};
		/**
		 * 定期同步用户数量
		 */		
		public static const R_WATCHING:Object = {"action":0, "type":11};
		/**
		 * 发送聊天 
		 */		
		public static const S_CHAT:Object = {"action":0, "type":2};
		/**
		 * 公共聊天 
		 */		
		public static const R_CHAT_PUBLIC:Object = {"action":0, "type":2};
		/**
		 * 公开的私人聊天 
		 */		
		public static const R_CHAT_PUBLIC_TO:Object = {"action":1, "type":2};
		/**
		 *断流 
		 */		
		public static const R_PLAY_END:Object = {"action":18, "type":1};
		/**
		 *开始 
		 */	
		public static const R_PLAY_START:Object = {"action":15, "type":1};
		/**
		 * 更新用户列表 
		 */		
		public static const S_USER_LIST:Object = {"action":0, "type":6};
		public static const R_USER_LIST:Object = {"action":0, "type":6};
		/**
		 * 竞猜变更 
		 */		
		public static const R_QUIZ_CHANGE:Object = {"action":71, "type":1};
		
	}
}