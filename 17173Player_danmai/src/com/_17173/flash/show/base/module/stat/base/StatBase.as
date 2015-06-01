package com._17173.flash.show.base.module.stat.base
{
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * 播放器统计基类 <br/>
	 * 
	 * 统计数据可以被分为两个部分(维度): <br/>
	 * 	第一部分是过滤字段.过滤字段的涵义是提供给统计系统作为分隔用的.比如定义一个appkey,用来指定为统计类型的意思(客户端,播放器,网页等),这个appkey字段在统计系统中是不存在统计意义的,主要用来进行应用分隔或者说类型区分.这类字段为过滤字段. <br/>
	 *  第二部分是数据字段.数据字段的涵义是提供给统计系统作为数据/行为分析用的.比如一个点击事件记录,或者播放时长统计.这其中的点击事件和播放时长,就是数据字段.
	 * 
	 * @author 庆峰
	 */	
	public class StatBase
	{
		
		protected var _path:String = "";
		
		protected var _filter:Array = null;
		protected var _data:Array = null;
		
		public function StatBase(path:String)
		{
			_path = path;
		}
		
		/**
		 * 启动统计
		 *  
		 * @param type
		 * @param data
		 */		
		public function stat(type:String, data:Object):void {
			_data = resolveTypeData(type, data);
			if (_data) {
				onSend();
			}
		}
		
		/**
		 * 将需要发送的数据做单独处理.
		 * 在有需要的情况下,业务类需要继承并改写该方法.
		 *  
		 * @param type 数据类型
		 * @param data 默认数据
		 * @return 解析成功后的数据
		 */		
		protected function resolveTypeData(type:String, data:Object):Array {
			var arr:Array = [];
			for (var k:String in data) {
				arr.push({"k":k, "v":data[k]});
			}
			return arr;
		}
		
		/**
		 * 发送数据
		 * 
		 * 将过滤字段和数据字段分为两个维度解析,合并到接口地址上进行发送
		 *  
		 * @param data
		 */		
		protected function onSend():void {
			var url:String = _path + "?";
			var content:String = "";
			//解过滤字段
			var o:Object = null;
			for each (o in _filter) {
				content += ("&" + o["k"] + "=" + o["v"]);
			}
			//解数据字段
			for each(o in _data) {
				content += ("&" + o["k"] + "=" + formateString(o["v"]));
			}
			//添上内容
			content = content.substr(1, content.length - 1);
			if (content.length > 0) {
				url += content;
				url += "&t=" + new Date().time;
				//发送
				var req:URLRequest = new URLRequest(url);
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				loader.load(req);
			}
		}
		
		protected function formateString(value:Object):Object {
			if (!value) {
				if (value is int || value is Number) {
					if (value == 0) {
						return 0;
					} else {
						return "";
					}
				} else {
					return "";
				}
			}
			return value;
		}
		
		/**
		 * 有的统计是以404返回的,做一个监听但不做处理.防止报错.
		 *  
		 * @param e
		 */		
		protected function onError(e:Event):void {
			
		}
		
	}
}