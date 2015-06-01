package com._17173.flash.player.module.stat.bi
{
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	import com._17173.flash.player.module.stat.base.StatUtil;

	/**
	 * 点播统计,发往BI
	 *  
	 * @author 庆峰
	 */	
	public class FileBIStat extends PlayerBIStat
	{
		
		/**
		 * 是否首次发送事件 
		 */		
		private var _isFirstTime:Boolean = true;
		private var _getCidTimes:int = 10;
		
		public function FileBIStat(version:String, path:String, appkey:String)
		{
			super(version, path, appkey);
			StatUtil.initUserMark();
		}
		
		/**
		 * 启动统计
		 *  
		 * @param type
		 * @param data
		 */		
		override public function stat(type:String, data:Object):void {
			if (type == StatTypeEnum.EVENT_LOADED) {
				var cid:String = _("cid");
				//视频类别
				var v:Object = _("videoManager").data;
				if (cid && cid != "" && v) {
					super.stat(type, data);
				} else {
					Ticker.tick(200, function ():void {
						_getCidTimes --;
						if (_getCidTimes == 0){
							//super只能在类实例方法中使用 所以调用superStat
							superStat(type, data);
						} else {
							stat(type, data);
						}
					});
				}
			} else {
				super.stat(type, data);
			}
		}
		
		private function superStat(type:String, data:Object):void{
			super.stat(type, data);
		}
		
		override protected function resolveTypeData(type:String, data:Object):Array {
			var d:Array = super.resolveTypeData(type, data);
			//视频类别
			var v:Object;
			if (_("videoManager")) {
				v = _("videoManager").data;
			}
			if (v) {
				d.push({"k":"video_cate", "v":v.aClass + "-" + v.bClass});
			}
			//事件
			
			switch (type) {
				case StatTypeEnum.EVENT_LOADED:
					var cid:String = _("cid");
					d.push({"k":"currevent", "v":"play_load"});
					d.push({"k":"preevent", "v":""});
					break;
				case StatTypeEnum.EVENT_AD_SHOW:
					d.push({"k":"preevent", "v":""});
					d.push({"k":"currevent", "v":"play_ads"});
					break;
				case StatTypeEnum.EVENT_PLAY_REAL_START:
					d.push({"k":"preevent", "v":""});
					d.push({"k":"currevent", "v":"play_real_start"});
					break;
				default :
					if (_isFirstTime) {
						_isFirstTime = false;
						d.push({"k":"currevent", "v":"play_start"});
						d.push({"k":"preevent", "v":""});
					} else {
						d.push({"k":"currevent", "v":"play_stop"});
						d.push({"k":"preevent", "v":"play_start"});
					}
					break;
			}
			//统计不同产品来源的访问
			d.push({"k":"appid", "v":"web173"});
			
			return d;
		}
		
	}
}