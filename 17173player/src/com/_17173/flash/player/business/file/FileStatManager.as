package com._17173.flash.player.business.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.stat.StatManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.video.interfaces.IVideoData;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	
	/**
	 * 点播的统计项 
	 * 
	 * @author shunia-17173
	 */	
	public class FileStatManager extends StatManager implements IContextItem
	{
		
		/**
		 * 只有此属性为false时算第一次发送.一旦已经调用过,则会一直是true. 
		 */		
		private var _inited:Boolean = false;
		
		public function FileStatManager()
		{
			super(null, null, null);
		}
		
		/**
		 * 发送统计数据.
		 *  
		 * @param data 额外的参数
		 */		
		override public function stat(data:Object = null):void {
			super.stat(packupData(data));
			_inited = true;
		}
		
		/**
		 * 传入需要统计的额外数据.配合默认数据一起打包.
		 *  
		 * @param data 额外数据项.key-value值对.
		 * @return 
		 */		
		private function packupData(data:Object):Object {
			var r:Object = {};
			
//			var videoData:IVideoData = Global.videoData;
			var videoData:IVideoData = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data;
			
			//封装需要的数据
			//用户id
//			r["userid"] = Global.settings.userLogin ? Global.settings.userID : "";
			r["userid"] = Context.getContext(ContextEnum.SETTING).userLogin ? Context.getContext(ContextEnum.SETTING).userID : "";
			//客户端时间
			r["time"] = new Date().time;
			//上一事件标识,第一次的时候是空,之后就是start
			r["preevent"] = _inited ? "play_start" : "";
			//当前事件标识,第一次的时候是start,之后就是stop
			r["currevent"] = _inited ? "play_stop" : "play_start";
			//解析后的视频id
			r["videoid"] = videoData["cid"];
			//视频类别
			r["video_cate"] = FileVideoData(videoData).aClass + "-" + FileVideoData(videoData).bClass;
			//用户观看当前视频所使用的系统
			r["os"] = os;
			//用户观看当前视频所使用的浏览器
			r["bro"] = browser;
			//用户的设备分辨率
			r["sr"] = Capabilities.screenResolutionX + "*" + Capabilities.screenResolutionY;
			//用户的语言
			r["ln"] = "zh_cn";
			//用户的播放器控件版本
			r["flashid"] = Util.fpver;
			//播放器代码的版本
//			r["flash_ver"] = Global.settings.params["vn"];
			r["flash_ver"] = Context.getContext(ContextEnum.SETTING)["vn"];
			//统计模块的版本
			r["sdk_ver"] = SDK_VER;
			//播放器类型,站内站外直播点播等
//			r["flash_type"] = Global.settings.type;
			r["flash_type"] =Context.getContext(ContextEnum.SETTING)["type"];
			//当前引用页的页面地址
			var v:URLVariables = new URLVariables("url=" +Context.variables["refPage"]);
			r["url"] = v.toString().replace("url=", "");
			
			//无法获取的部分
			r["ip"] = "";
			r["isp"] = "";
			r["area"] = "";
			
			if (data) {
				for (var key:String in data) {
					r[key] = data[key];
				}
			}
			
			return r;
		}
		
		public function get contextName():String {
			return ContextEnum.STAT_MANAGER;
		}
		
		public function startUp(param:Object):void {
			if (param.hasOwnProperty("appKey")) {
				_appkey = param["appKey"];
			}
			if (param.hasOwnProperty("path")) {
				_path = param["path"];
			}
			if (param.hasOwnProperty("channel")) {
				_channel = param["channel"];
			}
		}
		
	}
}