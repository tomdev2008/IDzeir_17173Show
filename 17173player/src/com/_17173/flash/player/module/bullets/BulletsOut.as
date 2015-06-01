package com._17173.flash.player.module.bullets
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.socket.ISocketManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.socket.SEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.RedirectData;
	import com._17173.flash.player.model.RedirectDataAction;
	import com._17173.flash.player.module.bullets.base.BulletData;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	/**
	 * 弹幕模块站外版本
	 *  
	 * @author shunia-17173
	 */	
	public class BulletsOut extends Bullets
	{
		
		private var _socket:ISocketManager = null;
		private var _token:Object = null;
		private var _rid:String = null;
		private var _uid:String = null;
		
		private var _tipWindow:MovieClip = null;
		
		private static const INTERVAL:int = 3000;
		private static const MAX_CHAR:int = 20;
		
		private var _lastBullet:int = 0;
		private var _isInited:Boolean = false;
		
		public function BulletsOut()
		{
		}
		
		override protected function init():void {
			_version = "out_1.1.0";
			_addUIDefault = true;
			super.init();
			
//			Context.getContext(ContextEnum.EVENT_MANAGER).listen("onOutPlayerDataReady", onInit);
			onInit(null);
			initFaceManager();
		}
		
		override public function addToBar():void {
			var streamBar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.STREAM_EXTRA_BAR);
			if (!_ui) {
				_ui = new BulletUI(this);
				_ui.name = "bullet";
			}
			streamBar.call("addItem", _ui, ExtraUIItemEnum.OUT_BULLET);
		}
		
		/**
		 *初始化表情替换 
		 * 
		 */		
		private function initFaceManager():void{
			//关闭表情
			BulletFaceManager.getInstance().faceSwitch = false;
		}
		/**
		 * 启动弹幕模块，对socket监听
		 */		
		private function onInit(data:Object):void {
			_socket = ISocketManager(Context.getContext(ContextEnum.SOCKET_MANAGER));
			_socket.listen(SEnum.R_CHAT_PUBLIC, onChatPublic);
			_socket.listen(SEnum.R_CHAT_PUBLIC_TO, onChatPublicTo);
			Context.getContext(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.SOCKET_CONNECT_ERROR, onError);
		}
		
		/**
		 * 返回的code不是000000,即有异常的情况.
		 * 
		 * @param data
		 */		
		private function onError(data:Object):void {
			if (!data.hasOwnProperty("retcode")) {
				return;
			}
			switch (data.retcode) {
				case "402005" : //文字过长
					warn(2);
					break;
				case "402003" : //文字间隔过短
					warn(1);
					break;
			}
		}
		
		/**
		 * 对某某公聊.
		 *  
		 * @param data
		 */		
		private function onChatPublicTo(data:Object):void {
			onGetMessage(filterContentToBullets(data));
		}
		
		/**
		 * 公聊.
		 *  
		 * @param data
		 */		
		private function onChatPublic(data:Object):void {
			onGetMessage(filterContentToBullets(data));
		}
		
		/**
		 * 覆写发送弹幕逻辑.
		 *  
		 * @param bullet
		 */		
		override public function sendBullet(bullet:BulletData):void {
			//输入文字过多
			if (Util.strCharLen(bullet.content) > 30) {
				warn(2);
				return;
			}
			//输入时长过短
			if (_lastBullet != 0 && (getTimer() - _lastBullet) < INTERVAL) {
				warn(1);
				return;
			}
			
			super.sendBullet(bullet);
			
			var content:Object = {};
			content["_method_"] = "SendPubMsg";
			content["ct"] = escape(bullet.toObject().content);
			content["style"] = bullet.getStyle();
			
			_socket.send(SEnum.S_CHAT, content);
		}
		
		/**
		 * 弹出警告提示框.
		 *  
		 * @param content
		 */		
		private function warn(i:int):void {
			if (_tipWindow == null) {
				_tipWindow = new mc_bullets_out_tipWindow();
			}
			_tipWindow.gotoAndStop(i);
			_tipWindow.enterBtn.addEventListener(MouseEvent.CLICK, onGoBackToRoom);
			_tipWindow.clsBtn.addEventListener(MouseEvent.CLICK, onClose);
			
			if (!_tipWindow.parent) {
				//弹出
				Context.getContext(ContextEnum.UI_MANAGER).popup(_tipWindow);
			}
			
			//展示统计
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.QM, StatTypeEnum.EVENT_SHOW, {"action": (i == 1 ? RedirectDataAction.ACTION_SHOW_WIN_FRQ : RedirectDataAction.ACTION_SHOW_WIN_WORD), "type":RedirectDataAction.PLAYER_POPUP});
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_REDIRECT, {"action": (i == 1 ? RedirectDataAction.ACTION_SHOW_WIN_FRQ : RedirectDataAction.ACTION_SHOW_WIN_WORD), "click_type":RedirectDataAction.PLAYER_POPUP});
		}
		
		private function onGoBackToRoom(e:Event):void {
			//回链
			var redirect:RedirectData = new RedirectData();
			redirect.click_type = RedirectDataAction.CLICK_TYPE_REDIRECTION;
			if (_tipWindow.currentFrame == 1) {
				redirect.action = RedirectDataAction.ACTION_CLICK_WIN_FRQ;
			} else {
				redirect.action = RedirectDataAction.ACTION_CLICK_WIN_WORD;
			}
			var u:String = Context.variables["url"];
			if (Util.validateStr(u)) {
				u = u.split("|")[0];
				redirect.url = u;
			}
			redirect.send();
			//关闭
			onClose();
		}
		
		private function onClose(e:Event = null):void {
			_tipWindow.enterBtn.removeEventListener(MouseEvent.CLICK, onGoBackToRoom);
			_tipWindow.clsBtn.removeEventListener(MouseEvent.CLICK, onClose);
			
			//关闭
			Context.getContext(ContextEnum.UI_MANAGER).closePopup(_tipWindow);
		}
		
		/**
		 * 过滤数据内容并整合为弹幕数据.
		 *  
		 * @param data
		 * @return 
		 */		
		private function filterContentToBullets(data:Object):Array {
			var content:String = "";
			var style:String = null;
			//不是游客的话加上名字
			if (data.hasOwnProperty("masterId") && data.masterId > 0) {
				content += data["masterNick"] + "说:";
			}
			content += data["ct"];
			//样式
			if(data.hasOwnProperty("style")){
				style = (data["style"]);
			}
			
			return [{"content":content,"style":style}];
		}
		override public function get skinObject():Object {
			return {
				"switcher":mc_bulletSwitcher, 
				"bg":mc_streamBG, 
				"sendBtn":mc_sendBulletBtn, 
				"input":mc_userInput,
				"setBtn":mc_setingBtn
			};
		}
	}
}