package com._17173.flash.player.model
{
	public class PlayerEvents
	{
		public function PlayerEvents()
		{
		}
		
		//////////////////
		//
		// video
		//
		//////////////////
		/**
		 * A1开始
		 */
		public static const ADA1_BEGIN:String = "onAdA1Begin";
		/**
		 * 视频管理类已经准备好,可以开始播放了 
		 */		
		public static const VIDEO_READY:String = "onVideoReady";
		/**
		 * 第一个bufferful
		 */
		public static const VIDEO_FIRST_BUFFER_FUL:String = "onVideoFirstBufferful"
		/**
		 * 视频初始化 
		 */		
		public static const VIDEO_INIT:String = "onVideoInit";
		/**
		 * 视频Loading条消失
		 */
		public static const VIDEO_LOADING_GET_100:String = "onVideoLoadingGet100";
		/**
		 * 视频已经正确初始化并开始加载 
		 */		
		public static const VIDEO_LOADED:String = "onVideoLoaded";
		/**
		 * 视频开始播放(可能正在缓冲) 
		 */		
		public static const VIDEO_START:String = "onVideoStart";
		/**
		 * 视频缓冲完成 
		 */		
		public static const VIDEO_BUFFER_FULL:String = "onVideoBufferFull";
		/**
		 * 视频缓冲区没有数据了,可能是要重新开始缓冲,也有可能是播完了 
		 */		
		public static const VIDEO_BUFFER_EMPTY:String = "onVideoBufferEmpty";
		/**
		 * 数据已完成流式加载，并且剩余缓冲区被清空
		 */		
		public static const VIDEO_BUFFER_FLUSH:String = "onVideoBufferFlush";
		/**
		 * 视频暂停播放(可能还在缓冲) 
		 */		
		public static const VIDEO_PAUSE:String = "onVideoPause";
		/**
		 * 视频恢复播放(可能还在缓冲) 
		 */		
		public static const VIDEO_RESUME:String = "onVideoResume";
		/**
		 * 视频从指定点开始播放 
		 */		
		public static const VIDEO_SEEK:String = "onVideoSeek";
		/**
		 * 视频从指定点开始播放 
		 */		
		public static const VIDEO_SEEK_START:String = "onVideoSeekStart";
		/**
		 * 视频播放结束 
		 */		
		public static const VIDEO_FINISHED:String = "onVideoFinished";
		/**
		 * 视频播放中派发事件
		 */	
		public static const VIDEO_PROGRESS:String = "onVideoProgress";
		/**
		 * 视频文件/流没有找到 
		 */		
		public static const VIDEO_NOT_FOUND:String = "onVideoNotFound";
		/**
		 * 视频地址无法连接 
		 */		
		public static const VIDEO_CAN_NOT_CONNECT:String = "onVideoCanNotConnect";
		/**
		 * 视频停止播放(手动) 
		 */		
		public static const VIDEO_STOP:String = "onVideoStop";
		
		////////////////////
		//
		// business
		//
		///////////////////
		/**
		 * 获取视频调度成功
		 */		
		public static const BI_GET_VIDEO_INFO:String = "onBIGetVideoInfo";
		/**
		 * 初始化结束 
		 */		
		public static const BI_INIT_COMPLETE:String = "onBIInitComplete";
		/**
		 * 全部初始化的步骤都已经处理完毕 
		 */		
		public static const BI_READY:String = "onBIReady";
		/**
		 * 插件初始化完毕
		 */		
		public static const BI_COMPLETE:String = "onBIComplete";
		/**
		 * 播放器所有业务逻辑初始化完毕(播放器可以正式进入播放逻辑) 
		 */		
		public static const BI_PLAYER_INITED:String = "onBIPlayerInited";
		/**
		 * 用户登录 
		 */		
		public static const BI_USER_LOGIN:String = "onBIUserLogin";
		/**
		 * 前贴广告播放结束 
		 */		
		public static const BI_AD_A2_COMPLETE:String = "onBIAdComplete";
		/**
		 * 广告初始化 
		 */		
		public static const BI_AD_INIT:String = "onBIAdInit";
		/**
		 * 广告数据已获取 
		 */		
		public static const BI_AD_DATA_RETIVED:String = "obBIAdDataRetrived";
		/**
		 * 广告数据获取失败
		 */		
		public static const BI_AD_DATA_ERROR:String = "obBIAdDataRrror";
		/**
		 * 大前贴/前贴广告已经播放完毕 
		 */		
		public static const BI_AD_COMPLETE:String = "onBIAdComplete";
		/**
		 * 显示下底广告 
		 */		
		public static const BI_AD_SHOW_A4:String = "onBIShowA4";
		/**
		 * 显示挂角广告 
		 */		
		public static const BI_AD_SHOW_A5:String = "onBIShowA5";
		/**
		 * 显示广告 
		 */		
		public static const BI_AD_SHOW_A12:String = "onBIAdShowA12";
		/**
		 * 视频播放时超时,指定时间内没有加载任何数据则会派发此消息 
		 */		
		public static const BI_VIDEO_PLAY_OUT_TIME:String = "onBIVideoPlayOutTime";
		/**
		 * 重新加载视频 
		 */		
		public static const BI_RELOAD_VIDEO:String = "onBIReloadVideo";
		/**
		 * 切换视频 
		 */		
		public static const BI_SWITCH_STREAM:String = "onBISwitchStream";
		/**
		 * 切换视频 
		 */		
		public static const BI_P2P_FAIL:String = "biP2pFail";
		/**
		 *开始取广告调度 
		 */		
		public static const BI_START_LOAD_AD_INFO:String = "onBIStartLoadADInfo";
		/**
		 * 视频清晰度已切换 
		 */		
		public static const BI_VIDEO_DEF_CHANGED:String = "onBIVideoDefChanged";
		/**
		 * 站外播放器数据都已经获取到了 
		 */		
		public static const BI_OUT_PLAYER_DATA_READY:String = "onOutPlayerDataReady";
		/**
		 * 用户数更新 
		 */		
		public static const BI_USER_NUM_CHANGED:String = "onUserNumChanged";
		/**
		 *请求用户信息 
		 */		
		public static const BI_REQUEST_USERINFO:String = "biRequestUserinfo";
		/**
		 *送礼发送完成 
		 */		
		public static const BI_GIFT_SENT:String = "biGiftSent";
		/**
		 * 播放器内部从新初始化
		 */		
		public static const BI_PLAYER_SWITCH_STREAM:String = "onPlayerSwitchStream";
		/**
		 * 用户信息已经获取
		 */		
		public static const BI_USER_INFO_GETED:String = "onUserInfoGeted";
		/**
		 * 用户信息改变
		 */		
		public static const BI_USER_INFO_CHANGE:String = "onUserInfoChange";
		/**
		 * 所有视频播放之前的业务都完毕,可以开始视频正式播放
		 */		
		public static const BI_VIDEO_CAN_START:String = "onVideoCanStart";
		/**
		 * 广告播放器加载完毕
		 * 由于统计模块需要一个事件来启动，普通是BI_COMPLETE，但是使用这个事件其它组件会初始化，因此单独为广告播放器开启一个事件
		 */		
		public static const BI_ADPALYER_COMPLET:String = "onAdPlayerComplete";
		
		/////////////////////////////////
		//
		// interactive
		//
		//////////////////////////////////
		/**
		 * Skin事件 
		 */		
		public static const SKIN_EVENT:String = "skinEvent";
		/**
		 * ui resize 
		 */		
		public static const UI_RESIZE:String = "onUIResize";
		/**
		 *stage resize 
		 */		
		public static const STAGE_RESIZE:String = "stage_resize";
		/**
		 * 缩放视频 
		 */		
		public static const UI_VIDEO_RESIZE:String = "onVideoResize";
		/**
		 * 点击播放或暂停 
		 */		
		public static const UI_PLAY_OR_PAUSE:String = "onPlayOrPause";
		/**
		 * 调节音量 
		 */		
		public static const UI_VOLUME_CHANGE:String = "onVolumeChange";
		/**
		 * 是否静音 
		 */		
		public static const UI_VOLUME_MUTE:String = "onVolumeMute";
		/**
		 * 切换全屏 
		 */		
		public static const UI_TOGGLE_FULL_SCREEN:String = "onPlayerFullScreen";
		/**
		 * 调节视频画质 
		 */		
		public static const CON_QUALITY_CHANGED:String = "onQualityChanged";
		/**
		 * 调节画面比例 
		 */		
		public static const CON_ASPECTRATIO_CHANGED:String = "onVideoAspectRatioChanged";
		/**
		 * 进度改变(前进或后退) 
		 */		
		public static const CON_PROGRESS_CHANGED:String = "onProgressChanged";
		/**
		 * 步进 
		 */		
		public static const VIDEO_STEP_FORWARD:String = "onVideoStepForward";
		/**
		 * 步退 
		 */		
		public static const VIDEO_STEP_BACKWARD:String = "onVideoStepBackward";
		
		/**		 * 打开前推界面 
		 */		
		public static const UI_SHOW_FORE_RECOMMAND:String = "onShowForeRecommand";
		/**
		 * 关闭前推界面 
		 */		
		public static const UI_HIDE_FORE_RECOMMAND:String = "onHideForeRecommand";
		/**
		 * 打开后推界面 
		 */		
		public static const UI_SHOW_BACK_RECOMMAND:String = "onShowBackRecommand";
		/**
		 * 关闭后推界面
		 */
		public static const UI_HIDE_BACK_RECOMMAND:String = "onHideBackRecommand";
		/**
		 * 显示debug界面 
		 */		
		public static const UI_SHOW_VIDEO_INFO:String = "onShowConsole";
		/**
		 * 重播
		 */
		public static const REPLAY_THE_VIDEO:String = "replayTheVideo";
		/**
		 * 通过js调用，播放另一个视频
		 */
		public static const REINIT_VIDEO:String = "reInitVideo";
		/**
		 * 显示分享组件
		 */
		public static const UI_SHOW_SHARE:String = "showShare";
		/**
		 * 分享
		 */
		public static const UI_SHOW_TALK:String = "showTalk";
		/**
		 * 显示密码确认窗口
		 */
		public static const SHOW_PASS_WORD:String = "showPassWord";
		/**
		 * 关闭密码确认窗口
		 */
		public static const HIDE_PASS_WORD:String = "hidePassWord";
		
		/**
		 * 更改声音进度条状态
		 */
		public static const UI_CHANGE_VOLUME:String = "changeVolume";
		/**
		 * 更改清晰度 
		 */		
		public static const UI_CHANGE_DEFINITION:String = "changeDef";
		
		/**
		 * 外联播放器起始页面点击播放
		 */
		public static const UI_PREVIDEW_PAGE_CLOSE:String = "PreviewPageClose";
		
		/**
		 * 显示带着视频截图的起始页
		 */
		public static const UI_SHOW_PREVIDEW_PAGE:String = "showPreviewPage";
		
		/**
		 * 隐藏带着视频截图的起始页
		 */
		public static const UI_HIDE_PREVIDEW_PAGE:String = "hidePreviewPage";
		
		/**
		 *隐藏品推 
		 */		
		public static const UI_HIDE_PT:String = "hidePT";
		
		/**
		 *显示大paly按钮 
		 */		
		public static const UI_SHOW_BIG_PALY_BTN:String = "showBigPlayBtn";
		
		/**
		 *隐藏大paly按钮 
		 */	
		public static const UI_HIDE_BIG_PALY_BTN:String = "hideBigPlayBtn";
		
		/**
		 * 播放按钮点击
		 */		
		public static const UI_PALY_BTN_CLICK:String = "playBtnClick";
		/**
		 * 显示播放器下方的tooltip文字 
		 */		
		public static const UI_SHOW_TOOLTIP:String = "showTooltip";
		
		/**
		 * 开始获取点播对应直播的数据
		 */		
		public static const UI_SHOW_LIVE_REC:String = "showLiveRec";
		/**
		 * 显示loading 
		 */		
		public static const UI_SHOW_LOADING:String = "uiShowLoading";
		/**
		 * 隐藏loading 
		 */		
		public static const UI_HIDE_LOADING:String = "uiHideLoading";
		/**
		 * 播放器ui的数据解析数据获取完成
		 */		
		public static const UI_INTED:String = "uiDataInited";
		/**
		 * 播放广告的时候某些组件可以显示的事件
		 */		
		public static const UI_SPECIL_COMP_ENABLE:String = "uiSpecialCompEnable";
		/**
		 * 组件的鼠标状态改变
		 */		
		public static const UI_COMP_ENABLE_CHANGE:String = "uiCompEanbleChange";
		
		////////////////////
		//
		// error
		//
		/////////////////////
		/**
		 * 报错消息通过Debugger进行log 
		 */		
		public static const ON_PLAYER_ERROR:String = "onPlayerError";
		
		/**
		 * socekt连接错误
		 */		
		public static const SOCKET_CONNECT_ERROR:String = "socketConnectErro";
	}
}