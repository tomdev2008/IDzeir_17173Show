package com._17173.flash.chat.serializers
{
	import com._17173.flash.chat.SerializerType;
	
	
	/**
	 * 接受服务器消息的解析器. 
	 * @author shunia-17173
	 */	
	public class ChatReceiveSerializer extends ChatSerializer
	{
		public function ChatReceiveSerializer()
		{
			super();
		}
		
		override public function get id():int {
			return ChatProxy.RECEIVE;
		}
		
		override protected function get readStruct():Array {
			return [
				{"label":"id", "type":SerializerType.INT}
			];
		}
		
	}
}