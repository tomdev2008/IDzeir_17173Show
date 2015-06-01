package com._17173.flash.player.module.stat
{
	
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.module.stat.base.StatBase;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	import com._17173.flash.player.module.stat.base.StatUtil;
	import com._17173.flash.player.module.stat.bi.FileBIStat;
	import com._17173.flash.player.module.stat.bi.StreamBIStat;
	import com._17173.flash.player.module.stat.qm.FileQMStat;
	import com._17173.flash.player.module.stat.qm.StreamQMStat;
	
	import flash.display.Sprite;
	
	/**
	 * 尽量脱离业务逻辑的统计模块.
	 *  
	 * @author 庆峰
	 */	
	public class ST extends Sprite
	{
		
		private static const FILE_TYPES:Array = ["f1", "f2", "f7", "f8",  "f9", "f10"];
		private static const STREAM_TYPES:Array = ["f3", "f4", "f5", "f6", "f12"];
		
		private static const VERSION:String = "1.0.9";
		private static const BI_PATH:String = "http://log1.17173.com/pv";
		private static const BI_APP_KEY:String = "147";
		
		private static const QM_PATH:String = "http://stat.v.17173.com/";
		
		/**
		 * 统计实例 
		 */		
		private var _biStat:StatBase = null;
		private var _qmStat:StatBase = null;
		
		public function ST()
		{
			super();
			
			init();
			
			Debugger.log(Debugger.INFO, "[stat]", "统计模块[版本:" + VERSION + "]初始化!");
		}
		
		/**
		 * 创建相应的统计实例
		 *  
		 * @return 
		 */		
		private function init():void {
			var type:String = StatUtil.playerType;
			var biCls:Class = null;
			var qmCls:Class = null;
			var isFile:Boolean = FILE_TYPES.indexOf(type) != -1;
			if (isFile) {
				biCls = FileBIStat;
				qmCls = FileQMStat;
			} else if (STREAM_TYPES.indexOf(type) != -1) {
				biCls = StreamBIStat;
				qmCls = StreamQMStat;
			}
			
			if (biCls) {
				_biStat = new biCls(BI_PATH, VERSION, BI_APP_KEY);
			}
			if (qmCls) {
				_qmStat = new qmCls(QM_PATH);
			}
		}
		
		/**
		 * 统计接口
		 *  
		 * @param type 统计类型
		 * @param data 统计数据
		 */		
		public function stat(type:String, event:String, data:Object):void {
			switch (type) {
				case StatTypeEnum.BI : 
					if (_biStat) {
						_biStat.stat(event, data);
					}
					break;
				case StatTypeEnum.QM : 
					if (_qmStat) {
						_qmStat.stat(event, data);
					}
					break;
			}
		}
		
	}
}