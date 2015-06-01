package com._17173.flash.show.base.context.net
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.net.socket.BaseSocketDataSerializer;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.utils.Utils;
	
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
			if (Context.variables["debug"]) {
				Debugger.log(Debugger.INFO, "[soeckt]", "返回数据: ", body);
			}
			var json:Object = null;
			try {
				json = JSON.parse(body);
			} catch (e:Error) {
				Debugger.log(Debugger.WARNING,"[socket]","解包JSON.parse调用错误");
				Debugger.log(Debugger.WARNING,Utils.printfBytes(socket as ByteArray));
				json = body;
			}
			return json;
		}
		
		override protected function writeData(data:Array):ByteArray {
			var d:Object = data[0];
			
			var action:int = d["action"];
			var type:int = d["type"];
			Debugger.log(Debugger.INFO, "[soeckt]", "发送消息action: ", action + ", msgtype: ", type);
			
			var result:ByteArray = new ByteArray();
			//封装数据体
			var bodyBa:ByteArray = new ByteArray();
			var body:String = null;
			try {
				body = JSON.stringify(data[1]);
			} catch (e:Error) {
				Debugger.log(Debugger.WARNING, "[socket]", "JSON.stringify调用失败");
				body = data[1];
			}
			if (Context.variables["debug"]) {
				Debugger.log(Debugger.INFO, "[soeckt]", "发送数据: ", body);
			}
			bodyBa.writeUTFBytes(body);
			bodyBa.position = 0;
			if (Context.variables["writeCompress"]) {
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