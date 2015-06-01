package com._17173.flash.show.base.context.net
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.net.socket.SocketEvent;
	import com._17173.flash.core.net.socket.SocketManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * Socket服务提供类.
	 * 负责Socket数据转发和基本错误处理.
	 *
	 * @author shunia-17173
	 */
	public class SocketService implements ISocketService
	{

		/**
		 * 重连最大尝试次数
		 */
		private static const MAX_RETRY:uint = 30;
		/**
		 * 心跳间隔
		 */
		private static const HEART_BEAT_TIME:uint = 30000;
		/**
		 * 重试socket间隔
		 */
		private static const RETRY_TIME:uint = 1000;

		/**
		 * 地址
		 */
		private var _domain:String = null;
		/**
		 * 连接端口,由获取房间数据接口返回
		 */
		private var _port:int = 8000;
		/**
		 * 安全端口,默认843,173这边都是跟连接端口一样的
		 */
		private var _securePort:int = 843;
		/**
		 * socket转发底层,提供接口
		 */
		private var _socketManager:SocketManager = null;
		/**
		 * 连接成功回调
		 */
		private var _onConnected:Function = null;
		/**
		 * 错误回调
		 */
		private var _onError:Function = null;
		/**
		 * 注册的socket回调方法
		 */
		private var _callbacks:Dictionary = null;
		/**
		 * 心跳数组,用于检查心跳重连
		 */
		private var _heartRecv:Array = null;
		/**
		 * 握手消息没正常返回之前,收到的消息不做派发,发送的消息不做传输
		 */
		private var _handshakeBlock:Boolean = false;
		/**
		 * 阻挡的要发送请求
		 */
		private var _blockedRequests:Array = null;
		/**
		 * 阻挡的接收到的数据
		 */
		private var _blockedData:Array = null;

		/**
		 * socket 断网重试次数
		 */
		private var _retryTimes:uint = 0;

		public function SocketService()
		{
			_callbacks = new Dictionary();

			_socketManager = new SocketManager(SocketResolver);
			_socketManager.init();
			//注册socket解析类,用来将socket发出和接受到的数据进行打包和解包
			_socketManager.registerSerializer(new SocketSerializer());
			//监听数据
			_socketManager.listen(0, onCallback, false);

			_socketManager.addEventListener(SocketEvent.SOCKET_CONNECTED, onConnected);
//			_socketManager.addEventListener(SocketEvent.SOCKET_RECEIVED, onRecived);
//			_socketManager.addEventListener(SocketEvent.SOCKET_SENDING, onSending);
			_socketManager.addEventListener(SocketEvent.SOCKET_CLOSED, onClosed);

			_heartRecv = [];
			_blockedData = [];
			_blockedRequests = [];
		}

		/**
		 * socket已连接.
		 *
		 * @param event
		 */
		protected function onConnected(event:Event):void
		{
			Debugger.log(Debugger.INFO, "[soeckt]", "连接成功: 数据通道:", _domain, ":", _port, ",安全通道:", _domain, ":", _port);
			//连接成功回调
			if (_onConnected != null)
			{
				_onConnected();
			}
			//持续发送心跳
			Ticker.tick(HEART_BEAT_TIME, onSendHeart, 0);
			//发送重试事件
			if (_retryTimes != 0)
			{
				(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.FW_SOCKET_HANDING, this._retryTimes);
			}

			this._handshakeBlock = true;
		}

		/**
		 * socket断开,清空相关的数据.
		 *
		 * @param event
		 */
		protected function onClosed(event:Event = null):void
		{
			//Debugger.log(Debugger.WARNING,"[socket]","断开连接");
			//_socketManager.removeListen(0, onCallback);
			if(event["serviceData"])
			{
				var serviceData:Object = event["serviceData"];
				statsErrorInfo(serviceData["info"]);
			}
			
			_heartRecv.length = 0;
			_blockedData.length = 0;
			_blockedRequests.length = 0;
			this._handshakeBlock = false;

			Ticker.stop(releaseBlockedData);
			Ticker.stop(releaseBlockedRequests);
			Ticker.stop(onSendHeart);
			if (event)
			{
				Debugger.log(Debugger.INFO, "[socket]", "收到Socket的close事件，服务器驱动");
			}
			retry();
		}
		
		/**
		 * socket断开统计
		 * @param value 断开原因
		 */
		private function statsErrorInfo(value:String):void
		{
			var showData:ShowData = Context.variables["showData"] as ShowData;
			var info:String = "mid:"+showData.ownerID+" cid"+showData.masterID+"service："+this._domain+":"+this._port+" msg："+value;
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.SEND_QM,{"id":"socket","info":"{"+info+"}"})
		}

		/**
		 * 掉线重连
		 */
		private function retry():void
		{
			if (this._retryTimes++ >= MAX_RETRY)
			{
				Debugger.log(Debugger.WARNING, "[socket]", "尝试重连失败，达到重连上限");
				_onError.apply(null, [{"retcode": "-000003"}]);
				return;
			}
			this.close();
			_socketManager.socketService.reconnect();
		}

		/**
		 * socket发送空闲定时每30秒发送心跳数据包
		 */
		private function onSendHeart():void
		{
			//Debugger.log(Debugger.INFO, "[socket]", "心跳验证",_heartRecv.length,_socketManager.connected);
			if (_socketManager.connected)
			{
				if (_heartRecv.length > 1)
				{
					//90秒
					Debugger.log(Debugger.INFO, "[socket]", "心跳检测未收到服务器返回心跳");
					statsErrorInfo("心跳检测未收到服务器返回心跳,主动断开重连");
					onClosed();
				}
				else
				{
					//取随机值,当成心跳发出去
					var heartID:int
					do
					{
						heartID = Math.random() * int.MAX_VALUE;
					} while (_heartRecv.indexOf(heartID) != -1);

					_heartRecv.push(heartID);
					send(SEnum.HEART_BEAT, heartID);
				}
			}
			else
			{
				Debugger.log(Debugger.INFO, "[socket]", "服务器连接已经断开 socketManager.connected = " + _socketManager.connected);
				onClosed();
			}
		}

		/**
		 * 数据解析出来了.
		 *
		 * @param data
		 */
		private function onCallback(data:Object):void
		{
			//验证数据是不是心跳,是心跳丢掉
			if (_heartRecv.indexOf(data) > -1)
			{
				_heartRecv.splice(_heartRecv.indexOf(data), 1);
			}
			else
			{
				//如果返回数据本身出现了错误消息,进行错误处理
				if (!validateResult(data))
				{
					onError(data);
				}
				else
				{
					if (isHandshake(data) && _handshakeBlock)
					{
						Debugger.log(Debugger.INFO, "[socket] 开始派发缓存服务器消息");
						postDataResolve(data);
						_handshakeBlock = false;
						_retryTimes = 0;

						Ticker.tick(100, releaseBlockedData);
						Ticker.tick(100, releaseBlockedRequests);
					}
					else if (_handshakeBlock || this._blockedData.length > 0)
					{
						var msgs:Array = data.msg;
						if (msgs && msgs.length)
						{
							for (var i:uint = 0; i < msgs.length; i++)
							{
								var result:Object = msgs[i];
								var action:int = result.action;
								var type:int = result.msgtype;
								Debugger.log(Debugger.INFO, "[socket]", "缓存消息 action: " + action + ", msgtype: " + type);
							}
						}
						_blockedData.push(data);
					}
					else
					{
						postDataResolve(data);
					}
				}
			}
		}

		/**
		 * 真实解析后台返回的数据
		 *
		 * @param data
		 */
		private function postDataResolve(data:Object):void
		{
			var isHand:Boolean = false;
			var msgs:Array = data.msg;
			var escape:Boolean = data.hasOwnProperty("escapeflag") ? data["escapeflag"] == 1 : false;
			//如果一个消息体中有多个数据,则分多次解析
			if (msgs && msgs.length)
			{
				while (msgs.length)
				{
					resolveData(msgs.shift(), escape);
				}
			}

		}

		/**
		 * 解析单个数据并调用回调方法
		 *
		 * @param result
		 * @param escape
		 */
		private function resolveData(result:Object, escape:Boolean):void
		{
			//读取接口标识
			var action:int = result.action;
			var type:int = result.msgtype;
			//msgtype为1的时候才需要考虑html转义,否则不需要
			if (type == 1)
			{
				if (Util.validateStr(result.ct))
				{
					//还原字符串
					if (escape)
					{
						//解码html
						result.ct = unescape(result.ct);
					}
					//转成object
					try{
						result.ct = JSON.parse(result.ct);
					}catch(e:Error){
						Debugger.log(Debugger.ERROR,"[socket]"," 错误消息action: " + action + ", msgtype: " + type+ ", escape: "+escape+", Ct: "+result.ct);
						//报错丢弃
						return;
					}					
				}
				else
				{
					//默认为空object
					result.ct = {};
				}
			}
			Debugger.log(Debugger.INFO, "[socket]", "返回消息action: " + action + ", msgtype: " + type + ", escape: " + escape);
			var key:String = action + "_" + type;
			//回调
			var callbacks:Array = _callbacks.hasOwnProperty(key) ? _callbacks[key] : null;
			if (callbacks)
			{
				for each (var call:Function in callbacks)
				{
					try
					{
						call.apply(null, [result]);
					}
					catch (e:Error)
					{
						Debugger.log(Debugger.INFO, "[socket]", "业务消息处理错误 action: " + action + ", msgtype: " + type, " 原因：" + e.message);
					}					
				}
			}
		}

		/**
		 * 判断返回的消息是否握手消息.
		 * 如果是握手消息,把缓存的请求和数据都队列处理.
		 *
		 * @param data
		 * @return
		 */
		private function isHandshake(data:Object):Boolean
		{
			var result:Object = data.msg[0];
			//读取接口标识
			var action:int = result.action;
			var type:int = result.msgtype;
			//解除握手消息阻止
			if (action == SEnum.R_HAND.action && type == SEnum.R_HAND.type)
			{
				//每次握手消息之后重置_retryTimes				
				return true;
			}
			else
			{
				return false;
			}
		}

		/**
		 * 验证返回结果从code上是否出现了错误
		 *
		 * @param data
		 * @return
		 */
		private function validateResult(data:Object):Boolean
		{
			return data.hasOwnProperty("retcode") && data.retcode == "000000";
		}

		/**
		 * 每隔100毫秒执行被阻挡的发送数据
		 */
		private function releaseBlockedRequests():void
		{
			if (_blockedRequests.length > 0)
			{
				var o:Array = _blockedRequests.shift();
				_socketManager.send(0, [o[0], o[1]]);
			}
			//如果还有数据,延迟更新
			if (_blockedRequests.length > 0)
			{
				Ticker.tick(100, releaseBlockedRequests);
			}
		}

		/**
		 * 每隔100毫秒执行被阻挡的返回数据
		 */
		private function releaseBlockedData():void
		{
			if (_blockedData.length > 0)
			{
				postDataResolve(_blockedData.shift());
			}
			//如果还有数据,延迟更新
			if (_blockedData.length > 0)
			{
				Ticker.tick(100, releaseBlockedData);
			}
		}

		private function onError(data:Object):void
		{
			if (_onError != null)
			{
				_onError.apply(null, [data]);
			}
		}

		protected function onRecived(event:Event):void
		{

		}

		protected function onSending(event:Event):void
		{

		}

		public function connect(onConnected:Function, onError:Function):void
		{
			_onConnected = onConnected;
			_onError = onError;
			_socketManager.socketService.init(_domain, _port, _domain, _securePort);
		}

		public function close():void
		{
			_socketManager.close();
		}

		public function send(service:Object, body:Object):void
		{
			/*if (_handshakeBlock || _blockedRequests.length > 0)
			   {
			   //如果被阻挡,把请求缓存起来,待后续使用
			   _blockedRequests.push([service, body]);
			   Debugger.log(Debugger.INFO,"[socket]","缓存发送数据个数：",_blockedRequests.length);
			   }
			   else
			   {
			   //如果是握手消息,设置标记位,用来阻挡发送和接受到的数据
			   if (service == SEnum.S_ENTER)
			   {
			   Ticker.stop(releaseBlockedData);
			   Ticker.stop(releaseBlockedRequests);
			   _handshakeBlock = true;
			   }
			   //每次发送socket数据刷新心跳时间
			   Ticker.stop(this.onSendHeart);
			   Ticker.tick(30000, onSendHeart, 0);

			   _socketManager.send(0, [service, body]);
			 }*/

			if (service == SEnum.S_ENTER)
			{
				_socketManager.send(0, [service, body]);
				Ticker.stop(releaseBlockedData);
				Ticker.stop(releaseBlockedRequests);
					//_handshakeBlock = true;
			}
			else if (service == SEnum.HEART_BEAT)
			{
				_socketManager.send(0, [service, body]);
				//每次发送socket数据刷新心跳时间
				Ticker.stop(this.onSendHeart);
				Ticker.tick(30000, onSendHeart, 0);
			}
			else if (_handshakeBlock || _blockedRequests.length > 0)
			{
				_blockedRequests.push([service, body]);
				Debugger.log(Debugger.INFO, "[socket]", "缓存发送数据个数：", "[action:" + service.action + ",type:" + service.type + "]", " " + JSON.stringify(body));
			}
			else
			{
				_socketManager.send(0, [service, body]);
			}
		}

		public function listen(action:int, type:int, callback:Function):void
		{
			var arr:Array = null;
			var key:String = action + "_" + type;
			if (_callbacks.hasOwnProperty(key) && _callbacks[key])
			{
				arr = _callbacks[key];
			}
			else
			{
				arr = [];
			}
			if (arr.indexOf(callback) == -1)
			{
				arr.push(callback);
				_callbacks[key] = arr;
			}
		}

		public function removeListen(action:int, type:int, callback:Function):void
		{
			var key:String = action + "_" + type;
			if (_callbacks.hasOwnProperty(key) && _callbacks[key])
			{
				var arr:Array = _callbacks[key];
				if (arr.indexOf(callback) != -1)
				{
					arr.splice(arr.indexOf(callback), 1);
				}
			}
		}

		public function set domain(value:String):void
		{
			_domain = value;
		}

		public function set port(value:int):void
		{
			_port = value;
		}

		public function set securePort(value:int):void
		{
			_securePort = value;
		}

		public function destroy(info:* = null):void
		{
			//Debugger.log(Debugger.INFO,"[socket]"," 销毁>>>"+info);
			Ticker.stop(onSendHeart);
			_socketManager.removeEventListener(SocketEvent.SOCKET_CONNECTED, onConnected);
			_socketManager.removeEventListener(SocketEvent.SOCKET_CLOSED, onClosed);
			//close();
		}
	}
}