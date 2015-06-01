package com._17173.flash.player.module.watching
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.plugin.IPluginItem;
	import com._17173.flash.core.plugin.PluginEvents;
	import com._17173.flash.core.skin.ISkinManager;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.socket.ISocketManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.socket.SEnum;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.comps.controlbar.ControlBar;
	
	import flash.events.EventDispatcher;
	
	/**
	 * 观看人数模块
	 *  
	 * @author shunia-17173
	 */	
	public class WatchingManager extends EventDispatcher implements IPluginItem
	{
		
		private var _name:String = "";
		
		private var _ui:WatchingUI = null;
		private var _inited:Boolean = false;
		
		public function WatchingManager() {
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			_name = value;
		}
		
		public function init():void {
			if (_inited) return;
			_inited = true;
			Debugger.log(Debugger.INFO, "[watching]", "观看人数模块初始化!");
			if (controlBar) {
				_ui = new WatchingUI();
				controlBar.addItem(_ui);
				//debug
//				onSetPreNum(Math.random() * 10000);
			}
			
//			Global.jsDelegate.listen("setPreNum", onSetPreNum);
			Context.getContext(ContextEnum.JS_DELEGATE).listen("setPreNum", onSetPreNum);
			
			IEventManager(Context.getContext(ContextEnum.EVENT_MANAGER)).listen("onUserNumChanged", onSetPreNum);
			IEventManager(Context.getContext(ContextEnum.EVENT_MANAGER)).listen("onUIResize", onResize);
			
			var socket:ISocketManager = ISocketManager(Context.getContext(ContextEnum.SOCKET_MANAGER));
			if (socket) {
				socket.startConnect();
				socket.listen(SEnum.R_WATCHING, onUpdateWatching);
				socket.listen(SEnum.R_USER_LIST, onUserListUpdated);
				socket.send(SEnum.S_USER_LIST, {"pno":1, "rpp":1});
			}
			
			dispatchEvent(new PluginEvents(PluginEvents.COMPLETE));
		}
		
		/**
		 * 发送更新观看人数消息. 
		 */		
		private function onUpdateWatching(data:Object):void {
			if (data.hasOwnProperty("ct")) {
				var userNum:int = data.ct.currentRoomUserCount;
				onSetPreNum(userNum);
			}
		}
		
		private function onUserListUpdated(data:Object):void {
			var userNum:int = data.ct[0].ucount;
			onSetPreNum(userNum);
		}
		
		private function onSetPreNum(num:int):void {
			_ui.num = num;
//			if (controlBar) {
//				controlBar.resize();
//			}
		}
		
		public function get isInited():Boolean {
			return _inited;
		}
		
		private function get controlBar():ControlBar {
//			var cb:ISkinObject = Global.skinManager.getSkin(SkinsEnum.CONTROL_BAR);
			var cb:ISkinObject = (Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).getSkin(SkinsEnum.CONTROL_BAR);
			return cb.display as ControlBar;
		}
		
		private function onResize(data:Object = null):void {
			if (_ui) {
				_ui.resize();
			}
		}
		
	}
}