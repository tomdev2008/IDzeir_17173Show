package com._17173.flash.player.model
{
	
	public class PlayerType
	{
		
		// 格式  <S|F>_<ZHANNEI|ZHANWAI|CUSTOM|SHOUYE>
		//     S = 直播
		//	   F = 点播
		//	   ZHANNEI = 站内
		//	   ZHANWAI = 站外
		//	   CUSTOM = 企业版
		//	   SHOUYE = 首页
		
		/**
		 * 点播站内
		 */
		public static const F_ZHANEI:String = "f1";
		/**
		 * 点播站外
		 */
		public static const F_ZHANWAI:String = "f2";
		/**
		 * 直播站内
		 */
		public static const S_ZHANNEI:String = "f3";
		/**
		 * 直播站外(无用,目前没有的类型)
		 */
		public static const S_ZHANWAI:String = "f4";
		/**
		 * 直播首页播放器 
		 */		
		public static const S_SHOUYE:String = "f5";
		/**
		 * 直播站外定制 
		 */		
		public static const S_CUSTOM:String = "f6";
		/**
		 * 点播站外定制 
		 */		
		public static const F_CUSTOM:String = "f7";
		/**
		 * SEO_搜狐视频游戏
		 */		
		public static const F_SEO_VIDEO:String = "f8";
		/**
		 * SEO_搜狐游戏视频
		 */		
		public static const F_SEO_GAME:String = "f9";
		/**
		 * 广告播放器，一般用于专题页
		 */		
		public static const A_OUT:String = "f10";
		/**
		 * 直播聚合页广告播放器
		 */		
		public static const A_PAD:String = "f12";
		
	}
}