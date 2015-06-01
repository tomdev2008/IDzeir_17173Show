package com._17173.flash.show.model
{
	import com._17173.flash.show.base.model.SharedModel;

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
		 * 接口地址前缀
		 *  
		 * @return 
		 */		
		public static function get domain():String {
			return SharedModel.domain;
		}
		
		/**
		 * 首页链接
		 *  
		 * @return 
		 */		
		public static function get home():String {
			return SharedModel.home;
		}
		
		/**
		 *  push路径
		 */		
		public static const GSLB_PUSH_URL:String = "http://gslb.v.17173.com/show/push";
		/**
		 * live路径 
		 */
		public static const GSLB_LIVE_URL:String = "http://gslb.v.17173.com/show/live";
		
		/**
		 *注册用户 
		 */		
		public static const URL_REGISTER:String = "http://passport.17173.com/register";

		/**
		 *找回密码 
		 */		
		public static const URL_FORGET:String = "http://passport.17173.com/password/forget";
		/**
		 *充值 
		 */		
		public static const URL_MONEY:String = domain + "/l/b_paymentonline.action";
		/**
		 *兑换 
		 */		
		public static const URL_EXCHANGE:String = domain + "/l/b_exchange.action";
		/**
		 *用户中心 
		 */
		public static const URL_UCENTER:String = domain + "/l/view_playLog.action";
		/**
		 *修改头像 
		 */		
		public static const URL_CHANGEFACE:String = "http://my.17173.com/profile.do?TabID=face";
	
		public static const GET_ROOM:String = domain + "/fd_hole.action";
		
		/**
		 *离线录像 
		 */		
		public static const SEND_SETVIDEO:String = domain + "/pv_set.action";
		
		public static const GET_USER:String = domain + "/i_info.action";
		/**
		 *房间设置接口 
		 */		
		public static const FN_SET:String = domain +"/fn_set.action";
		/**
		 *转移观众
		 */		
		public static const SEND_MOVEUSER:String = domain +"/fr_shift.action";
		/**
		 *礼物接口 
		 */		
		public static const GET_GIFT:String = domain + "/fg_giftData.action";
		/**
		 *小喇叭 
		 */		
		public static const SEND_HORN:String = domain + "/fg_speaker.action";
		/**
		 *礼物消息 
		 */		
		public static const SEND_GIFT:String = domain + "/fg_sendGift.action";
		/**
		 * 修改名字
		 */		
		public static const RENAME:String = domain + "/i_rename.action";
		
		/**
		 * 开闭麦 
		 */		
		public static const MUTE_SOUND:String = domain+"/"+ "flh_controlSound.action";
		/**
		 * 改变公聊
		 */		
		public static const CHANGE_PUBLICCHAT:String = domain+ "/fr_publicChatSet.action";
		/**
		 * 设置房管 
		 */		
		public static const UPGRADE_MANAGER:String = domain + "/l/fm_setRoleAdmin.action";
		/**
		 * 取消房管 
		 */		
		public static const CANCEL_MANAGER:String = domain + "/l/fm_cancelRoleAdmin.action";
		/**
		 * 踢人 
		 */		
		public static const KICK_OUT:String = domain + "/fp_kick.action";
		/**
		 * 禁止聊天 
		 */		
		public static const FORBID_CHAT:String = domain + "/fp_banchat.action";
		
		/**
		 * 封IP
		 */		
		public static const BANNED_IP:String = domain + "/fp_banIp.action";
		
		/**
		 * 恢复聊天 
		 */		
		public static const UNFORBID_CHAT:String = domain + "/fp_unbanchat.action";
		
		/**
		 * 分发 
		 */		
		public static const PLS_OPEN:String = domain + "/pls_open.action";
		/**
		 * 下麦 
		 */		
		public static const MIC_DOWN:String = domain + "/pls_close.action";
		/**
		 * 上 、切麦 
		 */		
		public static const MIC_UP:String = domain + "/flh_begin.action";
		
		/**
		 * 冠名 
		 */		
		public static const FD_NAME:String = domain + "/fd_naming.action";
		
		/**
		 * 下麦序 
		 */		
		public static const MIC_INDEX_DOWN:String = domain + "/fd_removePlan.action";
		
		/**
		 *订阅管理 
		 */		
		public static const SUB_VIEW:String = domain + "/l/sub_index.action";
		
		/**
		 * 订阅 
		 */		
		public static const SUB_DO:String = domain + "/sub_sub.action";
		
		/**
		 * 订阅主播的人数 
		 */		
		public static const SUB_COUNT:String =  domain + "/sub_subInfo.action";
		
		/**
		 * 取消订阅 
		 */		
		public static const SUB_UNDO:String = domain + "/sub_unsub.action";
		
		/**
		 *查询订阅 
		 */		
		public static const SUB_SEACH:String = domain + "/sub_query.action";
		/**
		 *已读 
		 */		
		public static const SUB_READ:String = domain + "/sub_read.action";
		/**
		 *查询活动 
		 */		
		public static const ACT_TWODAY_COUNT:String = domain + "/hd_getReceiveCountByMasterId.action";
		/**
		 * 上麦序 
		 */		
		public static const MIC_INDEX_UP:String = domain + "/fd_plan.action";
		
		/**
		 * 聊天面板禁止私聊 
		 */		
		public static const USER_CLOSE_PRIVATE_CHAT:String = domain + "/i_togglePrivateChat.action";
		
		/**
		 * 获取麦上信息 
		 */		
		public static const ORDERS_INFO:String = domain + "/fd_ordersInfo.action";
		
		/**
		 * 取游戏大厅数据 
		 */		
		public static const G_ROOM_INFO:String = "http://v.17173.com/live/index/masterTagLive.action";
		/**
		 * 取娱乐大厅数据 
		 */
		public static const V_ROOM_INFO:String = /*domain + */"http://v.17173.com/show/inter_liveList.action";
		
		/**
		 * 心跳 
		 */		
		public static const HEART_BEAT:Object = {"action":3, "type":0};
		
		
		
		////////////////////////////
		//
		// 发送出去的数据接口定义
		//
		///////////////////////////
		/**
		 * 握手 
		 */		
		public static const S_ENTER:Object = {"action":0, "type":0};
		/**
		 * 请求用户列表更新 
		 */		
		public static const S_USER_LIST:Object = {"action":0, "type":6};
		
		/**
		 * 发送公共聊天信息 
		 */		
		public static const S_CHAT_PUBLIC:Object = {"action":0, "type":2};
		/**
		 * 公开的私人聊天（对谁说） 
		 */		
		public static const S_CHAT_PUBLIC_PRI:Object = {"action":1, "type":2};
		/**
		 * 悄悄话 
		 */		
		public static const S_CHAT_PRIVATE:Object = {"action":2, "type":2};
		/**
		 * 关闭私聊 
		 */		
		public static const S_CLOSE_PRIVATE_CHAT:Object = {"action":42, "type":1};
		/**
		 * 聊天区公告 
		 */		
		public static const S_CHAT_SYS_MSG:Object = {"action":24, "type":1};
		/**
		 * 设置房间管理员 
		 */		
		public static const S_UPGRADE_MANAGER:Object = {"action":13, "type":"1"};
		/**
		 * 管理员踢人 
		 */		
		public static const S_KICK_USER:Object = {"action":0, "type":4};
		
		/////////////////////////
		//
		// 返回回来的数据接口定义
		//
		///////////////////////////
		/**
		 * 握手
		 */
		public static const R_HAND:Object = {"action": 9, "type": 9};
		/**
		 * 用户进入房间 
		 */		
		public static const R_USER_ENTER:Object = {"action":0, "type":0};
		/**
		 * 用户列表更新 
		 */		
		public static const R_USER_LIST:Object = {"action":0, "type":6};
		/**
		 * 接收公共聊天信息  
		 */		
		public static const R_CHAT_PUBLIC:Object = {"action":0, "type":2};
		/**
		 * 公开的私人聊天（对谁说） 
		 */		
		public static const R_CHAT_PUBLIC_PRI:Object = {"action":1, "type":2};
		/**
		 * 悄悄话 
		 */		
		public static const R_CHAT_PRIVATE:Object = {"action":2, "type":2};
		/**
		 * 幸运礼物聊天显示
		 */
		public static const R_CHAT_LUCK:Object = {"action":69, "type":1};
		/**
		 * 关闭私聊 
		 */		
		public static const R_CLOSE_PRIVATE_CHAT:Object = {"action":42, "type":1};
		/**
		 * 聊天区公告 
		 */		
		public static const R_CHAT_SYS_MSG:Object = {"action":24, "type":1};
		/**
		 * 烟花奖励消息
		 */
		public static const R_FIREWORK_HIT:Object = {"action": 75, "type": 1};
		/**
		 * 用户退出房间 
		 */		
		public static const R_USER_EXIT:Object = {"action":1, "type":0};
		/**
		 * 管理员踢人 
		 */		
		public static const R_KICK_USER:Object = {"action":0, "type":4};
		/**
		 * 管理员封ip
		 */
		public static const R_KICK_IP:Object  = {"action":63, "type":1};
		/**
		 *用户数量变更 
		 */		
		public static const R_MEMBER_COUNT_CHANGE:Object = {"action":0, "type":11};
		/**
		 * 用户等级提升 
		 */		
		public static const R_USER_INFO_UPDATE:Object = {"action":20, "type":1};
		/**
		 * 大公告 
		 */		
		public static const R_BROADCAST:Object = {"action":212, "type":1};
		/**
		 *公告信息
		 */	
		public static const R_ROOM_GONGGAO:Object = {"action":5, "type":1};
		
		/**
		 *麦序信息
		 */	
		public static const R_GETLIVEID:Object = {"action":28, "type":1};
		
		/**
		 * 下麦序 
		 */		
		public static const R_XIAMAIXU:Object = {"action":44, "type":1};
		
		/**
		 * 断流 
		 */		
		public static const R_DUANLIU:Object = {"action":30, "type":1};
		
		/**
		 * 采集失败
		 */		
		public static const R_CAIJIFAIL:Object = {"action":34, "type":1};
		/**
		 * 结束直播
		 */	
		public static const R_ENDVIDEO:Object = {"action":18, "type":1};		
		/**
		 *开麦，闭麦
		 */	
		public static const R_SOUND_STATUS:Object = {"action":25, "type":1};
		/**
		 *开始直播
		 */	
		public static const R_STARTPUSH:Object = {"action":15, "type":1};
		/**
		 *收礼物消息 
		 */		
		public static const R_GIFT_MESSAGE:Object = {"action":3, "type":1};
		
		
		/**
		 *收礼物消息 
		 */		
		public static const R_ACT_GIFT_MESSAGE:Object = {"action":65, "type":0};
		
		/**
		 *活动数据
		 */		
		public static const R_ACT_DATA:Object = {"action":67, "type":1};
		
		/**
		 *贵重礼物信息 全局大公告 
		 */		
		public static const R_GIFT_GLOBAL:Object = {"action":12, "type":1};
		
		/**
		 *更新房间状态
		 */	
		public static const R_UPDATESTATUS:Object = {"action":43, "type":1};
		
		/**
		 * 排麦序
		 */		
		public static const R_PAIMAIXU:Object ={"action":44, "type":1};
		
		/**
		 *小喇叭 
		 */		
		public static const R_MIN_HORN:Object = {"action":31, "type":1};
		/**
		 *房间公聊改变 
		 */		
		public static const CHANGE_PUBLIC_CHAT:Object = {"action":11, "type":1};
		/**
		 *房间礼物效果改变 
		 */		
		public static const CHANGE_GIFT_EFF:Object = {"action":48, "type":1};
		/**
		 *转移观众 
		 */		
 		public static const CHANGE_ROOM:Object = {"action":19,"type":1};
		/**
		 * 设置房间管理员 
		 */		
		public static const R_UPGRADE_MANAGER:Object = {"action":13, "type":"1"};
		/**
		 * 取消房间管理员 
		 */		
		//public static const R_CANCEL_MANAGER:Object = {"action":14, "type":"1"};
		/**
		 * 禁言 
		 */		
		public static const R_FORBID_CHAT:Object = {"action":1, "type":"4"};
		/**
		 * 恢复禁言 
		 */		
		public static const R_UNFORBID_CHAT:Object = {"action":2, "type":"4"};
		/**
		 * 礼物回显
		 */		
		public static const R_GIFT_MSG:Object = {"action":333, "type":1};
		/**
		 *公告回显 
		 */		
		public static const R_GONGGAO_MSG:Object = {"action":212, "type":1};
		
		/**
		 *小喇叭回显 
		 */		
		public static const R_HORN_MSG:Object = {"action":313, "type":1};
		
		/**
		 *离线录像更新 
		 */		
		public static const R_OFFLINEVIDEO_MSG:Object = {"action":60, "type":1};
		
		/**
		 * 更新名字 
		 */		
		public static const R_RENAME:Object = {"action":61, "type":1};
		
		/**
		 * 更新订阅 
		 */		
		public static const UPDATE_DINGYUE:Object = {"action":66, "type":1};
		
		
		/**
		 * 送礼消息回显
		 */		
		public static const R_CENTER_MSG:Object = {"action":444, "type":"1"};
		/**
		 * 更新订阅 
		 */		
		public static const LUCKGIFT_MSG:Object = {"action":70, "type":1};
	}
}