package com._17173.flash.player.ui.comps.controlbar
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.skin.ISkinObjectListener;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.SkinManager;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.SkinEvents;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	import com._17173.flash.player.ui.stream.extra.IExtraUIItem;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * ui界面下方的控制条.包含播放按钮,进度条,音量,清晰度等控件.
	 * @author shunia-17173
	 */
	public class ControlBar extends Sprite implements ISkinObjectListener
	{

		protected var _bg:Shape=null;
		protected var _left:Sprite=null;
		protected var _center:Sprite=null;
		protected var _right:Sprite=null;
		protected var _playBtn:ISkinObject=null;
		protected var _playBtnBig:ISkinObject=null;
		protected var _logo:ISkinObject=null;
		protected var _fullScreen:ISkinObject=null;
		protected var _volumeBar:ISkinObject=null;
		protected var _timeBar:ISkinObject=null;
		protected var _defBtn:ISkinObject=null;
		protected var _progressBar:ISkinObject=null;
		protected var _A4:Object=null;
		protected var _A5:Object=null;
		protected var _isPaused:Boolean=false;
		protected var _userCloseA5:Boolean=false;
		private var _thisMouseEnable:Boolean = true;
		private var _thisMouseChildren:Boolean = true;
		private var _specileMouseStateArr:Array;

		public function ControlBar()
		{
			super();
			initCom();
		}

		protected function initCom():void
		{
			_bg=new Shape();
			addChild(_bg);

			_left=new Sprite();
			_left.name="left";
			addChild(_left);

			_center=new Sprite();
			addChild(_center);

			var skinManager:SkinManager=Context.getContext(ContextEnum.SKIN_MANAGER) as SkinManager;
			var settings:Object = Context.getContext(ContextEnum.SETTING);
			_progressBar = skinManager.attachSkinByName(SkinsEnum.PROGRESS_BAR, this);
			_right=new Sprite();
			_right.name="right";
			addChild(_right);

			_playBtn = skinManager.attachSkinByName(SkinsEnum.PLAY_AND_PAUSE, _left);
			_timeBar = skinManager.attachSkinByName(SkinsEnum.TIMER, _left);
			_logo = skinManager.attachSkinByName(SkinsEnum.LOGO, _right);
			_fullScreen = skinManager.attachSkinByName(SkinsEnum.FULL_SCREEN, _right);
			_volumeBar = skinManager.attachSkinByName(SkinsEnum.VOLUME, _right);
			if (Number(settings.volume) <= 0)
			{
				_volumeBar.set("isMute", true);
			}
			else
			{
				_volumeBar.set("volume", Number(settings.volume));
			}
			_defBtn=skinManager.attachSkinByName(SkinsEnum.DEFINITION, _right);

			_playBtnBig=skinManager.attachSkinByName(SkinsEnum.PLAY_AND_PAUSE_BIG, this);
			_playBtnBig.display.x=4;
			_playBtnBig.display.y=-_playBtnBig.display.height - 15;
			_playBtnBig.display.visible=false;

			init();
		}

		protected function init():void
		{
			_volumeBar.listen("mute", onMute);
			_volumeBar.listen("volumeChanged", onVolumeChange);

			var eventManager:EventManager=Context.getContext(ContextEnum.EVENT_MANAGER) as EventManager;
			eventManager.listen(PlayerEvents.VIDEO_PAUSE, onPause);
			eventManager.listen(PlayerEvents.VIDEO_RESUME, onResume);
//			eventManager.listen(PlayerEvents.VIDEO_INIT, videInit);
			eventManager.listen(PlayerEvents.BI_AD_SHOW_A4, onShowA4);
			eventManager.listen(PlayerEvents.BI_AD_SHOW_A5, onShowA5);
			eventManager.listen(PlayerEvents.REINIT_VIDEO, reInitVideo);
			eventManager.listen(PlayerEvents.VIDEO_FINISHED, onVideoFinished);
			eventManager.listen(PlayerEvents.UI_SPECIL_COMP_ENABLE, specilCompEnable);
			eventManager.listen(PlayerEvents.UI_HIDE_BACK_RECOMMAND, reshowAD);
		}
		
		protected function onShowA4(data:Object):void {
			_A4 = data;
			_A4.addEventListener("onAdError", onAdA4Error);
			if (_A4) {
				_center.addChild(_A4.display);
				resize();
			}
		}
		
		private function onAdA4Error(data:Object):void {
			if (_A4 && _center.contains(_A4.display)) {
				_center.removeChild(_A4.display);
				resize();
			}
		}
		
		protected function onShowA5(data:Object):void {
			_A5 = data;
			_A5.addEventListener("onAdError", onAdA5Error);
			if(!_isPaused && !_userCloseA5)
			{
				//由于有时候设置播放器播放的事件会比传递a5的事件先到，所以这里判断如果现在是播放情况，并且用户没手动关闭，就添加
				addA5();
			}
		}
		
		/**
		 * 用于视频播放结束，显示后推后，再重新播放显示挂角广告（用户没点关闭）
		 */		
		protected function reshowAD(data:Object):void {
			if (!_userCloseA5 && _A5 && contains(_A5.display) && !_A5.display.visible) {
				_A5.display.visible = true;
			}
		}
		
		private function onAdA5Error(data:Object):void {
			if (_A5 && contains(_A5.display)) {
				removeChild(_A5.display)
				resize();
			}
		}
		
		protected function onVolumeChange(e:Event):void {
			var v:Number = _volumeBar.get("isMute") ? 0 : _volumeBar.get("volume");
//			Global.eventManager.send(PlayerEvents.UI_VOLUME_CHANGE, v);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_VOLUME_CHANGE, v);
		}

		protected function onMute(e:Event):void
		{
			var v:Boolean=_volumeBar.get("isMute");
			var lastV:Number=v ? 0 : _volumeBar.get("lastVolume");
//			Global.eventManager.send(PlayerEvents.UI_VOLUME_MUTE, lastV);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_VOLUME_CHANGE, v);
		}

		protected function onPause(data:Object):void
		{
			_isPaused=true;
		}

//		protected function videInit(data:Object):void
//		{
//			_userCloseA5=false;
//		}

		protected function onResume(data:Object):void
		{
			_isPaused=false;
			addA5();
		}

		protected function addA5():void
		{
			if (_A5 && !contains(_A5.display) && !_userCloseA5)
			{
				_A5.display.addEventListener("close", closeA5);
				addChildAt(_A5.display, 1);
				resize();
			}
		}

		/**
		 * 关闭挂角广告
		 */
		protected function closeA5(evt:Event):void
		{
			if (_A5 && contains(_A5.display))
			{
				_userCloseA5 = true;
				removeChild(_A5.display);
			}
		}

		protected function onTogglePlay(event:Event):void
		{
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_PLAY_OR_PAUSE, !(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).isPlaying);
			
			if ((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).isFinished)
			{
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.REPLAY_THE_VIDEO);
			}
