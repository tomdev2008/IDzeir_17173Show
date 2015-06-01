package com._17173.flash.show.base.module.stat
{
	
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.module.stat.base.StatBase;
	import com._17173.flash.show.base.module.stat.base.StatTypeEnum;
	import com._17173.flash.show.base.module.stat.base.StatUtil;
	import com._17173.flash.show.base.module.stat.bi.ShowBIStat;
	
	/**
	 * 尽量脱离业务逻辑的统计模块.
	 *  
	 * @author 庆峰
	 */	
	public class ST extends BaseModule
	{
		
		private static const SHOW_TYPES:Array = ["f11"];
		
		private static const BI_PATH:String = "http://log1.17173.com/pv";
		public static const BI_APP_KEY:String = "147";
		
		private static const QM_PATH:String = "http://stat.v.17173.com/";
		
		/**
		 * 统计实例 
		 */		
		private var _biStat:StatBase = null;
		private var _qmStat:StatBase = null;
		
		public function ST()
		{
			super();
			_version = "0.0.1";
			this.mouseChildren = false;
			initInfo();
		}
		
		/**
		 * 创建相应的统计实例
		 *  
		 * @return 
		 */		
		private function initInfo():void {
			var type:String = StatUtil.playerType;
			var biCls:Class = null;
			var qmCls:Class = null;
			biCls = ShowBIStat;	
			
			if (biCls) {
				_biStat = new biCls(BI_PATH, _version, BI_APP_KEY);
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