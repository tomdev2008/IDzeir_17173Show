package com._17173.flash.player.module.quiz
{
	public class QuizEvents
	{
		public function QuizEvents()
		{
		}
		
		//////////////////
		//
		// ui
		//
		//////////////////
		/**
		 * 站外竞猜按钮点击
		 */
		public static const OUT_QUIZ_BUTTON_CLICK:String = "outQuizButtonClick";
		/**
		 * 显示开启竞猜界面
		 */		
		public static const QUIZ_SHOW_START_QUIZ:String = "showStartQuiz";
		/**
		 * 显示错误界面
		 */	
		public static const QUIZ_SHOW_ERROR_PANEL:String = "quizShowErrorPanel";
		/**
		 * 显示开启庄界面
		 */	
		public static const QUIZ_SHOW_START_DEALER:String = "quizShowStartDealer";
		/**
		 * 显示投注界面
		 */		
		public static const QUZI_SHOW_BET_PANEL:String = "quizShowBetPanel";
		/**
		 * 显示停庄确认页面
		 */		
		public static const QUZI_SHOW_STOP_DEALER_CONFIRM:String = "showStopDealerConfirm";
		/**
		 * 隐藏竞猜主界面
		 */		
		public static const QUIZ_HIDE_QUIZ_UI:String = "quizHideUI";
		/**
		 * 显示竞猜主界面
		 */		
		public static const QUIZ_SHOW_QUIZ_UI:String = "quizShowUI";
		/**
		 * 显示官方竞猜投注页面
		 */		
		public static const QUZI_SHOW_OFFICIAL_QUZI_PANLE:String = "quizShowOfficialQuizPanel";
		
		//////////////////
		//
		// bi
		//
		//////////////////
		/**
		 * 加载竞猜模块
		 */	
		public static const QUIZ_LOAD_MODULE:String = "quizLoadModule";
		/**
		 * 加载竞猜
		 */	
		public static const QUIZ_ADD_QUIZ:String = "quizAddQuiz";
		/**
		 * 关闭庄
		 */	
		public static const QUIZ_CLOSE_DEALER:String = "quizCloseDealer";
		/**
		 * 关闭竞猜
		 */	
		public static const QUIZ_CLOSE_QUIZ:String = "quizCloseQuiz";
		/**
		 * 当前选中竞猜改变
		 */		
		public static const QUIZ_CURRENT_SELECTE_CHANGE:String = "quizCurrentSelecteChange";
		/**
		 * 有竞猜面板在显示
		 */		
		public static const QUZI_PANEL_VISIBLE_CHANGE:String = "quizPanelVisibelChange";
		/**
		 * 某竞猜结算中
		 */		
		public static const QUZI_SETTLE_ACCOUNT:String = "quizSettleAccount";
		/**
		 * 后台推送数据
		 */		
		public static const QUZI_CHANGE_FROM_SERVICES:String = "quizChangeFromSerices";
		
		//////////////////
		//
		// data
		//
		//////////////////
		/**
		 * 添加竞猜(像后端发送数据)
		 */		
		public static const QUIZ_ADD_QUIZ_DATA:String = "addQuizData";
		/**
		 * 获取竞猜数据
		 */		
		public static const QUIZ_GET_QUIZ_DATA:String = "getQuizData";
		/**
		 * 获取竞猜成功
		 */		
		public static const QUIZ_GET_QUIZ_DATA_COMPLETE:String = "getQuizDataComplet";
		/**
		 * 获取庄数据
		 */		
		public static const QUIZ_GET_DEALER_DATA:String = "getDealerData";
		/**
		 * 关闭竞猜 数据请求
		 */	
		public static const QUIZ_CLOSE_QUIZ_DATA:String = "closeQuizData";
		/**
		 * 开庄 数据请求
		 */	
		public static const QUIZ_START_DEALER_DATA:String = "StartDealerData";
		/**
		 * 停止当前庄 数据请求
		 */		
		public static const QUIZ_BET_DATA:String = "quizBetData";
		/**
		 * 后端直接推送的竞猜数据
		 */		
		public static const QUIZ_PULL_DEALER_DATA:String = "quizPullDealerData";
		/**
		 * 后端直接推送官方竞猜数据
		 */		
		public static const QUIZ_PULL_OFFICIAL_DEALER_DATA:String = "quizPullOfficialDealerData";
		
		/**
		 * 投注官方竞猜
		 */		
		public static const QUZI_BET_OFFICIAL:String = "quizBetOfficial";
	}
}