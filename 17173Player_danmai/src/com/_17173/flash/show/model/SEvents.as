package com._17173.flash.show.model 
{

	public class SEvents
	{
		/**
		 * 应用初始化
		 */
		public static const APP_INIT:String="appInit";
		/**
		 * 应用初始化结束
		 */
		public static const APP_INIT_COMPLETE:String="appInitComplete";
		/**
		 * Preloader加载完成 
		 */		
		public static const PRELOADER_COMPLETE:String = "preloaderComplete";
		/**
		 *加载次要模块 
		 */		
		public static const APP_LOAD_SUBDELEGATE:String = "appLoadSubdelegate";
		/**
		 * 用户数据已获取
		 */
		public static const USER_INFO_GOT:String="userInfoGot";
		/**
		 * 显示错误
		 */
		public static const ON_ERROR:String="onShowError";
		/**
		 * 显示控制台
		 */
		public static const SHOW_CONSOLE:String="onShowConsole";
		/**
		 * 将模块注册到场景中的指定位置
		 */
		public static const REG_SCENE_POS:String="onRegScenePos";
		/**
		 * 显示登录板
		 */
		public static const LOGINPANEL_SHOW:String="showLoginpanel";
		/**
		 *隐藏登录板
		 */
		public static const LOGINPANEL_HIDE:String="hideLoginpanel";


		/**
		 * 用户排麦成功，服务器返回消息驱动
		 */
		public static const USER_IN_MIC_LIST_SUCCESS:String="userInMicListSuccess";

		/**
		 * 用户下麦成功
		 */
		public static const USER_OUT_MIC_LIST_SUCCESS:String="userOutMicListSuccess";

		/**
		 * 提管成功
		 */
		public static const ADMIN_TO_NORMAL_USER:String="adminToNormalUser";

		/**
		 * 取消管理成功
		 */
		public static const NORMAL_USER_TO_ADMIN:String="normalUserToAdmin";
		/**
		 * 用户升级 
		 */		
		public static const USER_LEVEL_UP:String = "userLevelUp";
		
		///////////////////////////////////////////////////
		//
		//                   底栏顶栏事件
		//
		///////////////////////////////////////////////////
		/**
		 *公告修改
		 */		
		public static const CHANGE_GONGGAO:String = "changeGonggao";
		
		/**
		 *更新房间人数
		 */
		public static const MEMBER_COUNT_CHANGE:String="memberCountChange";
		/**
		 *收到房间名称
		 */
		public static const ROOM_NAME:String="roomName";
		/**
		 *添加按钮到菜单栏<br>
		 * 需要随事件传入按钮，按钮为PlugButton及其子类
		 */
		public static const ADD_BOTTOM_BUTTON:String="addBottomButton";
		
		/**
		 *添加按钮到活动栏<br>
		 * 需要随事件传入按钮，按钮为PlugButton及其子类
		 */
		public static const ADD_ACTI_BUTTON:String="add_acti_button";
		
		/**
		 *插件按钮添加完成 
		 */		
		public static const PLUGBUTTON_ADDED:String = "plugbutton_added";
		/**
		 *插件按钮移除完成 
		 */	
		public static const PLUGBUTTON_REMOVED:String = "plugbutton_removed";
		/**
		 *插件按钮位置变更 
		 */		
		public static const PLUGBUTTON_CHANGE_POSTION:String = "plugbutton_change_postion";
		
		/**
		 *菜单栏按钮点击<br>
		 * 点击了菜单栏的按钮用于处理特殊事件
		 */
		public static const BOTTOM_BUTTON_CLICK:String="plugButtonClick";
		
		/**
		 *变更底栏按钮标签
		 */
		public static const CHANGE_BOTTOM_BUTTON_LABEL:String="changeBottomButtonLabel";
		/**
		 *删除底栏按钮
		 */
		public static const REMOVE_BOTTOM_BUTTON:String="removeBottomButton";
		/**
		 *变更底栏按钮 (用户数据刷新时，或者与按钮有关权限变更时派发)
		 */
		public static const CHANGE_BOTTOM_BUTTON:String="changeBottomButton";
		/**
		 *点击排麦或取消排麦，或下麦
		 */
		public static const REQUEST_MAI_CLICK:String="requestPaimai";
		/**
		 *点击开启/关闭房间礼物效果
		 */
		public static const CHANGE_ROOMGIFT_EFFECT_CLICK:String="changeRoomGiftEffect";
		/**
		 *离线录像 
		 */		
		public static const UPLOAD_OL_VIDEO_CLICK:String = "upload_ol_video";
		/**
		 *开启礼物 效果
		 */		
		public static const GIFT_EFFECT_OPEN:String = "gift_effect_open";
		
		/**
		 *关闭礼物 效果
		 */		
		public static const GIFT_EFFECT_CLOSE:String = "gift_effect_close";
		/**
		 *开启关闭公聊
		 */
		public static const CHANGE_PUBLICCHAT_CLICK:String="changePublicChat";
		/**
		 *修改名字
		 */
		public static const CHANGE_SELF_NAME:String="changeSelfName";
		/**
		 *显示全局信息
		 */
		public static const SHOW_GLOBAL_GIFT_MESSAGE:String="showGlobalMessage";
		/**
		 *喇叭消息
		 */
		public static const HORN_MESSAGE:String="horn_message";
		/**
		 *喇叭消息缓存 
		 */		
		public static const  HORN_MESSAGE_CACHE:String="horn_message_cache";
		/**
		 *转移观众(被转移)
		 */
		public static const CHANGE_ROOM:String="changeRoom";
		/**
		 *底栏按钮初始化成功 
		 */		
		public static const BOTTOM_BUTTON_CMP:String = "bottom_button_cmp";
		
		/**
		 *修改离线录像地址 
		 */		
		public static const CHANGE_OL_VIDEO_PATH:String = "change_ol_video_path";
		
		///////////////////////////////////////////////////
		//
		//                   房间设置
		//
		///////////////////////////////////////////////////
		/**
		 * 打开房间设置
		 */
		public static const OPEN_ROOM_SET:String="openRoomSet";		

		///////////////////////////////////////////////////
		//
		//                   底栏顶栏事件 END
		//
		///////////////////////////////////////////////////



		///////////////////////////////////////////////////
		//
		//                   中心礼物消息区与礼物事件
		//
		///////////////////////////////////////////////////

		/**
		 *座位消息
		 */
		public static const SEAT_MESSAGE:String="seatMessage";
		/**
		 *中心区域信息
		 */
		public static const CENTER_MESSAGE:String="centerMessage";
		/**
		 *礼物数据加载完毕
		 */
		public static const GIFT_DATA_LOAD_CMP:String="giftDataLoadCmp";
		/**
		 *普通消息
		 */
		public static const NORMAL_GIFT_MESSAGE:String="normalGiftMessage";
		
		
		/**
		 *烟花礼物消息
		 */
		public static const SUP_GIFT_MESSAGE:String="sup_gift_message";
		
		/**
		 *添加用户到 礼物赠送人列表
		 * <br>传参为 添加用户的id.
		 */
		public static const ADD_TO_GIFT_SELECT_USERS:String="addGiftSelectUsers";
		///////////////////////////////////////////////////
		//
		//                   中心礼物消息区与礼物事件 END
		//
		///////////////////////////////////////////////////


		///////////////////////////////////////////////////
		//
		//                   礼物动画
		//
		///////////////////////////////////////////////////
		/**
		 *礼物动画回显
		 */
		public static const GIFT_ANIMATION_HX:String="giftAnimationhx";
		/**
		 *礼物动画
		 */
		public static const GIFT_ANIMATION:String="giftAnimation";
		/**
		 *播放大动画
		 */
		public static const GIFT_BIG_ANIMATION:String="giftBigAnimation";
		
		/**
		 *播放进场动画
		 */
		public static const GIFT_BIG_ENTER:String="gift_big_enter";
		
		/**
		 *播放常态动画
		 */
		public static const SCENE_EFFECT:String="gift_scene_effect";
		
		/**
		 *播放跑道动画
		 */
		public static const GIFT_CAR_RUNWAY:String="giftCarRunway";
		
		/**
		 *小花动画 
		 */		
		public static const GIFT_FLOWER_MINI:String = "giftFlowerMini";
		
		/**
		 *播放小动画
		 */
		public static const GIFT_CAC_ANIMATION:String="giftCacAnimation";
		
		/**
		 *动画播放完成
		 */
		public static const GIFT_ANIMATION_PLAY_END:String="giftAnimationPlayEnd"
		///////////////////////////////////////////////////
		//
		//                   礼物动画 END
		//
		///////////////////////////////////////////////////

		/**
		 * 开启房间成功
		 */
		public static const OPENR_ROOM_SUCC:String="OPENR_ROOM_SUCC";
		/**
		 * 开启房间失败
		 */
		public static const OPEN_ROOM_FAIL:String="OPEN_ROOM_FAIL";
		/**
		 * 开启推流失败
		 */
		public static const PUSH_GSLB_FAILED:String="PUSH_GSLB_FAILED";
		/**
		 * 开启推流成功
		 */
		public static const PUSH_GSLB_SUCCESS:String="PUSH_GSLB_SUCCESS";

		/**
		 * 开启拉流失败
		 */
		public static const LIVE_FAILED:String="LIVE_FAILED";
		/**
		 * 拉流调度成功
		 */
		public static const LIVE_SUC:String="LIVE_SUC";
		/**
		 *  链接NetStream
		 */
		public static const CONNECT_STREAM_SUCCESS:String="CONNECT_STREAM_SUCCESS";
		/**
		 *  发送pls_open失败
		 */
		public static const TO_PUSH_OPEN_FAIL:String="TO_PUSH_OPEN_FAIL";
		/**
		 *  发送pls_open成功
		 */
		public static const TO_PUSH_OPEN_SUCC:String="TO_PUSH_OPEN_SUCC";
		/**
		 *  发送pls_close 失败
		 */
		public static const TO_PUSH_CLOSE_FAIL:String="TO_PUSH_CLOSE_FAIL";
		/**
		 *  发送pls_close 成功
		 */
		public static const TO_PUSH_CLOSE_SUCC:String="TO_PUSH_CLOSE_SUCC";
		/**
		 *  拉流最优项失败
		 */
		public static const SCHEDULER_FAILED:String="SCHEDULER_FAILED";
		/**
		 *  拉流最优项成功
		 */
		public static const SCHEDULER_SUCC:String="SCHEDULER_SUCC";

		/**
		 *  Push 状态改变
		 */
		public static const PUSH_STATUS_CHANGED:String="PUSH_STATUS_CHANGED";

		/**
		 * Live Connected
		 */
		public static const LIVE_CONNECTED:String="LIVE_CONNECTED";
		/**
		 * Live Disconnected
		 */
		public static const LIVE_DISCONNECTED:String="LIVE_DISCONNECTED";

		/**
		 * 选择麦克风
		 */
		public static const MIC_SELECT:String="MIC_SELECT";
		/**
		 * 选择界面完成
		 */
		public static const SELECTPANEL_CLOSE:String="SELECTPANEL_DOWN";

		/**
		 * 选择分辨率完成
		 */
		public static const QUALITYPANEL_CLOSE:String="QUALITYPANEL_DOWN";


		/**
		 * 改变房间状态(点击按钮操作)
		 */
		public static const CHANGE_ROOM_STATUS_CLICK:String="CHANGE_ROOM_STATUS_MESSAGE";

		/**
		 * 申请开启摄像头(点击按钮操作)
		 */
		public static const CAMER_SHOW_CLICK:String="CAMER_SHOW_CLICK";

		/**
		 * 结束直播
		 */
		public static const CAM_CLOSE_MESSAGE:String="CAM_CLOSE_MESSAGE";

		/**
		 * 拍照
		 */
		public static const PHOTO_SHOW_MESSAGE:String="PHOTO_SHOW_MESSAGE";
		///////////////////////////////////////////////////
		//
		// 大厅事件
		//
		///////////////////////////////////////////////////
		public static const LOBBY_SWITCH:String = "lobbySwitch";
		
		///////////////////////////////////////////////////
		//
		// 新手引导以及任务
		//
		///////////////////////////////////////////////////
		/**
		 *验证用户是否是新用户 
		 */
		public static const USER_AUTH:String = "userauth";
		/**
		 * 刷新用户cooike 
		 */		
		public static const FLUSH_GUIDE_COOKIE:String = "flushguidecookie";
		
		///////////////////////////////////////////////////
		//
		// 用户列表事件
		//
		///////////////////////////////////////////////////
		/**
		 * 用户列表开关事件
		 */
		public static const OPEN_USER_LIST:String="openUserList";
		
		/**
		 * 点击跳转818
		 */
		public static const OPEN_MN_PIC:String="open_mn_pic";
		/**
		 * 用户列表移动结束事件
		 */
		public static const USER_LIST_MOVE_COMPLETE:String="userListMoveComplete";
		/**
		 * 用户列表派发的移动事件
		 */
		public static const USER_LIST_POSITION_UPDATE:String="userListPositionUpdate";

		/**
		 * 用户列表点击
		 */
		public static const USER_LIST_SELECTED:String="userListSelected";

		///////////////////////////////////////////////////
		//
		// 聊天面板事件
		//
		///////////////////////////////////////////////////
		/**
		 * 表情面板开关事件
		 */
		public static const OPEN_SMILE_PANEL:String="openSmilePanel";
		/**
		 * 关闭表情面板
		 */		
		public static const CLOSE_SMILE_PANEL:String = "closeSmilePanel";
		/**
		 * 聊天面板跳到聊天tab 
		 */		
		public static const GO_TO_CHAT_VIEW:String = "goToChatView";

		/**
		 * 聊天输入框插入标签
		 */
		public static const INSERT_SMILE_TAG:String="insertSmileTag";

		/**
		 * 清屏事件
		 */
		public static const CLEAR_CHAT_MSG:String="clearChatMsg";

		/**
		 * 展开聊天面板
		 */
		public static const EXPAND_CHAT_PANEL:String="expandChatPanel";

		/**
		 * 聊天信息滚动事件
		 */
		public static const LOCK_CHAT_SCROLL:String="lockChatScroll";

		/**
		 * 聊天面板展现错误信息
		 */
		public static const ON_CHAT_ERROR_MESSAGE:String="onChatErrorMessage";
		/**
		 * 聊天面板非激活tab出入数据
		 * 参数为传入数据的index 
		 */		
		public static const TAB_BUTTON_FLASH:String = "tabButtonFlash";
		/**
		 * 聊天失败弱提示
		 * 参数为提示内容 
		 */		
		public static const CHAT_NOTIFY:String = "chatNotify";
		
		/**
		 * 聊天面板添加一条消息
		 * 参数为{info:"",color:0xff0000}形式
		 */
		public static const ADD_INFO_TO_CHAT:String = "addInfoToChat";
		/**
		 * 展开私聊面板 
		 */		
		public static const SWITCH_PRI_CHAT:String = "switchPriChat";
		/**
		 * 未读私聊条数 
		 */		
		public static const HISTORY_TOTAL:String = "historyTotal";
		
		/**
		 * 面板大小变化
		 */		
       
		public static const CHAT_RESIZE:String = "chatResize";
		//////////////////////////
		//
		// 用户选项卡事件,所有事件参数都是当前被操作的用户id
		//
		////////////////////////////
//		/**
//		 * 送礼 
//		 * 提供的参数为被操作用户的id. 
//		 */		
//		public static const USER_CARD_SEND_GIFT:String = "userCardSendGift";
		/**
		 * 显示用户卡片
		 */
		public static const SHOW_USER_CARD:String="showUserCard";
		/**
		 * 隐藏用户卡片 
		 */		
		public static const HIDE_USER_CARD:String = "hideUserCard";
		/**
		 * 送礼
		 * 提供的参数为被操作用户的id.
		 */
		public static const USER_CARD_SEND_GIFT:String="userCardSendGift";
		/**
		 * 对Ta公开聊天
		 * 提供的参数为被操作用户的id.
		 */
		public static const USER_CARD_PUBLIC_CHAT_TO:String="userCardPublicChatTo";
		/**
		 * 对Ta发送私聊
		 * 提供的参数为被操作用户的id.
		 */
		public static const USER_CARD_PRIVATE_CHAT_TO:String="userCardPrivateChatTo";
		/**
		 * 禁止其对自己进行私聊
		 * 提供的参数为被操作用户的id.
		 */
		public static const USER_CARD_FORBID_PRIVATE_CHAT_TO:String="userCardForbidPrivateChatTo";
		/**
		 * 使其下麦
		 * 提供的参数为被操作用户的id.
		 */
		public static const USER_CARD_QUIT_MIC:String="userCardQuitMic";
		/**
		 * 使其上一麦
		 * 提供的参数为被操作用户的id.
		 */
		public static const USER_CARD_FIRST_MIC:String="userCardFirstMic";
		/**
		 * 使其上二麦
		 * 提供的参数为被操作用户的id.
		 */
		public static const USER_CARD_SECOND_MIC:String="userCardSecondMic";
		/**
		 * 使其上三麦
		 * 提供的参数为被操作用户的id.
		 */
		public static const USER_CARD_THIRD_MIC:String="userCardThirdMic";
		/**
		 * 移除麦序
		 * 提供的参数为被操作用户的id.
		 */
		public static const USER_CARD_REMOVE_MIC:String="userCardRemoveMic";
		
		/**
		 * 封用户IP
		 * 提供的参数为被操作用户的id.
		 */
		public static const USER_CARD_BANNED:String="user_card_banned";
		/**
		 * 将其踢出房间1小时
		 * 提供的参数为被操作用户的id.
		 */
		public static const USER_CARD_KICK_OUT:String="userCardKickOut";
		/**
		 * 用户被成功踢出房间之后的全局业务消息
		 * 提供参数为管理员和被操作用户信息
		 */
		public static const USER_KICK_OUT:String="userKickOut";
		/**
		 * 将其禁言5分钟
		 * 提供的参数为被操作用户的id.
		 */
		public static const USER_CARD_FORBID_CHAT:String="userCardForbidChat";
		/**
		 * 用户禁言时候转发的全局业务消息
		 * 提供操作的管理员和被操作的用户信息
		 */
		public static const USER_FORBID_CHAT:String="userForbidChat";
		/**
		 * 恢复其禁言
		 * 提供的参数为被操作用户的id.
		 */
		public static const USER_CARD_UNFORBID_CHAT:String="userCardUnforbidChat";
		/**
		 * 用户恢复禁言时候转发的全局业务消息
		 * 提供操作的管理员和被操作的用户信息
		 */
		public static const USER_UNFORBID_CHAT:String="userUnforbidChat";
		/**
		 * 将其升级为管理
		 * 提供的参数为被操作用户的id.
		 */
		public static const USER_CARD_UPGRADE_MANAGER:String="userCardUpgradeManager";
		/**
		 * 用户被提升为管理之后的全局业务消息
		 * 参数为操作的管理员和被提升的用户
		 */
		public static const USER_UPGRADE_MANAGER:String="userUpgradeManager";
		/**
		 * 取消其管理身份
		 * 提供的参数为被操作用户的id.
		 */
		public static const USER_CARD_CANCEL_MANAGER:String="userCardCancelManager";
		/**
		 * 用户被取消管理之后的全局业务消息
		 * 参数为操作的管理员和被取消的用户
		 */
		public static const USER_CANCEL_MANAGER:String="userCancelManager";
		/**
		 *用户麦的状态改变（排麦中，上麦中，或可以申请排麦）
		 */
		public static const CHANGE_VIDEO_STATUS:String="changeVideoStatus";

		///////////////////////////////////////
		//
		// 框架事件
		//
		////////////////////////////////
		/**
		 * 模块加载完成.
		 * 提供的参数为模块的名字.
		 */
		public static const FW_MODULE_LOADED:String="frameWorkModuleLoaded";
		/**
		 * MCfg.as中初始化列表中的一项开始.
		 * 提供的参数为初始化项的名字.
		 */
		public static const FW_INIT_ITEM_START:String="frameWorkInitItemStart";
		/**
		 * MCfg.as中初始化列表中的一项进度.
		 * 提供的参数为当前初始化项的数组的百分比.
		 */
		public static const FW_INIT_ITEM_PROGRESS:String="frameWorkInitItemProgress";
		/**
		 * MCfg.as中初始化列表中的一项结束.
		 * 提供的参数为当前初始化项的名字.
		 */
		public static const FW_INIT_ITEM_COMPLETE:String="frameWorkInitItemComplete";
		/**
		 * 初始化全部结束 
		 */		
		public static const FW_INIT_ALL_COMPLETE:String = "frameWorkInitAllComplete";
		/**
		 * 重连登录 
		 */		
		public static const FW_SOCKET_HANDING:String = "frameWorkSocketHanding";
		//////////////////////////
		//
		// 用户事件 
		//
		////////////////////////////
		/**
		 * 从说话用户添加用户列表
		 * 参数为iuserdata 
		 */		
		public static const USER_INIT_FROM_SPEAK:String = "userInitFromSpeak";
		/**
		 * 用户修改名字
		 * 参数为ct.userId,ct.name
		 */
		public static const USER_NAME_UPDATE:String = "userNameUpdate";
		/**
		 * 用户进入房间消息
		 */
		public static const USER_ENTER:String="userEnter";
		/**
		 * 用户退出房间消息
		 */
		public static const USER_EXIT:String="userExit";
		/**
		 * 用户列表更新
		 */
		public static const USER_LIST_UPDATE:String="userListUpdate";
		/**
		 * 更新用户列表游客数量
		 */
		public static const UPDATE_GUEST_COUNT:String="updateGuestCount";
		/**
		 * 用户数变更
		 */
		public static const USER_COUNT_CHANGED:String="userCountChanged";
		/**
		 * 用户数据变更
		 */
		public static const USER_DATA_UPDATE:String="userDataUpdate";
		/**
		 * 用户权限改变
		 */
		public static const USER_AUTH_CHANGED:String="userAuthChanged";
		/**
		 *房间公聊状态改变
		 */
		public static const PUBLIC_CHAT_CHANGE:String="publicChatChange";
		/**
		 *服务器礼物效果状态
		 */
		public static const GIFT_EFF_CHANGE:String="giftEffChange";
		/**
		 *自己设置礼物效果
		 */
		public static const GIFT_EFF_CHANGE_LOCAL:String="giftEffChangeLocal";

		/**
		 * 隐藏拍照界面
		 */
		public static const PHOTO_HIDE_MESSAGE:String="PHOTO_HIDE_MESSAGE";

		/**
		 * 改变房间状态成功
		 */
		public static const CHANGE_ROOM_STATUS:String="CHANGE_ROOM_STATUS";

		/**
		 * 申请改变房间状态
		 */
		public static const CHANGE_ROOM_STATUS_MESSAGE:String="CHANGE_ROOM_STATUS_MESSAGE";

		/**
		 * 声音改变
		 */
		public static const ON_LIVE_VOLUME_CHANGE:String="ON_LIVE_VOLUME_CHANGE";

		/**
		 * 暂停直播
		 */
		public static const LIVE_PAUSE:String="LIVE_PAUSE";

		/**
		 * 改变上麦信息
		 */
		public static const MIC_UP_MESSAGE:String="MIC_UP_MESSAGE";

		/**
		 *展示活动
		 */
		public static const ACT_SHOW:String="act_show";

		/**
		 * 弹出进入房间界面
		 */
		public static const ENTER_ROOM_MESSAGE:String="ENTER_ROOM_MESSAGE";

		/**
		 * 进入房间成功
		 */
		public static const ENTER_ROOM_SUCC:String="ENTER_ROOM_SUCC";

		/**
		 * 闭麦消息
		 */
		public static const MUTE_MESSAGE:String="MUTE_MESSAGE";

		/**
		 * 下麦消息
		 */
		public static const MIC_DOWN_MESSAGE:String="MIC_DOWN_MESSAGE";

		/**
		 *  切麦消息
		 */
		public static const CHANGE_MIC_MESSAGE:String="CHANGE_MIC_MESSAGE";
		/**
		 * 上麦
		 */
		public static const MIC_UP:String="MIC_UP";

		/**
		 * 下麦
		 */
		public static const MIC_DOWN:String="MIC_DOWN";

		/**
		 * 切麦
		 */
		public static const MIC_CHANGE:String="MIC_CHANGE";

		/**
		 * 闭麦
		 */
		public static const MIC_SOUND_CLOSE:String="MIC_SOUND_CLOSE";

		/**
		 * 开麦
		 */
		public static const MIC_SOUND_OPEN:String="MIC_SOUND_OPEN";

		/**
		 * 上麦序
		 */
		public static const MIC_UP_LIST:String="MIC_UP_LIST";

		/**
		 * 下麦序
		 */
		public static const MIC_DOWN_LIST:String="MIC_DOWN_LIST";
		
		/**
		 * 发送VideoData 
		 */		
		public static const SEND_VIDEO_DATA:String = "SEND_VIDEO_DATA";
		
		/**
		 * 触发底栏打开摄像头按钮 
		 */		
		public static const BOTTOM_CAMER_CLICK:String = "BOTTOM_CAMER_CLICK";
		
		/**
		 * 流断开 
		 */		
		public static const VIDEO_BREAK_OFF:String = "VIDEO_BREAK_OFF";
		
		/**
		 * 推流重连 
		 */		
		public static const VIDEO_RE_PUSH:String = "VIDEO_RE_PUSH";
		
		
		/**
		 * 是否显示LoadingIcon
		 */		
		public static const IS_SHOW_LOADING:String = "IS_SHOW_LOADING";
		
		public static const UPDATE_SOUND_STATUS:String = "UPDATE_SOUND_STATUS";
		
		/**
		 * 开启其对自己进行私聊
		 * 提供的参数为被操作用户的id.
		 */
		public static const USER_CARD_OPEN_PRIVATE_CHAT_TO:String="userCardOpenPrivateChatTo";
		
		/**
		 * 初始化CamPreview
		 */		
		public static const INIT_CAM_PREVIEW:String = "INIT_CAM_PREVIEW";
		
		/**
		 * 直播开始 
		 */		
		public static const PUSH_VIDEO_START:String = "PUSH_VIDEO_START";
		
		/**
		 * 切换插件摄像头 
		 */		
		public static const CHANGE_CAMERA:String = "CHANGE_CAMERA"; 
		
		/**
		 * 插件数据 
		 */		
		public static const PLUGIN_DATA:String = "PLUGIN_DATA";
		/**
		 * 切换分辨率 
		 */		
		public static const QUALITY_CHANGE:String = "QUALITY_CHANGE";
		/**
		 * 重连 
		 */		
		public static const LIVE_VIDEO_CONNECT:String = "LIVE_VIDEO_CONNECT";
		/**
		 * 更新麦序列表里的麦数据 
		 */		
		public static const UPDATE_MIC_DATA:String = "UPDATE_MIC_DATA";
		
		/**
		 * 发给聊天，用于显示上麦，切麦，抱麦 消息
		 */		
		public static const UPDATE_MIC_MESSAGE:String = "UPDATE_MIC_MESSAGE";
		
		/**
		 * 改变静音状态 
		 */		
		public static const CHANGE_MUTE_STATE:String = "CHANGE_MUTE_STATE";
		
		/**
		 *发送统计 
		 */		
		public static const SEND_QM:String = "SEND_QM";
		/**
		 * 重置预览状态 
		 */		
		public static const RESET_PREVIEW:String = "RESET_PREVIEW";
		
		/**
		 * 上传速率改变 
		 */		
		public static const BANDWIDTH_CHANGE:String = "BANDWIDTH_CHANGE";
		
		/**
		 * 显示时间
		 */		
		public static const SHOW_TIMER_PANEL:String = "SHOW_TIMER_PANEL";
		
		/**
		 * 显示拉流Video画面 
		 */		
		public static const SHOW_LIVE_VIDEO:String = "SHOW_LIVE_VIDEO";
		/**
		 *更改拖动 
		 */		
		public static const CHange_SCENE_DRAG:String = "CHange_SCENE_DRAG";
		/**
		 *
		 *错误记录<br>
		 *随事件信息:{code:ErrorRecordType中定义,info:{info:错误信息,name:流名,inter:接口}}
		 *
		 */		
		public static const ERROR_RECORD:String  = "error_record";
		/**
		 * bi统计 
		 */		
		public static const BI_STAT:String = "bi_stat";
		
		
		
		/*************************************/
		/**********新手任务事件**********/
		/*************************************/
		/** 显示新手任务 **/
		public static const TASK_SHOW:String = "task_show";
		/** 显示新手任务 **/
		public static const TASK_CONTINUE:String = "task_continue";
		/** 退出新手任务 **/
		public static const TASK_QUIT:String = "quit_task";
		/** 完成新手任务 **/
		public static const TASK_FINISHED:String = "task_finished";
		/** 领取奖励新手任务 **/
		public static const TASK_GOON:String = "task_goon";
		/** 领取奖励 **/
		public static const TASK_GET_REWARD:String = "task_get_reward";
		/** 改名字内容改变 **/
		public static const TASK_RENAME_TXT_CHANGE:String = "task_rename_txt_change";
		/** 点击艺人名字 **/
		public static const TASK_CHAT_CLICK_MASTER:String = "task_chat_click_master";
		/** 对艺人说话 **/
		public static const TASK_CHAT_TO_MASTER:String = "task_chat_to_master";
		/** 聊天内容改变 **/
		public static const TASK_CHAT_TXT_CHANGE:String = "task_chat_txt_change";
		/** 选择礼物 **/
		public static const TASK_GIFT_CHOSE:String = "task_gift_chose";
		/** 点击用户信息 **/
		public static const USERINFO_CLICK:String = "userinfo_click";
		/** 聊天提交 **/
		//		public static const TASK_CHAT_SUCCESS:String = "task_chat_success";
		/** 关注成功 **/
		//public static const TASK_SUBS_SUCCESS:String = "task_subs_success";
		/** 改名字提交 **/
		//	public static const TASK_RENAME_SUCCESS:String = "task_rename_success";
		/** 送礼成功 **/
		//public static const TASK_GIFT_SUCCESS:String = "task_gift_success";

		/**
		 *时间任务完成 
		 */		
//		public static const TASK_TIME_COMPLETE:String = "task_time_complete";
		/*************************************/
		/************Duang    ************/
		/*************************************/	
		public static const STAGE_DUANG:String = "stage_duang";
		/*************************************/
		/************舞台小礼物    ************/
		/*************************************/		
		public static const STAGE_GIFT_SEAT_COOR:String = "stage_gift_seat_coor";
		///////////////////////////////////////////////////
		//
		//                   背包事件
		//
		///////////////////////////////////////////////////
		/**更新背包基础信息*/
		public static const BAG_GET_INFO:String = "bag_get_info";
		/**更新背包数据*/
		public static const BAG_UPDATE:String = "bag_update";
		/**购买续费*/
		public static const BAG_MALL_BUY:String = "bag_mall_buy";
		/**切换商品使用状态*/
		public static const BAG_MALL_SWITCHPROP:String = "bag_mall_switchProp";
		/**切换自动续费状态*/
		public static const BAG_MALL_SWITCHAUTORENEW:String = "bag_mall_switchautorenew";
		///////////////////////////////////////////////////
		//
		//                   游戏事件
		//
		///////////////////////////////////////////////////
		/**游戏tip显示*/
		public static const GAME_SHOW_TIPS:String = "gameShowTips";
		/**
		 *聊天区游戏点击 
		 */		
		public static const CHAT_GAME_CLICK:String = "chat_game_click";
		/**
		 *视频区右侧点击 
		 */		
		public static const VIDEO_LINK_CLICK:String = "vide_link_click";
		///////////////////////////////////////////////////
		//
		//                   飞屏事件
		//
		///////////////////////////////////////////////////
		public static const FLY_SCREEN_DATA:String = "fly_screen_data";
		
	}
}