//			Global.eventManager.send(PlayerEvents.UI_PLAY_OR_PAUSE, !Global.videoManager.isPlaying);
//
//			if (Global.videoManager.isFinished)
//			{
//				Global.eventManager.send(PlayerEvents.REPLAY_THE_VIDEO);
//			}
		}

		public function update(time:int):void
		{
//			if (Global.videoManager && Global.videoData)
			if (Context.getContext(ContextEnum.VIDEO_MANAGER) && (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data)
			{
				_progressBar.call("update");
			}
		}

		public function refresh():void
		{
//			if (Global.videoManager && Global.videoManager.isPlaying)
			if (Context.getContext(ContextEnum.VIDEO_MANAGER) && (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).isPlaying)
			{
				setPalyState();
			}
		}

		private function setPalyState():void
		{
//			_fullScreen.set("isFullScreen", Global.settings.isFullScreen);
			_fullScreen.set("isFullScreen", Context.getContext(ContextEnum.SETTING).isFullScreen);
		}



		public function resize(flage:Boolean=true):void
		{
			refresh();
			//底部progressbar
			if (_bg && contains(_bg))
			{
				_bg.graphics.clear();
				_bg.graphics.beginFill(0x303030);
				_bg.graphics.drawRect(0, 0, Context.stage.stageWidth, height);
				_bg.graphics.endFill();
			}
			
			leftResize();
			
			rightResize();
			
//			var offset:Number = _left.width > _right.width ? _left.width : _right.width;
			var centerW:Number = _bg.width - (_right.width + _left.width + 20); //10是因为left和right有10像素的保留
			var centerX:Number = _left.width + 10;
			if (_center.x != centerX)
			{
				_center.x = centerX;
			}
			if (_center.width != centerW)
			{
				_center.graphics.clear();
				_center.graphics.beginFill(0, 0);
				_center.graphics.drawRect(0, 0, centerW, height);
				_center.graphics.endFill();
			}
			if (_A4)
			{
				if (centerW < _A4.width)
				{
					_A4.display.visible=false;
				}
				else
				{
					_A4.display.visible = true;
					_A4.resize(centerW, _center.height);
					_A4.display.x = (centerW - _A4.width) / 2;
					_A4.display.y = (height - _A4.height + _progressBar.display.height) / 2;
				}
			}
			if (_A5)
			{
				_A5.display.x=_bg.width - 5 - _A5.width;
				_A5.display.y=-_A5.height - 4;
			}
			//进度条
			resizeProgressBar();
			setMouseEnable();
		}
		
		/**
		 * 刷新left内部布局
		 */		
		protected function leftResize():void {
			var d:DisplayObject=null;
			var i:int=0;
			var tmp:int=10;
			for (i; i < _left.numChildren; i++)
			{
				d=_left.getChildAt(i);
				if (d)
				{
					//刷新自己内部布局
					if(d is IExtraUIItem){
						(d as IExtraUIItem).refresh(Context.getContext(ContextEnum.SETTING).isFullScreen);
					}
					d.x=tmp;
					d.y=(height + _progressBar.display.height - d.height) / 2;
					tmp+=d.width + 5;
				}
			}
		}
		
		/**
		 * 刷新right内部布局
		 */
		protected function rightResize():void {
			var d:DisplayObject=null;
			var i:int=0;
			var tmp:int=10;
			for (i; i < _right.numChildren; i++)
			{
				d=_right.getChildAt(i);
				if (d)
				{
					//刷新自己内部布局
					if(d is IExtraUIItem){
						(d as IExtraUIItem).refresh(Context.getContext(ContextEnum.SETTING).isFullScreen);
					}
					d.x=_bg.width - tmp - d.width;
					d.y=(height + _progressBar.display.height - d.height) / 2;
					tmp+=d.width + 5;
				}
			}
		}

		public function resizeProgressBar():void
		{
			_progressBar.call("resize");
			_progressBar.display.x = 0;
//			_progressBar.display.y = 0;//坐标为整个进图条
			_progressBar.display.y = _progressBar.get("yOffset");//y坐标为偏移量，由进度条内部返回
		}
		
		/**
		 *移除自相 
		 * @param item
		 * @param posi
		 * 
		 */		
		public function removeItem(item:IExtraUIItem):void{
			var dis:DisplayObject=item as DisplayObject;
			if (item.side == ExtraUIItemEnum.SIDE_LEFT)
			{
				if (_left.contains(dis))
				{
					_left.removeChild(dis);
				}
			}
			else 
			{
				if (_right.contains(dis))
				{
					_right.removeChild(dis);
				}
			}
			resize();
		}

		public function addItem(item:IExtraUIItem):void
		{
			var dis:DisplayObject=item as DisplayObject;
			if (item.side == ExtraUIItemEnum.SIDE_LEFT)
			{
				_left.addChild(dis);
			}
			else
			{
				_right.addChild(dis);
			}
			resize();
		}

		override public function get height():Number
		{
			return _("controlBarHeight") + _progressBar.display.height;
		}

		override public function get width():Number
		{
			return Context.stage.stageWidth;
		}

		protected function onVideoFinished(data:Object=null):void
		{
			if (_A5 && contains(_A5.display))
			{
				_A5.display.visible = false;
			}
		}

		protected function reInitVideo(data:Object):void
		{
			_progressBar.display.visible=false;
			_playBtnBig.display.visible=false;
		}

		public function listen(event:String, data:Object):void
		{
			switch (event)
			{
				case SkinEvents.RESIZE:
					resize();
					break;
				case SkinEvents.REFRESH:
					refresh();
					break;
			}
		}
		
		public function setMouseEnable():void {
			this.mouseChildren = _thisMouseChildren;
			this.mouseEnabled = _thisMouseEnable;
		}
		
		override public function set mouseEnabled(enabled:Boolean):void {
			_thisMouseEnable = enabled;
			_left.mouseEnabled = enabled;
			_center.mouseEnabled = enabled;
			for (var i:int = 0; i < _right.numChildren; i++) {
				if (_right.getChildAt(i) is IExtraUIItem) {
					if (_right.getChildAt(i).hasOwnProperty("mouseUse")) {
						(_right.getChildAt(i) as Object).mouseUse = enabled;
					}
				}
				var item:Sprite = _right.getChildAt(i) as Sprite;
				if (item) {
					item.mouseEnabled = enabled;
				}
			}
			if (_specileMouseStateArr && _specileMouseStateArr.length > 0) {
				doSpecileMouseState();
			}
		}
		
		override public function set mouseChildren(enable:Boolean):void {
			_thisMouseChildren = enable;
			_left.mouseChildren = enable;
			_center.mouseChildren = enable;
			for (var i:int = 0; i < _right.numChildren; i++) {
				var item:Sprite = _right.getChildAt(i) as Sprite;
				if (item) {
					item.mouseChildren = enable;
				}
			}
		}
		
		/**
		 * 
		 */		
		private function doSpecileMouseState():void {
			if (_specileMouseStateArr.length > 0) {
				if (_specileMouseStateArr.indexOf(ExtraUIItemEnum.UI_SPECILE_ENABLE_VOLUME) != -1) {
					(_volumeBar.display as Sprite).mouseEnabled = true;
					(_volumeBar.display as Sprite).mouseChildren = true;
				}
				if (_specileMouseStateArr.indexOf(ExtraUIItemEnum.UI_SPECILE_ENABLE_FULL) != -1) {
					(_fullScreen.display as Sprite).mouseEnabled = true;
					(_fullScreen.display as Sprite).mouseChildren = true;
				}
			}
		}
		
		/**
		 * 记录注册过来的特殊标记
		 * 暂时只有声音和全屏
		 */		
		private function specilCompEnable(value:Object):void {
			if (!_specileMouseStateArr) {
				_specileMouseStateArr = value as Array;
			} else {
				var temp:Array = value as Array;
				if (temp) {
					for (var i:int = 0; i < temp.length; i++) {
						if (_specileMouseStateArr.indexOf(temp[i]) == -1) {
							_specileMouseStateArr.push(temp[i]);
						}
					}
				}
			}
		}
		
	}
}
