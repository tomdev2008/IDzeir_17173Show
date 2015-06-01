package com._17173.flash.player.context.socket
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.net.socket.BaseSocketDataSerializer;
	import com._17173.flash.core.util.debug.Debugger;
	
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	public class SocketSerializer extends BaseSocketDataSerializer
	{
		
		public function SocketSerializer()
		{
			super();
		}
		
		override public function get id():int {
			return 0;
		}
		
		override protected function readData(socket:IDataInput):Object {
			var body:String = socket.readUTFBytes(socket.bytesAvailable);
			if (_("debug")) {
				Debugger.log(Debugger.INFO, "[socket]", "返回数据: ", body);
			}
			var json:Object = null;
			try {
				json = JSON.parse(body);
			} catch (e:Error) {
				json = body;
			}
			return json;
		}
		
		override protected function writeData(data:Array):ByteArray {
			var d:Object = data[0];
			
			var action:int = d["action"];
			var type:int = d["type"];
			
			var result:ByteArray = new ByteArray();
			//封装数据体
			var bodyBa:ByteArray = new ByteArray();
			var body:String = null;
			try {
				body = JSON.stringify(data[1]);
			} catch (e:Error) {
				body = data[1];
			}
			if (_("debug")) {
				Debugger.log(Debugger.INFO, "[soeckt]", "发送数据: ", body);
			}
			bodyBa.writeUTFBytes(body);
			bodyBa.position = 0;
			if (Context.variables["dataCompress"]) {
				bodyBa.compress();
			}
			//写入头
			result.writeUnsignedInt(8 + bodyBa.length);	//长度8个字节用来表示长度和操作码
			var a:ByteArray = new ByteArray();
			a.writeInt(action);
			result.writeBytes(a, 3, 1);
			a.clear();
			a.writeInt(type);
			result.writeBytes(a, 3, 1);
			a.clear();
			a.writeInt(0);
			result.writeBytes(a, 3, 1);
			a.clear();
			a.writeInt(0);
			result.writeBytes(a, 3, 1);
			
			result.writeBytes(bodyBa, 0, bodyBa.length);
			
			return result;
		}
		
	}
}