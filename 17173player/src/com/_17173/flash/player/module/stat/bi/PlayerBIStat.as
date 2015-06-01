package com._17173.flash.player.module.stat.bi
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.player.module.stat.base.StatBase;
	import com._17173.flash.player.module.stat.base.StatUtil;

	/**
	 * 发往BI的统计
	 *  
	 * @author 庆峰
	 */	
	public class PlayerBIStat extends StatBase
	{
		
		/**
		 * 版本 
		 */		
		protected var _ver:String = null;
		/**
		 * 默认参数 
		 */		
		protected var _appkey:String = null;
		/**
		 * 渠道比较特殊,在播放器的业务里这是必须字段,但是点播目前留空 
		 */		
		protected var _channel:String = "";
		
		public function PlayerBIStat(path:String, version:String, appkey:String)
		{
			super(path);
			_ver = version;
			_appkey = appkey;
		}
		
		protected function createFilterData():Array {
			var arr:Array = [];
			//统计固定字段
			arr.push({"k":"appkey", "v":_appkey});
			//用户标识
			arr.push({"k":"cookie_mark", "v":StatUtil.userMark});
			//session
			arr.push({"k":"sessionid", "v":StatUtil.session});
			//用户id
			arr.push({"k":"userid", "v":StatUtil.userID});
			//用户观看当前视频所使用的系统
			arr.push({"k":"os", "v":StatUtil.os});
			//用户观看当前视频所使用的浏览器
			arr.push({"k":"bro", "v":StatUtil.browser});
			//用户的设备分辨率
			arr.push({"k":"sr", "v":StatUtil.resolution});
			//用户的语言
			arr.push({"k":"ln", "v":StatUtil.lang});
			//用户的播放器控件版本
			arr.push({"k":"flashid", "v":StatUtil.flashVer});
			//播放器代码的版本
			arr.push({"k":"flash_ver", "v":StatUtil.playerVer});
			//统计模块的版本
			arr.push({"k":"sdk_ver", "v":_ver});
			//播放器类型,站内站外直播点播等
			arr.push({"k":"flash_type", "v":StatUtil.playerType});
			//当前引用页的页面地址
			arr.push({"k":"url", "v":StatUtil.refPage});
			
			//无法获取的部分
			arr.push({"k":"ip", "v":""});
			arr.push({"k":"isp", "v":""});
			arr.push({"k":"area", "v":""});
			
			return arr;
		}
		
		override protected function resolveTypeData(type:String, data:Object):Array {
			var d:Array = super.resolveTypeData(type, data);
			//发送时动态添加需要的参数
			//渠道
//			d.push({"k":"channel", "v":_channel});
			d.push({"k":"channel", "v":StatUtil.playerChannel});
			//客户端时间
			d.push({"k":"time", "v":new Date().time});
			//解析后的视频id
			d.push({"k":"videoid", "v":Context.variables["cid"]});
			
			//延迟创建过滤字段,因为初始化的时候不一定过滤字段都是全的
			if (_filter == null) {
				_filter = createFilterData();
			}
			
			return d;
		}
		
		override protected function onSend():void {
			super.onSend();
		}
		
	}
}