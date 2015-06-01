package
{
	import com._17173.flash.chat.ChatSocketService;
	import com._17173.flash.chat.serializers.ChatReceiveSerializer;
	import com._17173.flash.chat.serializers.ChatSendSerializer;
	import com._17173.flash.core.base.StageIniator;
	import com._17173.flash.core.net.socket.SocketEvent;
	import com._17173.flash.core.net.socket.SocketManager;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.debug.Debugger;
	
	/**
	 * 聊天代理.用以在客户端页面和服务器之间建立长连接,并对聊天消息做代理转发. 
	 * @author shunia-17173
	 */	
	[SWF(width="1", height="1")]
	public class ChatProxy extends StageIniator
	{
		
		public static const SEND:int = 1000;
		public static const RECEIVE:int = 1001;
		
		private var _socket:SocketManager = null;
		
		public function ChatProxy()
		{
			super(true);
		}
		
		override protected function init():void {
			//construct
			_socket = new SocketManager(ChatSocketService);
			//event listeners
			_socket.addEventListener(SocketEvent.SOCKET_CONNECTED, onSocketConnected);
			_socket.addEventListener(SocketEvent.SOCKET_CLOSED, onSocketClosed);
			_socket.addEventListener(SocketEvent.SOCKET_RECEIVED, onSocketReceived);
			_socket.addEventListener(SocketEvent.SOCKET_SENDING, onSocketSending);
			//register serializers/deserializers
			_socket.registerSerializer(new ChatReceiveSerializer());
			_socket.registerSerializer(new ChatSendSerializer());
			//start up
			_socket.init();
			
			//enable js call
			JSBridge.enabled = true;
			//init socket connection
			JSBridge.addCall("init", null, null, onInitSocketService, true);
			//send data
			JSBridge.addCall("onSendMsg", null, null, onSendingMessage, true);
			
			//listen to received data
			_socket.listen(RECEIVE, onReceivingMessage);
		}
		
		/**
		 * 进行连接. 
		 * @param url	socket服务路径
		 * @param port	socket服务端口
		 * @param secureHost	crossdomain服务路径
		 * @param securePort	crossdomain端口
		 * 
		 */		
		private function onInitSocketService(url:String, port:int, secureHost:String, securePort:int):void {
			_socket.socketService.init(url, port, secureHost, securePort);
		}
		
		/**
		 * 有聊天消息到达. 
		 */		
		private function onReceivingMessage(data:Object):void {
			//receive data
			JSBridge.addCall("onReceiveMsg", data.msgs);
		}
		
		/**
		 * 发送聊天消息. 
		 */		
		private function onSendingMessage(data:Object = null):void {
			if (_socket.connected) {
				_socket.send(SEND, [data]);
			}
		}
		
		protected function onSocketSending(event:SocketEvent):void {
			Debugger.tracer("socket data sent: [type]" + event.serviceType);
		}
		
		protected function onSocketReceived(event:SocketEvent):void {
			Debugger.tracer("socket data received: [type]" + event.serviceType);
		}
		
		protected function onSocketClosed(event:SocketEvent):void {
			Debugger.tracer("socket closed");
		}
		
		protected function onSocketConnected(event:SocketEvent):void {
			Debugger.tracer("socket connected");
			//通知js连接成功
			JSBridge.addCall("onInited");
		}
		
	}
}