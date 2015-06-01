package com._17173.flash.player.ui
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.skin.ISkinManager;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	
	import flash.display.Sprite;
	
	/**
	 * 控件层.放置了播放器上的主要的ui部分. 
	 * @author shunia-17173
	 */	
	public class ComponentLayer extends Sprite
	{
		/**
		 * layer里面已经有的组件
		 */		
		private var _uiArr:Array;
		/**
		 * 视频加载时出现的loading圈 
		 */		
		private var _loading:ISkinObject = null;
		/**
		 * 全屏时顶部的控制条 
		 */		
		private var _fullscreenTopBar:ISkinObject = null;
		/**
		 * 外链播放器有可能出现的非全屏顶部控制条 
		 */		
		private var _normalTopBar:ISkinObject = null;
		/**
		 * 底部控制条的容器,默认需要容纳控制栏 
		 */		
		private var _bottomBar:ISkinObject = null;
		/**
		 * 右侧功能区,有分享等功能 
		 */		
		private var _rightBar:ISkinObject = null;
		/**
		 *  
		 */		
		private var _outPlayerTopBar:ISkinObject = null;
		
		private var _adComplete:Boolean = false;
		
		protected var _e:IEventManager = null;
		
		protected var _iskin:ISkinManager = null;
		
		public function ComponentLayer()
		{
			super();
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			_iskin = Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager;
//			_bottomBar = Global.skinManager.attachSkinByName(SkinsEnum.BOTTOM_BAR, this);
//			_rightBar = Global.skinManager.attachSkinByName(SkinsEnum.RIGHT_BAR, this);
//			_normalTopBar = Global.skinManager.attachSkinByName(SkinsEnum.NORMAL_TOP_BAR, this);
//			_fullscreenTopBar = Global.skinManager.getSkin(SkinsEnum.FULLSCREEN_TOP_BAR);
//			_outPlayerTopBar = Global.skinManager.attachSkinByName(SkinsEnum.OUT_TOP_BAR, this);
			_bottomBar = _iskin.attachSkinByName(SkinsEnum.BOTTOM_BAR, this);
			_rightBar = _iskin.attachSkinByName(SkinsEnum.RIGHT_BAR, this);
			_normalTopBar = _iskin.attachSkinByName(SkinsEnum.NORMAL_TOP_BAR, this);
			_fullscreenTopBar = _iskin.getSkin(SkinsEnum.FULLSCREEN_TOP_BAR);
			_outPlayerTopBar = _iskin.attachSkinByName(SkinsEnum.OUT_TOP_BAR, this);
			_e.listen(PlayerEvents.BI_AD_COMPLETE, onAdComplete);
			_uiArr = [_bottomBar, _rightBar, _normalTopBar, _fullscreenTopBar, _outPlayerTopBar];
			init();
//			_loading.display.visible = false;
			resize();
		}
		
		private function onAdComplete(data:Object = null):void
		{
			_adComplete = true;
//			_loading.display.visible = true;
		}
		
		private function init():void {
//			Global.eventManager.listen(PlayerEvents.UI_RESIZE, resize);
			_e.listen(PlayerEvents.UI_RESIZE, resize);
		}
		
		/**
		 * Resize 
		 */		
		public function resize(data:Object = null):void {
			//居中loading
			if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				(Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).attachSkin(_fullscreenTopBar, this);
				_fullscreenTopBar.display.y = 0;
			} else {
				(Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).deattachSkin(_fullscreenTopBar);
			}
//			if (Global.settings.isFullScreen) {
//				Global.skinManager.attachSkin(_fullscreenTopBar, this);
//				_fullscreenTopBar.display.y = 0;
//			} else {
//				Global.skinManager.deattachSkin(_fullscreenTopBar);
//			}
		}
		
		/**
		 * 子组件的mouseEnabled和mouseChildren属性
		 */		
		public function set mouseUse(value:Boolean):void {
			//bottomBar中组件的可用状态
			Context.variables["uiCompEnable"] = value;
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_COMP_ENABLE_CHANGE, value);
			for (var i:int = 0; i < _uiArr.length; i++) {
				var item:ISkinObject = _uiArr[i];
				if (item) {
					(item.display as Sprite).mouseEnabled = value;
					(item.display as Sprite).mouseChildren = value;
				}
			}
		}
		
	}
}