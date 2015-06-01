package com._17173.flash.show.base.module.animation.cac
{
	import flash.geom.Point;

	/**
	 *鲜花鸡尾酒配置类 
	 * @author zhaoqinghao
	 * 
	 */	
	public class CACConfig
	{
		public function CACConfig()
		{
		}
		private static var cacConfig:CACConfig;
		public static function getInstans():CACConfig{
			if(cacConfig == null){
				cacConfig = new CACConfig();
			}
			return cacConfig
		}
		/**
		 *飘带显示行数 
		 */		
		public var showLine:int = 2;
		/**
		 *飘带坐标 
		 */		
		public var lineY:int = 0;
		/**
		 *飘带高度 
		 */		
		public var lineHeight:int = 0;
		
		/**
		 *行数 
		 */		
		public var rowCount:int = 0;
		/**
		 *列数 
		 */		
		public var colCount:int = 0;
		/**
		 *格子宽 
		 */		
		public var cWidth:int = 0;
		/**
		 *格子高度
		 */		
		public var cHeight:int = 0;
		/**
		 *单行偏移量 
		 */		
		public var xOffect:int = 0;
		/**
		 *格子配置 
		 */		
		public var configs:Array = [];
		/**
		 *坐标 
		 */		
		public var setX:int = 0;
		/**
		 *坐标 
		 */		
		public var setY:int = 0;
		/**
		 *显示数量 
		 */		
		public var showLimit:int = 0;
		/**
		 *动画位置 
		 */		
		public var mcX:int = 0;
		/**
		 *动画位置 
		 */		
		public var mcY:int = 0;
		/**
		 *所有可防止点集合 
		 */		
		public var pots:Array;
		
		public function setup(data:Object):void{
			rowCount = data.rowCount;
			colCount = data.colCount;
			cWidth = data.cWidth;
			cHeight = data.cHeight;
			xOffect = data.xOffect;
			setX = data.setX;
			setY = data.setY;
			showLimit = data.showLimit
			configs = data.confs;
			mcX = data.mcX;
			mcY = data.mcY;
			showLine = data.showLineCount;
			lineY = data.lineY;
			lineHeight = data.lineHeight;
			setConfigs();
		}
		/**
		 *装在可放置数据 
		 * 
		 */		
		private function setConfigs():void{
			pots = [];
			var len:int = configs.length;
			var len2:int = 0;
			var tmp:Array;
			var pot:Point;
			for (var i:int = 0; i < len; i++) 
			{
				tmp = configs[i];
				len2 = tmp.length
				for (var j:int = 0; j < len2; j++) 
				{
					if(configs[i][j] == 1){
						var tx:int=   cWidth * j;
						var ty:int =  cHeight * i + cHeight;
						pot = new Point(tx,ty);
						pots[pots.length] = pot;
					}
				}
				
			}
			
		}
		
		private function initConfig():void{
			rowCount = 17;
			colCount = 28;
			cWidth = 40;
			cHeight = 20;
			xOffect = 20;
			showLimit = 99;
		}
	}
}