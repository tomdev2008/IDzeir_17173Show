package com._17173.flash.core.util
{
	import com._17173.flash.core.util.debug.Debugger;
	
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	/**
	 * Flash sharedobject的封装类, 提供sharedObject的api. 
	 * @author shunia-17173
	 */	
	public class Cookies
	{
		
		private var _so:SharedObject = null;
		private var _size:int = 0;
		private var _onSuccess:Function = null;
		private var _onFailed:Function = null;
		private static const DATA_KEY:String = "data";
		private var _key:String = "";
		
		/**
		 * 构造函数. 
		 * @param key	cookie的名字.
		 * @param path	cookie的相对路径.(文件路径)
		 */		
		public function Cookies(key:String, path:String = null, size:int = 10240)
		{
			if (_so) return;
			_key = key;
			try {
				_so = SharedObject.getLocal(key, path);
				if (_so) {
					if (!_so.data.hasOwnProperty("__init") || _so.data["__init"] == false) {
						_size = size;
						//保证在文件创建的同时生成本地文件
						_so.data["__init"] = true;
						_so.data[DATA_KEY] = {};
						flush(null, null, _size);
						
						Debugger.log(Debugger.INFO, "[Cookie]", "已初始化并创建文件,默认大小: ", size, "字节");
					}
				}
			} catch (e:Error) {}
		}
		
		/**
		 * 获取当前sharedobject存储的所有数据. 
		 * @return 
		 */		
		public function getAll():Object {
			return _so.data[DATA_KEY];
		}
		
		/**
		 * 通过key获得sharedobject中存储的数据. 
		 * @param key
		 * @return 
		 */		
		public function get(key:String):Object {
			return _so.data[DATA_KEY][key];
		}
		
		/**
		 * 是否存在以某个key. 
		 * @param key
		 * @return 
		 */		
		public function has(key:String):Boolean {
			return _so.data[DATA_KEY].hasOwnProperty(key);
		}
		
		/**
		 * 像sharedobject中存一个以key为存储字段,data为存储数据的值. 
		 * @param key
		 * @param data
		 */		
		public function put(key:String, data:Object, write:Boolean = false, onWriteSuccess:Function = null, onWriteFailed:Function = null):void {
			_so.data[DATA_KEY][key] = data;
			if (write) {
				flush(onWriteSuccess, onWriteFailed, _size);
			}
		}
		
		/**
		 * 写进本地 
		 * @param onSuccess
		 * @param onFailed
		 */		
		public function flush(onSuccess:Function = null, onFailed:Function = null, size:int = 10240):void {
			_onSuccess = onSuccess;
			_onFailed = onFailed;
			var flushStatus:String = null;
			try {
				flushStatus = _so.flush(size);
				if (flushStatus) {
					switch (flushStatus) {
						case SharedObjectFlushStatus.FLUSHED : 
//							Debugger.log(Debugger.INFO, "[cookie]", "缓存已写入, 当前缓存大小: " + (_so.size / 1024).toFixed(2) + "kb");
							if (_onSuccess != null) {
								_onSuccess();
								_onSuccess = null;
							}
							break;
						case SharedObjectFlushStatus.PENDING : 
//							Debugger.log(Debugger.INFO, "[cookie]", "缓存写入中, 等待用户授权");
							_so.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatusChange);
							break;
					}
				}
			} catch (e:Error) {
//				Debugger.log(Debugger.INFO, "[cookie]", "缓存写入失败,用户已设置不允许写入缓存文件");
			}
		}
		
		/**
		 * 侦听flash cookie弹窗结果.用户是否允许进行存储. 
		 * @param e
		 * 
		 */		
		private function onFlushStatusChange(e:NetStatusEvent):void {
//			Debugger.log(Debugger.INFO, "[cookie]", "缓存写入中,权限窗口已被关闭");
			switch (e.info.code) {
				case "SharedObject.Flush.Success" : 
					if (_onSuccess != null) {
						_onSuccess();
						_onSuccess = null;
					}
//					Debugger.log(Debugger.INFO, "[cookie]", "用户已经授权,缓存写入成功,当前缓存大小: " + (_so.size / 1024).toFixed(2) + "kb");
					break;
				case "SharedObject.Flush.Failed" : 
					if (_onFailed != null) {
						_onFailed();
						_onFailed = null;
					}
//					Debugger.log(Debugger.INFO, "[cookie]", "用户拒绝写入缓存,缓存写入失败");
					break;
			}
			_so.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatusChange);
		}
		
		/**
		 * 清除某个字段. 
		 * @param key
		 */		
		public function clear(key:String):void {
			if (_so.data[DATA_KEY].hasOwnProperty(key)) {
				delete _so.data[DATA_KEY][key];
			}
		}
		
		public function close():void
		{
			_so.close();
			_so = null;
		}
		
		/**
		 * 清除sharedobject中所有数据. 
		 */		
		public function clearAll():void {
			_so.clear();
		}
		
	}
}