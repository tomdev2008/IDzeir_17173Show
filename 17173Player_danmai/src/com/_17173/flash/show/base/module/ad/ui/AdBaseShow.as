package com._17173.flash.show.base.module.ad.ui
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.module.ad.base.AdPlayerType;
	import com._17173.flash.show.base.module.ad.base.AdShowData;
	import com._17173.flash.show.base.module.ad.base.AdStat;
	import com._17173.flash.show.base.module.ad.interfaces.IAdPlayer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 *广告显示基类 
	 * @author zhaoqinghao
	 * 
	 */	
	public class AdBaseShow extends Sprite
	{
		public function AdBaseShow()
		{
			initType();
			super();
			buttonMode = true;
			useHandCursor = true;
			this.addEventListener(Event.ADDED_TO_STAGE,onAddStage);
		}
		protected var _w:int = -1;
		protected var _h:int = -1;
		/**
		 * 支持的广告播放器类型 
		 */		
		protected var _supportedPlayer:Object = {};
		protected var _isLoading:Boolean = false;
		protected var _addedToStage:Boolean = false;
		protected var _player:IAdPlayer = null;
		protected var _complete:Function = null;
		protected var _error:Function = null;
		/**
		 *广告数据 
		 */		
		protected var _data:AdShowData;
		
		/**
		 *支持的广告类型 子类复写
		 * 
		 */		
		protected function initType():void{
		}
		
		protected function onAddStage(e:Event):void {
			_addedToStage = true;
			addEventListener(MouseEvent.CLICK, onClick);
			load();
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected function onRemovedFromStage(e:Event):void {
			_addedToStage = false;
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			// 鼠标事件
			removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function set data(value:Object):void
		{
			_data = value as AdShowData;
			
			load();
		}
		/**
		 *点击 
		 * 
		 */		
		protected function onClick(e:Event):void{
			if (Util.validateStr(_data.jumpTo)) {
				// 跳转
				Util.toUrl(_data.jumpTo);
			}
			// 统计
			AdStat.click(_data);
		}
		
		/**
		 *加载 
		 * 
		 */		
		protected function load():void{
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
		
		public function resize(w:int, h:int):void {
			_w = w;
			_h = h;
			
			if (_player) {
				_player.resize(_w, _h);
			}
		}
		
		protected function onLoadError(info:Object):void {
			_isLoading = false;
			error(null);
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
		protected function complete(result:Object):void {
			dispose();
			if (_complete != null) {
				_complete.apply(null, [result]);
			}
		}
		public function set onError(value:Function):void {
			_error = value;
		}
		
		public function set onComplete(value:Function):void {
			_complete = value;
		}
		
		public function rePostion(rect:Rectangle):void{
			
		}
	}
}