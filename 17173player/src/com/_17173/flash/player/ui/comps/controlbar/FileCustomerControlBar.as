package com._17173.flash.player.ui.comps.controlbar
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.plugin.PluginManager;
	import com._17173.flash.player.business.file.FileCustomerDataRetriver;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.SkinManager;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerScope;
	import com._17173.flash.player.module.PluginEnum;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * 点播企业版ControlBar
	 * @author 安庆航
	 * 
	 */	
	public class FileCustomerControlBar extends ControlBar
	{
		private var _otherLogo:DisplayObject = null;
		private var _rightDic:Dictionary = null;
		private var _moduleConfBack:Boolean = false;
		private var _hasOtherLogo:Boolean = false;
		
		public function FileCustomerControlBar()
		{
			initRight();
			super();
		}
		
		/**
		 * 初始化right中的组件的间距和显示状态
		 */		
		private function initRight():void {
			_rightDic = new Dictionary();
			_rightDic["otherLogo"] = {"right":5, "vis":true};
			_rightDic["logo"] = {"right":5, "vis":true};
			_rightDic["fullScreen"] = {"right":20, "vis":true};
			_rightDic["volume"] = {"right":5, "vis":true};
			_rightDic["def"] = {"right":5, "vis":true};
		}
		
		override protected function initCom():void {
			_bg = new Shape();
			addChild(_bg);
			
			_left = new Sprite();
			_left.name = "left";
			addChild(_left);
			
			_center = new Sprite();
			addChild(_center);
			
			var skinManager:SkinManager = Context.getContext(ContextEnum.SKIN_MANAGER) as SkinManager;
			var settings:Object = Context.getContext(ContextEnum.SETTING);
			_progressBar = skinManager.attachSkinByName(SkinsEnum.PROGRESS_BAR, this);
			_right = new Sprite();
			_right.name = "right";
			addChild(_right);
			
			_playBtn = skinManager.attachSkinByName(SkinsEnum.PLAY_AND_PAUSE, _left);
			_timeBar = skinManager.attachSkinByName(SkinsEnum.TIMER, _left);
			
			_playBtnBig = skinManager.attachSkinByName(SkinsEnum.PLAY_AND_PAUSE_BIG, this);
			_playBtnBig.display.x = 4;
			_playBtnBig.display.y = -_playBtnBig.display.height - 15;
			_playBtnBig.display.visible = false;
			
			init();
		}
		
		override protected function init():void {
			var eventManager:EventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as EventManager;
			eventManager.listen(PlayerEvents.VIDEO_PAUSE, onPause);
			eventManager.listen(PlayerEvents.VIDEO_RESUME, onResume);
//			eventManager.listen(PlayerEvents.VIDEO_INIT, videInit);
			eventManager.listen(PlayerEvents.BI_AD_SHOW_A4, onShowA4);
			eventManager.listen(PlayerEvents.BI_AD_SHOW_A5, onShowA5);
			eventManager.listen(PlayerEvents.REINIT_VIDEO, reInitVideo);
			eventManager.listen(PlayerEvents.VIDEO_FINISHED, onVideoFinished);
			eventManager.listen(PlayerEvents.UI_INTED, onModuleComplete); 
		}
		
		private function onModuleComplete(value:Object):void {
			_moduleConfBack = true;
			resize();
		}
		
		/**
		 * 向right中添加所有组件
		 */		
		private function rightAddChilden():void {
			removeRight();
			var skinManager:SkinManager = Context.getContext(ContextEnum.SKIN_MANAGER) as SkinManager;
			var settings:Object = Context.getContext(ContextEnum.SETTING);
			
			if (_rightDic["volume"]["vis"]) {
				_volumeBar = skinManager.attachSkinByName(SkinsEnum.VOLUME, _right);
				_volumeBar.display.name = "volume";
				_volumeBar.call("changeVolumeType", false);
				if(Number(settings.volume) <= 0) {
					_volumeBar.set("isMute", true);
				} else {
					_volumeBar.set("volume", Number(settings.volume));
				}
				_volumeBar.listen("mute", onMute);
				_volumeBar.listen("volumeChanged", onVolumeChange);
			}
			if (_rightDic["def"]["vis"]) {
				_defBtn = skinManager.attachSkinByName(SkinsEnum.DEFINITION, _right);
				_defBtn.display.name = "def";
			}
			
			if (_moduleConfBack) {
				addModuleConfgToRight();
			}
		}
		
		/**
		 * 清空right里面的内容
		 */		
		private function removeRight():void {
			if (!_right && _right.numChildren < 1) {
				return;
			}
			var skinManager:SkinManager = Context.getContext(ContextEnum.SKIN_MANAGER) as SkinManager;
			if (_logo && _logo.display && _right.contains(_logo.display)) {
				skinManager.deattachSkinByName(SkinsEnum.LOGO);
			}
			if (_volumeBar && _volumeBar.display && _right.contains(_volumeBar.display)) {
				skinManager.deattachSkinByName(SkinsEnum.VOLUME);
			}
			if (_defBtn && _defBtn.display && _right.contains(_defBtn.display)) {
				skinManager.deattachSkinByName(SkinsEnum.DEFINITION);
			}
			if (_fullScreen && _fullScreen.display && _right.contains(_fullScreen.display)) {
				skinManager.deattachSkinByName(SkinsEnum.FULL_SCREEN);
			}
			if (_right.numChildren > 0) {
				_right.removeChildren(0, _right.numChildren - 1);
			}
			_hasOtherLogo = false;
		}
		
		/**
		 * 将需要配置的组件添加到right里面
		 */		
		private function addModuleConfgToRight():void {
			var uiModule:Object = Context.variables["UIModuleData"];
			var skinManager:SkinManager = Context.getContext(ContextEnum.SKIN_MANAGER) as SkinManager;
			if (!uiModule) {
				if (_rightDic["logo"]["vis"]) {
					_logo = skinManager.attachSkinByName(SkinsEnum.LOGO, _right, 0);
					_logo.display.name = "logo";
				}
				if (_rightDic["fullScreen"]["vis"]) {
					_fullScreen = skinManager.attachSkinByName(SkinsEnum.FULL_SCREEN, _right, 0);
					_fullScreen.display.name = "fullScreen";
				}
			} else {
				if (uiModule[FileCustomerDataRetriver.M3] && _rightDic["otherLogo"]["vis"] && !_hasOtherLogo) {
					_hasOtherLogo = true;
					(Context.getContext(ContextEnum.PLUGIN_MANAGER) as PluginManager).getPlugin(PluginEnum.PLAYER_OTHER_LOGO);
				}
				
				if (_rightDic["fullScreen"]["vis"]) {
					_fullScreen = skinManager.attachSkinByName(SkinsEnum.FULL_SCREEN, _right, 0);
					_fullScreen.display.name = "fullScreen";
				}
				
				if (uiModule[FileCustomerDataRetriver.M2] && _rightDic["logo"]["vis"]) {
					_logo = skinManager.attachSkinByName(SkinsEnum.LOGO, _right, 0);
					_logo.display.name = "logo";
				}
			}
		}
		/**
		 * 供外部调用，添加站外logo
		 * @param item
		 * 
		 */		
		public function addOtherLogo(item:DisplayObject):void {
			_otherLogo = item;
			_otherLogo.name = "otherLogo";
			if (!_right.getChildByName("otherLogo")) {
				//判断right中是否存在合作方logo，由于引用不一样不能使用contains判断
				_right.addChildAt(_otherLogo, 0);
				resize(false);
			}
		}
		
		override public function resize(flage:Boolean = true):void {
			refresh();
			if (flage) {
				resetChild();
				rightAddChilden();
			}
			var w:Number = Context.stage.stageWidth;
			//底部progressbar
			if (_bg && contains(_bg)) {
				_bg.graphics.clear();
				_bg.graphics.beginFill(0x303030);
				_bg.graphics.drawRect(0, 0, w, height);
				_bg.graphics.endFill();
			}
			var d:DisplayObject = null;
			var i:int = 0;
			var tmp:int = 10;
			for (i; i < _left.numChildren; i ++) {
				d = _left.getChildAt(i);
				if (d) {
					d.x = tmp;
					d.y = (height + _progressBar.display.height - d.height) / 2;
					tmp += d.width + 10;
				}
			}
			tmp = 0;
			var rightW:Number = 0;
			for (i = 0; i < _right.numChildren; i ++) {
				d = _right.getChildAt(i);
				if (d) {
					d.x = w - d.width - int(_rightDic[d.name]["right"]) - tmp;
					d.y = (height + _progressBar.display.height - d.height) / 2;
					tmp += d.width + int(_rightDic[d.name]["right"]);
					rightW += d.width; 
				}
			}
//			var offset:Number = _left.width > rightW ? _left.width : rightW;
			var centerW:Number = _bg.width - (_right.width + _left.width + 20); //10是因为left和right有10像素的保留
			var centerX:Number = _left.width + 10;
			if (_center.x != centerX) {
				_center.x = centerX;
			}
			if (_center.width != centerW) {
				_center.graphics.clear();
				_center.graphics.beginFill(0, 0);
				_center.graphics.drawRect(0, 0, centerW, height);
				_center.graphics.endFill();
			}
			if (_A4) {
				if (centerW < _A4.width) {
					_A4.display.visible = false;
				} else {
					_A4.display.visible = true;
					_A4.resize(centerW, _center.height);
					_A4.display.x = (centerW - _A4.width) / 2;
					_A4.display.y = (_center.height - _A4.height + _progressBar.display.height) / 2;
				}
			}
			if (_A5) {
				_A5.display.x = _bg.width - 5 - _A5.width;
				_A5.display.y = -_A5.height - 4;
			}
			//进度条
			super.resizeProgressBar();
		}
		
		/**
		 * 由于outLogo组件可能加载的图片比较实际显示的大，在外层算宽度的时候会取到实际宽度，因此返回当前可用区域大小
		 */		
		override public function get width():Number {
			return Context.stage.stageWidth;
		}
		
		/**
		 * 根据当前宽度判断组件是否要显示
		 */			
		private function resetChild():void {
			var w:Number = Context.stage.stageWidth;
			var skinManager:SkinManager = Context.getContext(ContextEnum.SKIN_MANAGER) as SkinManager;
			if (w < PlayerScope.PLAYER_WIDTH_1) {
				_rightDic["otherLogo"]["vis"] = false;
				_rightDic["logo"]["vis"] = true;
				_rightDic["fullScreen"]["vis"] = true;
				_rightDic["volume"]["vis"] = true;
				_rightDic["def"]["vis"] = true;
			} else {
				_rightDic["otherLogo"]["vis"] = true;
				_rightDic["logo"]["vis"] = true;
				_rightDic["fullScreen"]["vis"] = true;
				_rightDic["volume"]["vis"] = true;
				_rightDic["def"]["vis"] = true;
			}
			if (w < PlayerScope.PLAYER_WIDTH_2) {
				_rightDic["otherLogo"]["vis"] = false;
				_rightDic["logo"]["vis"] = true;
				_rightDic["fullScreen"]["vis"] = true;
				_rightDic["volume"]["vis"] = false;
				_rightDic["def"]["vis"] = true;
			}
			if (w < PlayerScope.PLAYER_WIDTH_3) {
				_rightDic["otherLogo"]["vis"] = false;
				_rightDic["logo"]["vis"] = true;
				_rightDic["fullScreen"]["vis"] = true;
				_rightDic["volume"]["vis"] = false;
				_rightDic["def"]["vis"] = false;
			}
			if (w < PlayerScope.PLAYER_WIDTH_4) {
				_rightDic["otherLogo"]["vis"] = false;
				_rightDic["logo"]["vis"] = false;
				_rightDic["fullScreen"]["vis"] = false;
				_rightDic["volume"]["vis"] = false;
				_rightDic["def"]["vis"] = false;
			}
		}
		
	}
}