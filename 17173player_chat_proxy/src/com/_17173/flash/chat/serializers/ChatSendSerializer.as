package com._17173.flash.chat.serializers
{
	import flash.utils.ByteArray;
	
	/**
	 * 发送消息的解析器. 
	 * @author shunia-17173
	 */	
	public class ChatSendSerializer extends ChatSerializer
	{
		
		private var _serializedData:ByteArray = null;
		
		public function ChatSendSerializer()
		{
			super();
		}
		
		override public function get id():int {
			return ChatProxy.SEND;
		}
		
		override protected function get writeStruct():Array {
			return [
				
			];
		}
		
	}
}