package com._17173.flash.player.module.bullets.base
{
	public class BulletConfig
	{
		public function BulletConfig()
		{
		}
		/**
		 *普通播放 
		 */		
		public static const BULLETTYPE_NORMAL:String = "bullettype_2";
		/**
		 *固定位置上 
		 */		
		public static const BULLETTYPE_FIXURE_TOP:String = "bullettype_1";
		/**
		 *固定位置下
		 */		
		public static const BULLETTYPE_FIXURE_BOTTOM:String = "bullettype_3";
		
		/**
		 *字体大小1 
		 */		
		public static const BULLET_FONTSIZE_14:int = 14;
		/**
		 *字体大小2 
		 */	
		public static const BULLET_FONTSIZE_24:int = 24;
		/**
		 *字体大小3 
		 */	
		public static const BULLET_FONTSIZE_36:int = 36;
		
		private static var bConfig:BulletConfig;
		
		public static function getInstance():BulletConfig{
			if(bConfig == null){
				bConfig = new BulletConfig();
			}
			return bConfig;
		}
		/**
		 *弹幕字号 
		 */		
		public var bulletFontSize:int = BULLET_FONTSIZE_24;
		/**
		 *弹幕类型（1上方固定，2滚动 ，3下方固定） 
		 */		
		public var bulletFontType:String = BULLETTYPE_NORMAL;
		/**
		 *弹幕颜色 
		 */		
		public var bulletFontColor:uint = 0xFFFFFF;
		/**
		 *弹幕表情特殊字 
		 */		
		public var faceNames:Array = [
			"820","BBC","笨哥","单车","F91","海涛","JOY","老杨",
			"MISS","淑仪","小色","ZHOU","DC","PIS","小悠","BURNING","发来贺电",
			"GG","哈哈","好演员","牛X","2009","17173","longdd","老鼠"];
		/**
		 *弹幕表情特殊字对应图 
		 */		
		public var faceMcs:Array = [
			new mc_bf001(),new mc_bf002(),new mc_bf003(),
			new mc_bf004(),new mc_bf005(),new mc_bf006(),
			new mc_bf007(),new mc_bf008(),new mc_bf009(),
			new mc_bf010(),new mc_bf011(),new mc_bf012(),
			new mc_bf013(),new mc_bf014(),new mc_bf015(),
			new mc_bf016(),new mc_bf017(),new mc_bf018(),
			new mc_bf019(),new mc_bf020(),new mc_bf021(),
			new mc_bf022(),new mc_bf023(),new mc_bf024(),
			new mc_bf025()
		]
	}
}