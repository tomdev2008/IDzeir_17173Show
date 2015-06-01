package com._17173.flash.player.context.socket
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.net.socket.BaseSocketService;
	import com._17173.flash.core.util.debug.Debugger;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	
	public class SocketResolver extends BaseSocketService
	{
		
		private static const PREFIX_LEN:int = 8;
		
		private var _buffer:ByteArray = null;
		private var _len:int = 0;
		private var _isReading:Boolean = false;
		
		public function SocketResolver()
		{
			super();
			
			_buffer = new ByteArray();
		}
		
		override protected function onSocketConnected(e:Event):void {
			super.onSocketConnected(e);
		}
		
		override protected function onSocketData(e:ProgressEvent):void {
			Debugger.log(Debugger.INFO, "[soeckt]", "收到数据: ", e.bytesLoaded, "字节");
			
//			while (_socket.bytesAvailable) {
//				//数据全部读到缓冲区里
//				_socket.readBytes(_buffer, 0);
//			}
			checkDataPackage();
		}
		
		private function checkDataPackage():void {
			//根据包是否满了来解析数据
			if (isPackageFull()) {
				_isReading = false;
				Debugger.log(Debugger.INFO, "[soeckt]", "开始解包, 包长度: ", _len, "字节");
				resolvePackage();
				//解完了还原长度为0
				_len = 0;
				//如果还有数据,还得继续解
				if (_socket.bytesAvailable > 0) {
					checkDataPackage();
				}
			}
		}
		
		/**
		 * 解析包体数据 
		 */		
		protected function resolvePackage():void {
			//解析接口标识
			var index:int = _socket.readUnsignedInt();
//			Debugger.log(Debugger.INFO, "[soeckt]", "包序号: ", index);
			var pack:ByteArray = new ByteArray();
			_socket.readBytes(pack, 0, _len - PREFIX_LEN);
			Debugger.log(Debugger.INFO, "[soeckt]", "数据包长度: ", pack.bytesAvailable, "字节");
			//解析是否压缩
			if (pack[0] == 0x78 && pack[1] == 0x9c) {
				Context.variables["dataCompress"] = true;
				pack.uncompress();
			} else {
				Context.variables["dataCompress"] = false;
			}
			//返回给使用者
			if (_onDataArrive != null) {
				_onDataArrive(0, pack);
			}
		}
		
		/**
		 * 根据长度判断是否满足 
		 * @return 
		 */		
		protected function isPackageFull():Boolean {
			if (!_isReading) {
				if (_socket.bytesAvailable >= PREFIX_LEN) {
					_len = _socket.readUnsignedInt();
					if (_len >= 0 && _len < 20000) {
						Debugger.log(Debugger.INFO, "[soeckt]", "包长度: ", _len, "字节");
						_isReading = true;
					}else {
						//长度异常,直接丢掉
						_socket.readUTFBytes(_socket.bytesAvailable);
						Debugger.log(Debugger.INFO, "[soeckt]", "包长度: ", _len, "字节", ", 过长产生异常,数据已经被丢弃");
						_isReading = false;
					}
				}
			}
			//8位包含一个4位的包长(无符号整形为32bit,即4位)和4位长度的接口标识
			if (_isReading && _socket.bytesAvailable >= (_len - PREFIX_LEN)) {
				//剩余长度大于等于包长,则可以开始解包了
				return true;
			}
			return false;
		}
		
	}
}