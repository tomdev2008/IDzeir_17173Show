package com._17173.flash.show.model 
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.net.IServiceProvider;

	/**
	 * 错误解析处理类.
	 *  
	 * @author shunia-17173
	 */	
	public class SError
	{
		
		private const DICT:Object = {
			////////////////////
			//
			//	客户端错误,id以负数开始
			//
			///////////////////
			//用户已经登陆过该房间
			"-000001":{"okBack":onRefreshPage, "cancelBack":onRefreshPage, "msg":{"key":"409004", "pack":"error"}}, 
			"-000002":{"okBack":onRefreshPage, "cancelBack":onRefreshPage, "msg":{"key":"connection_lost", "pack":"error"}}, 
			//达到重连上线
			"-000003":{"okBack":retrySocketFail, "cancelBack":retrySocketFail, "destroy":true, "msg":{"key":"re_connection_fail", "pack":"error"}}, 
			//重连获取token失败
			"-000004":{"okBack":onGoHome, "cancelBack":onGoHome, "destroy":true, "okLabel":{"key":"gotoHome", "pack":"components"} , "msg":{"key":"getRoomData_fail", "pack":"error"}},
			//http不可调用
			"-000005":{"okBack":retrySocketFail, "cancelBack":retrySocketFail, "destroy":true, "msg":{"key":"http_lost", "pack":"error"}}, 
			////////////////////
			//
			//	服务器错误
			//
			///////////////////
			//通用错误
			"000001":{"handler":showAlert}, 
			//解码错误
			"000002":{"handler":showAlert}, 
			//钱不够
			"200000":{"okBack":toMoney, "msg":{"key":"200000", "pack":"error"}, "okLabel":{"key":"money_label1", "pack":"components"}}, 
			//未登录
			"000004":{"okBack":toLogin, "buttonType":Alert.BTN_OK|Alert.BTN_CANCEL, "okLabel":{"key":"login_label1", "pack":"components"}}, 
			//未登录
			"401002":{"okBack":toLogin, "buttonType":Alert.BTN_OK|Alert.BTN_CANCEL, "okLabel":{"key":"login_label1", "pack":"components"}}, 
			//请求的参数无效
			"401001":{"okBack":onRefreshPage, "cancelBack":onRefreshPage}, 
			//无效的roomID,房间不存在
			"401005":{"okBack":onRefreshPage, "destroy":true, "cancelBack":onRefreshPage, "msg":{"key":"401005", "pack":"error"}}, 
			//聊天不在指定的服务器上面
			"401014":{"okBack":onRefreshPage, "cancelBack":onRefreshPage}, 
			//房间用户已满
			"401011":{"okBack":onRefreshPage, "destroy":true, "cancelBack":onRefreshPage, "msg":{"key":"401011", "pack":"error"}}, 
			//未得到授权(被踢)
			"401007":{"okBack":autoGoHome, "cancelBack":autoGoHome, "destroy":true, "msg":{"key":"401007", "pack":"error"}}, 
			//用户被禁言
			"402001":{"handler":chatError, "msg":{"key":"402001", "pack":"error"}}, 
			//新手60秒内不允许发言
			"402002":{"handler":chatError, "msg":{"key":"402002", "pack":"error"}}, 
			//30秒发言限制
			"402003":{"okBack":toLogin, "buttonType":Alert.BTN_OK|Alert.BTN_CANCEL, "okLabel":{"key":"login_label1", "pack":"components"},"msg":{"key":"402003","pack":"error"}},
			//聊天内容为空
			"402004":{"handler":chatError, "msg":{"key":"402004", "pack":"error"}}, 
			//聊天内容过长
			"402005":{"okBack":toLogin, "buttonType":Alert.BTN_OK|Alert.BTN_CANCEL, "okLabel":{"key":"login_label1", "pack":"components"},"msg":{"key":"402005","pack":"error"}},
			//游客不允许发言
			"402006":{"okBack":chatError, "buttonType":Alert.BTN_OK|Alert.BTN_CANCEL, "okLabel":{"key":"login_label1", "pack":"components"},"msg":{"key":"402006","pack":"error"}}, 
			//发言对象不能为空
			"402007":{"handler":chatError, "msg":{"key":"402007", "pack":"error"}}, 
			//聊天内容过长
			"402008":{"handler":chatError, "msg":{"key":"402008", "pack":"error"}}, 
			//发言对象找不到
			"402009":{"handler":chatError, "msg":{"key":"402009", "pack":"error"}}, 
			//主播或者巡官或者财富等级大于3才允许私聊
			"402010":{"handler":chatError, "msg":{"key":"402010", "pack":"error"}}, 
			//房间公聊已关闭
			"402011":{"handler":chatError, "msg":{"key":"402011", "pack":"error"}}, 
			//对方不允许私聊
			"402012":{"handler":chatError, "msg":{"key":"402012", "pack":"error"}}, 
			//登录用户聊天太快
			"402013":{"handler":chatError, "msg":{"key":"402013", "pack":"error"}}, 
			//输入验证码
			"403001":{"handler":showAlert}, 
			//验证码错误
			"403002":{"handler":showAlert}, 
			//投票时间不足10分钟
			"404001":{"handler":showAlert}, 
			//投票出错
			"404002":{"okBack":onRefreshPage,"cancelBack":onRefreshPage}, 
			//在其他房间登陆
			"409004":{"okBack":onGoHome, "destroy":true,"cancelBack":onGoHome,"msg":{"key":"409004", "pack":"error"}}, 
			//踢出房间
			"409005":{"okBack":onRefreshPage, "destroy":true,"cancelBack":onRefreshPage},
			//强制刷新页面
			"900000":{"okBack":onRefreshPage,"cancelBack":onRefreshPage}
		};
		
		private var _id:String = null;
		private var _msg:String = null;
		
		public function SError(id:String, msg:String)
		{
			_id = id;
			_msg = msg;
		}

		/**
		 * 错误id号,绝大部分由后端定义.
		 *  
		 * @return 
		 */		
		public function get id():String
		{
			return _id;
		}
		
		/**
		 * 错误内容.绝大部分由后端定义并且传递过来.
		 *  
		 * @return 
		 */		
		public function get msg():String
		{
			return _msg;
		}
		
		/**
		 * 内部解析方法.
		 * 根据错误id拆分解析逻辑. 
		 * 如果在DICT中注册了解析方法,则使用指定的方法进行解析.
		 * 如果在DICT中注册了解析参数,则使用alert来处理并使用注册的参数作为替换参数.
		 * 如果没有注册该错误,则弹出通用错误面板.不做任何回调处理.
		 */		
		internal function handle():void {
			if (DICT.hasOwnProperty(_id)) {
				var conf:Object = DICT[_id];
				var handler:Function = conf && conf.hasOwnProperty("handler") ? conf.handler : null;
				if (handler != null) {
					handler.apply(this, [conf]);
				} else {
					showAlert(conf);
				}
			} else {
				showAlert(null);
			}
		}
		
		/**
		 * 默认弹出提示框
		 *  
		 * @param data
		 */		
		private function showAlert(data:Object = null):void {
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			
			var title:String = local.get("system_title","components");
			var msg:String = _id + "：" + _msg;
			var btnType:int = Alert.BTN_OK;
			var okBack:Function = null;
			var cancelBack:Function = null;
			var okLabel:String = null;
			var cancelLabel:String = null;
			//解析默认配置里的回调函数和按钮类型以及按钮文字,进行替换
			if (data) {
				if (data.buttonType) {
					btnType = data.buttonType;
				}
				if (data.okBack) {
					okBack = data.okBack;
				}
				if (data.okLabel) {
					okLabel = getString(data.okLabel);
				}
				if (data.cancelBack) {
					cancelBack = data.cancelBack;
				}
				if (data.cancelLabel) {
					cancelLabel = getString(data.cancelLabel);
				}
				if (data.msg) {
					var c:String = getString(data.msg);
					Debugger.log(Debugger.ERROR, "[SError]", _id + ":" + c);
					msg = c;
				}
			}
			//系统错误消息，销毁socket连接
			if(data.hasOwnProperty("destroy")&&data["destroy"])
			{
				var s:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
				s.socket.destroy(JSON.stringify(data)+" [info]:"+getString(data["msg"]));
			}
			//弹出
			ui.popupAlert(title, msg, -1, btnType, okBack, cancelBack, okLabel, cancelLabel);
		}
		
		private function retrySocketFail(data:Object = null):void
		{
			var iSocketProvider:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			iSocketProvider.http.enabled = false;
			
			this.onRefreshPage();
		}
		
		/**
		 * 聊天错误消息显示  
		 */		
		private function chatError(data:Object=null):void{
			var _e:IEventManager=Context.getContext(CEnum.EVENT) as IEventManager;			
			_e.send(SEvents.CHAT_NOTIFY,getString(data.msg));
		}
		
		private function getString(obj:Object):String {
			if (obj is String) {
				return String(obj);
			} else {
				var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
				try{
					var value:String = local.get(obj.key, obj.pack);
				}catch(e:Error){}				
				//容错未记录的的SError
				if(value == null)
				{
					value = JSON.stringify(obj);
				}
				return value;
			}
		}
		
		/**
		 * 刷新页面
		 * 并且断开连接 
		 */		
		private function onRefreshPage():void {
			var s:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			s.socket.close();
			Util.refreshPage();
		}
		
		/**
		 * 自动返回首页
		 */		
		private function autoGoHome():void {
			//var s:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			//s.socket.close();
			Ticker.tick(3000, onGoHome);
		}
		
		/**
		 * 返回主页 
		 */		
		private function onGoHome():void {
			Util.toUrl(SEnum.home, "_self");
		}
		
		/**
		 * 去充值
		 */		
		private static function toMoney():void{
			Util.toUrl(SEnum.URL_MONEY);
		}
		
		/**
		 * 弹出登陆面板 
		 */		
		private static function toLogin():void{
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.LOGINPANEL_SHOW);
		}
		
		/**
		 * 处理错误信息.
		 *  
		 * @param error {code:错误编号,msg:错误消息}
		 */		
		public static function handleServerError(error:Object,showAlert:Boolean = true):void {
			if (!error.hasOwnProperty("code")) {
				Debugger.log(Debugger.ERROR, "[SError]", "返回错误信息的类型错误");
				return;
			}
			//Debugger.log(Debugger.INFO, "[SError]", "返回错误信息的类型错误 >"+JSON.stringify(error));
			var se:SError = new SError(error.code, error.msg);
			se.handle();
			IEventManager(Context.getContext(CEnum.EVENT)).send(SEvents.ON_ERROR, se);
		}

	}
}