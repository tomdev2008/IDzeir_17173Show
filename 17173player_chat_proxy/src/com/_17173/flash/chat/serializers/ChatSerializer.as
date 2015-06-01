package com._17173.flash.chat.serializers
{
	import com._17173.flash.chat.SerializerType;
	import com._17173.flash.core.net.socket.BaseSocketDataSerializer;
	
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	public class ChatSerializer extends BaseSocketDataSerializer
	{
		
		protected var _readStruct:Array;
		protected var _writeStruct:Array;
		
		public function ChatSerializer()
		{
			super();
			
			_readStruct = readStruct;
			_writeStruct = writeStruct;
		}
		
		override protected function readData(socket:IDataInput):Object {
			return readStructData(socket, _readStruct);
		}
		
		protected function readStructData(socket:IDataInput, struct:Array):Object {
			var data:Object = object;
			
			var str:Object = null;
			var label:* = null;
			for (var i:int = 0; i < struct.length; i ++) {
				str = struct[i];
				label = str.label;
				data[label] = resolveType(socket, str.type);
			}
			return data;
		}
		
		protected function resolveType(socket:IDataInput, type:int):* {
			var data:* = null;
			switch (type) {
				case SerializerType.INT : 
					data = socket.readInt();
					break;
				case SerializerType.BYTE : 
					data = socket.readByte();
					break;
				case SerializerType.DOUBLE : 
					data = socket.readDouble();
					break;
				case SerializerType.SHORT : 
					data = socket.readShort();
					break;
				case SerializerType.STRING : 
					var len:int = socket.readShort();
					data = socket.readUTFBytes(len);
					break;
			}
			return data;
		}
		
		protected function get readStruct():Array {
			return [];
		}
		
		override protected function writeData(data:Array):ByteArray {
			var ba:ByteArray = byteArray;
			ba.writeShort(id);
			
			writeStructData(ba, data, _writeStruct);
			
			return ba;
		}
		
		protected function writeStructData(buffer:ByteArray, data:Array, struct:Array):void {
			if (data == null || data.length == 0) return;
			
			var str:int = 0;
			for (var i:int = 0; i < struct.length; i ++) {
				str = struct[i];
				switch (str) {
					case SerializerType.INT : 
						buffer.writeInt(data[i]);
						break;
					case SerializerType.BYTE : 
						buffer.writeByte(data[i]);
						break;
					case SerializerType.DOUBLE : 
						buffer.writeDouble(data[i]);
						break;
					case SerializerType.SHORT : 
						buffer.writeShort(data[i]);
						break;
					case SerializerType.STRING : 
						buffer.writeUTF(data[i]);
						break;
				}
			}
		}
		
		protected function get writeStruct():Array {
			return [];
		}
	}
}