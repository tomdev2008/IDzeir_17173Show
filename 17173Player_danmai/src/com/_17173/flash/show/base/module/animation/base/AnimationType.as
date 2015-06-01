package com._17173.flash.show.base.module.animation.base
{
	public class AnimationType
	{
		
		
		/***********************************************************************
		 * 
		 * 				礼物动画效果 无效果0 车类200，花100 鸡尾酒动画300 取值范围0---499
		 * 
		 **********************************************************************/
		/**
		 *普通 
		 */		
		public static const GIFT_TYPE_NORMAL:String = "0";
		/**
		 *车类动画 
		 */		
		public static const ATYPE_CAR:String = "200";
		/**
		 *花篮动画 
		 */		
		public static const ATYPE_FLOWER:String = "100";
		
		/**
		 *鸡尾酒鲜花动画(单个) 
		 */		
		public static const ATYPE_CAC:String = "300";
		
		/**
		 *鸡尾酒鲜花动画(飘带) 
		 */		
		public static const ATYPE_CAC_LINE:String = "300_line";
		/**
		 *小车动画 
		 */		
		public static const ATYPE_CAR_MINI:String = "200_mini";
		/**
		 *小花篮动画 
		 */		
		public static const ATYPE_FLOWER_MINI:String = "100_mini";
		
		/**
		 *显示名称的动画 
		 */		
		public static const ATYPE_SHOWNAME:String = "400"
		
		
		/***********************************************************************
		 * 
		 * 				活动动画效果  500 - 899
		 * 
		 **********************************************************************/
		/**
		 *教师节动画 
		 */		
		public static const ATYPE_TECH:String = "510";
		/**
		 *八月十五兔子动画 
		 */		
		public static const ATYPE_TUZI:String = "511";
		
		/**
		 *国庆礼炮1
		 */		
		public static const ATYPE_GUOQING1:String = "512";
		
		/**
		 *国庆礼炮豪华
		 */		
		public static const ATYPE_GUOQING2:String = "513";
		
	
		/**
		 *双十一 
		 */		
		public static const ATYPE_D11:String = "514";
		
		
		/***********************************************************************
		 * 
		 * 				进场动画效果  效果为900---1299
		 * 
		 **********************************************************************/
		/**
		 *进场动画
		 */		
		public static const ATYPE_ENTER:String = "900";
		
		
		/***********************************************************************
		 * 
		 * 				驻场动画效果 1300--1699
		 * 
		 **********************************************************************/
		/**
		 *驻场动画
		 */		
		public static const ATYPE_STOPSCENE:String = "1300";
		/**
		 *场景动画测试
		 */		
		public static const ATYPE_SCENE_TEST:String = "1399";
		/**
		 *场景动画嫦娥 
		 */		
		public static const ATYPE_SCENE_CE:String = "1301";
		
		/**
		 *场景动画天使 
		 */		
		public static const ATYPE_SCENE_TS:String = "1302";
		
		/**
		 *场景动画自动停最后一帧 
		 */		
		public static const SCENE_EFFECT_STOP:String = "1303";
		
		
		
		/***********************************************************************
		 * 
		 * 				特殊动画
		 * 
		 **********************************************************************/
		/**
		 *数量动画 
		 */		
		public static const GROUP_AM:String = "group_am";
		/**
		 *duang动画特效 
		 */			
		public static const ATYPE_DUANG:String = "1400"
		
		public function AnimationType()
		{
		}
	}
}