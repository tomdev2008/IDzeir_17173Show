package com._17173.flash.player.ui
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * 弹出层,至于所有层级之上,用于显示弹出框.
	 * 
	 * 弹出框如果需要自行关闭,需要派发"close"事件.
	 *  
	 * @author shunia-17173
	 */	
	public class PopupLayer extends Sprite
	{
		
		/**
		 * 窗口数组 
		 */		
		private var _windows:Array = null;
		/**
		 * 窗口字典 
		 */		
		private var _windowsCache:Dictionary = null;
		
		public function PopupLayer()
		{
			super();
			
			_windows = [];
			_windowsCache = new Dictionary();
			
//			Global.eventManager.listen(PlayerEvents.UI_RESIZE, resize);
			_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.UI_RESIZE, resize);
		}
		
		/**
		 * 在舞台最上层显示一个显示对象.效果就是弹出框. 
		 * @param window	要显示的显示对象
		 * @param position	显示对象的默认位置.如果为null,则自动居中,否则按该参数进行定位
		 * @param anim		是否播放弹出动画
		 */		
		public function popup(window:DisplayObject, position:Point = null, anim:Boolean = true):void {
			if (window == null) return;
			if (_windows.indexOf(window) != -1) return;
			
			_windows.push(window);
			_windowsCache[window] = position;
			
			window.addEventListener("close", function (e:Event):void {
				closePopup(window);
			}, true);
			if (anim) {
				window.alpha = 0;
				TweenLite.to(window, 0.3, {"alpha":1});
			}
			addChild(window);
			resize();
		}
		
		/**
		 * 在舞台最上层的最下层,效果就是弹出框.
		 */
		public function popdown(window:DisplayObject, position:Point = null, anim:Boolean = true):void {
			if (window == null) return;
			if (_windows.indexOf(window) != -1) return;
			
			_windows.unshift(window);
			//_windows.push(window);
			_windowsCache[window] = position;
			
			window.addEventListener("close", function (e:Event):void {
				closePopup(window);
			}, true);
			if (anim) {
				window.alpha = 0;
				TweenLite.to(window, 0.3, {"alpha":1});
			}
			addChildAt(window,0);
			resize();
		}
		/**
		 * 关闭弹出框 
		 * 
		 * @param window
		 * @param anim
		 */		
		public function closePopup(window:DisplayObject, anim:Boolean = true):void {
			if (window && _windows.indexOf(window) != -1) {
				if (anim) {
					TweenLite.to(window, 0.1, {"alpha":0, "onComplete":function (parent:DisplayObjectContainer):void {
						if (parent.contains(window)) {
							parent.removeChild(window);
							window.alpha = 1;
						}
						//解决两个问题
						//1.popup组件可能会有子删除的情况，这时候会只执行从缓存中删除对应项，不执行removeChild
						//2.有可能某个组件多次派发移除事件，如果不判断引用大于等于0会导致错误的删除其他项
						if (_windows.indexOf(window) >= 0) {
							_windows.splice(_windows.indexOf(window), 1);
							delete _windowsCache[window];
						}
					}, "onCompleteParams":[this]});
				} else {
					if (this.contains(window)) {
						this.removeChild(window);
					}
					_windows.splice(_windows.indexOf(window), 1);
					delete _windowsCache[window];
				}
			}
		}
		
		/**
		 * 清空弹出框 
		 */		
		public function cleanPopUp():void
		{
			for each (var item:DisplayObject in _windows) {
				closePopup(item);
			}
		}
		
		/**
		 * resize当前弹出框
		 *  
		 * @param data
		 */		
		public function resize(data:Object = null):void {
//			var aw:Number = Global.uiManager.avalibleVideoWidth;
//			var ah:Number = Global.uiManager.avalibleVideoHeight;
			var aw:Number = _(ContextEnum.UI_MANAGER).avalibleVideoWidth;
			var ah:Number = _(ContextEnum.UI_MANAGER).avalibleVideoHeight;
			
			for (var window:* in _windowsCache) {
				if (window && window is DisplayObject) {
					if (window.hasOwnProperty("resize")) {
						var func:Function = window["resize"];
						if (func != null) {
							if (func.length == 2) {
								window["resize"](aw, ah);
							} else if (func.length == 0) {
								window["resize"]();
							}
						}
					}
					var pos:Point = _windowsCache[window];
					if (pos) {
						window.x = pos.x;
						window.y = pos.y;
					} else {
						window.x = (aw - window.width) / 2;
						window.y = (ah - window.height) / 2;
					}
				}
			}
		}
		
	}
}