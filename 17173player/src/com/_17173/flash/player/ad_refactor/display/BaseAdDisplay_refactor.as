package com._17173.flash.player.ad_refactor.display
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayerType;
	import com._17173.flash.player.ad_refactor.display.loader.IAdPlayer;
	import com._17173.flash.player.ad_refactor.interfaces.IAdData;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class BaseAdDisplay_refactor extends Sprite implements IAdDisplay_refactor
	{
		
		protected var _w:int = -1;
		protected var _h:int = -1;
		protected var _data:IAdData = null;
		protected var _complete:Function = null;
		protected var _error:Function = null;
		
		protected var _addedToStage:Boolean = false;
		protected var _isLoading:Boolean = false;
		
		protected var _player:IAdPlayer = null;
		/**
		 * 支持的广告播放器类型 
		 */		
		protected var _supportedPlayer:Object = {};
		
		public function BaseAdDisplay_refactor()
		{
			super();
			buttonMode = true;
			useHandCursor = true;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(e:Event):void {
			_addedToStage = true;
			addEventListener(MouseEvent.CLICK, onClick);
			startLoad();
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected function onClick(event:MouseEvent):void {
			if (Util.validateStr(_data.jumpTo)) {
				// 跳转
				Util.toUrl(_data.jumpTo);
			}
			// 统计
			AdStat.click(_data);
		}
		
		protected function onRemovedFromStage(e:Event):void {
			_addedToStage = false;
			dispose();
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			// 鼠标事件
			removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function resize(w:int, h:int):void {
			_w = w;
			_h = h;
			
			if (_player) {
				_player.resize(_w, _h);
			}
		}
		
		public function set data(value:Object):void
		{
			_data = value as IAdData;
			
			start();
			
			startLoad();
		}
		
		protected function start():void {
			// 留空覆写
		}
		
		protected function startLoad():void {
			if (!_addedToStage || !_data || _isLoading) return;
			
			_isLoading = true;
			// 验一下广告类型
			var extension:int = AdPlayerType.validateExtension(_data.url);
			if (_supportedPlayer.hasOwnProperty(extension)) {
				Debugger.log(Debugger.INFO, "[ad]", "广告加载: " + _data.url + "!");
				_player = new _supportedPlayer[extension]();
				_player.onComplete = onLoadSucc;
				_player.onError = onLoadError;
				_player.data = _data;		// 启动加载
			} else {
				Debugger.log(Debugger.INFO, "[ad]", "广告加载: 不支持的广告类型!");
			}
		}
		
		protected function onLoadSucc(result:Object):void {
			_isLoading = false;
			addChildAt(_player.display, 0);
			resize(_w, _h);
			// 因为目前没有不显示就加载的逻辑,所以只要加载成功,就可以算一次统计
			AdStat.show(_data);
		}
		
		protected function onLoadError(info:Object):void {
			_isLoading = false;
			error(info);
		}
		
		protected function complete(result:Object):void {
			dispose();
			if (_complete != null) {
				_complete.apply(null, [result]);
			}
		}
		
		protected function error(error:Object):void {
			dispose();
			if (_error != null) {
				_error.apply(null, [error]);
			}
		}
		
		public function dispose():void {
			_data = null;
			if (_player) {
				if (_player.display && contains(_player.display)) {
					removeChild(_player.display);
				}
				_player.dispose();
				_player = null;
			}
		}
		
		public function get display():DisplayObject {
			return this;
		}
		
		public function set onError(value:Function):void {
			_error = value;
		}
		
		public function set onComplete(value:Function):void {
			_complete = value;
		}
		
	}
}