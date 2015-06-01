package com._17173.flash.show.base.module.stat.bi
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.module.stat.base.StatTypeEnum;
	import com._17173.flash.show.base.module.stat.base.StatUtil;
	
	/**
	 * 秀场统计
	 * @author 安庆航
	 * 
	 */
	public class ShowBIStat extends PlayerBIStat
	{
		private var _isFirstTime:Boolean = false;
		private var _getCidTimes:int = 10;
		
		public function ShowBIStat(path:String, version:String, appkey:String)
		{
			super(path, version, appkey);
			StatUtil.initUserMark();
		}
		
		/**
		 * 启动统计
		 *  
		 * @param type
		 * @param data
		 */		
		override public function stat(type:String, data:Object):void {
			if (StatUtil.userMark == "") {
				//userMark初始化需要几秒
				Ticker.tick(200, function():void {stat(type, data)});
			} else {
				var obj:Object = Context.variables;
				if (type == StatTypeEnum.EVENT_LOADED) {
					var cid:String = Context.variables["showData"]["cid"];
					if (cid && cid != "") {
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
		}
		
		private function superStat(type:String, data:Object):void{
			super.stat(type, data);
		}
		
		
		protected function createFilterData157():Array {
			var arr:Array = [];
			//统计固定字段
			arr.push({"k":"appkey", "v":"157"});
			//用户标识
			arr.push({"k":"cookie_mark", "v":StatUtil.userMark});
			
			//用户id
			arr.push({"k":"userid", "v":Context.variables.showData.masterID});
			//用户观看当前视频所使用的系统
			arr.push({"k":"os", "v":StatUtil.os});
			//用户观看当前视频所使用的浏览器
			arr.push({"k":"bro", "v":StatUtil.browser});
			//用户的设备分辨率
			arr.push({"k":"sr", "v":StatUtil.resolution});
			//用户的语言
			arr.push({"k":"ln", "v":StatUtil.lang});
			
			//当前引用页的页面地址
			arr.push({"k":"url", "v":StatUtil.refPage});
			//当前引用页的页面地址
			arr.push({"k":"referer", "v":StatUtil.refPage});
			
			return arr;
		}
		
		protected function resolveTypeData157(type:String, data:Object):Array {
			var d:Array = [];
			
			for (var k:String in data) {
				d.push({"k":k, "v":data[k]});
			}
			//客户端时间
			d.push({"k":"time", "v":int(new Date().time /1000)});
			//统计不同产品来源的访问
			d.push({"k":"appid", "v":"weblive"});
			
			_filter = createFilterData157();
			return d;
		}
		
		
		
		
		
		
		
		override protected function resolveTypeData(type:String, data:Object):Array {
			
			var d:Array = [];
			if(type == StatTypeEnum.ZHUCE || type == StatTypeEnum.CHONGZHI || type == StatTypeEnum.ZHUCE_L || type == StatTypeEnum.NICHENG_L ||
				type == StatTypeEnum.SHIJIAN_L || type == StatTypeEnum.DINGYUE_L || type == StatTypeEnum.CHONGZHI_L || type == StatTypeEnum.SILIAO_L
				|| type == StatTypeEnum.SONGLI_L){
				d = resolveTypeData157(type, data);
			}else{
				
				d = super.resolveTypeData(type, data);
				switch (type) {
					case StatTypeEnum.EVENT_LOADED:
						d.push({"k":"currevent", "v":"zb_play_load"});
						d.push({"k":"is_first", "v":StatUtil.isFirst});
						break;
					case StatTypeEnum.EVENT_REDIRECT:
						d.push({"k":"currevent", "v":"zb_play_click"});
						break;
					case StatTypeEnum.EVENT_PLAY_START:
						d.push({"k":"currevent", "v":"zb_play_start"});
						//以下两个参数单三麦没有,bi部门要求发空
						d.push({"k":"liveid", "v":""});
						d.push({"k":"game_code", "v":""});
						break;
					case StatTypeEnum.SPEAK_WEB:
						d.push({"k":"currevent", "v":"speak_web"});
						break;
				}
				//上一个事件
				d.push({"k":"preevent", "v":""});
				//视频类别
				d.push({"k":"video_cate", "v":""});
				//统计不同产品来源的访问
				d.push({"k":"appid", "v":"weblive"});
				//统计不同房间类型的数据量  秀场用
				var showType:String = Context.variables["showData"]["type"];
				//单麦房为0 三麦房为1
				if (showType == "1") {
					d.push({"k":"pdid", "v":"3"});
				} else {
					d.push({"k":"pdid", "v":"1"});
				}
				//统计不同房间的数据量
				d.push({"k":"homeid", "v":Context.variables["roomId"]});
				resetData(d);
			}
			return d;
			
			
			//return d;
		}
		
		private function resetData(value:Array):void {
			var item:Object;
			for (var i:int = 0; i < value.length; i++) {
				item = value[i];
				if (item["k"] == "flash_type") {
					item["v"] = "f11";
				}
			}
		}
	}
}