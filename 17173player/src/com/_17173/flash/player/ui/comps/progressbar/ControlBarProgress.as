package com._17173.flash.player.ui.comps.progressbar
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.skin.ISkinObjectListener;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.SkinEvents;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	
	/**
	 * 其实有俩条,大条鼠标移入加入显示列表,小条一直存在. 
	 * @author shunia-17173
	 */	
	public class ControlBarProgress extends Sprite implements ISkinObjectListener
	{
		
		private static const BAR_HEIGHT:int = 5;
		
		protected var _currentHeight:int = 5;
		
		protected var _track:Sprite = null;
		protected var _anchor:DisplayObject = null;
		//当前已经播放的进度
		protected var _fill:Shape = null;
		//当前已经加载了的进度
		protected var _loaded:Shape = null;
		
		protected var _tip:ControlBarProgressTip = null;
		protected var _leftBtn:DisplayObject = null;
		private var _rightBtn:DisplayObject = null;
		
		private var _loadProgress:Number = 0;
		protected var _playProgress:Number = 0;
		
		protected var _mouseOn:Boolean = false;
		
		protected var _offset:Number = 0;
		
		private var _xbyClick:Number = 20;
		
		protected var _mouseStartX:Number = 0;
		
		protected var _mouseDragFlag:Boolean = false;//进度条拖拽标志
		
		protected var _moveAnchorByClickFlag:Boolean = false;
		
		public function ControlBarProgress()
		{
			super();
			_track = new Sprite();
			_track.buttonMode = true;
			_track.useHandCursor = true;
			addChild(_track);
			
			_anchor = anchor;
			addChild(_anchor);
			
			_loaded = new Shape();
			_track.addChild(_loaded);
			_fill = new Shape();
			_track.addChild(_fill);
			
			_leftBtn = leftBtn;
			addChild(_leftBtn);
			
			_rightBtn = rightBtn;
			addChild(_rightBtn);
			
			resize();
			addListeners();
			
			visible = false;
			
		}
		
		protected function get anchor():DisplayObject {
			var temp:Sprite = new Sprite();
			temp.graphics.beginFill(0xFFFFFF, 1);
			temp.graphics.drawCircle(0, 0, BAR_HEIGHT);
			temp.graphics.endFill();
			temp.buttonMode = true;
			temp.useHandCursor = true;
			return temp;
		}
		
		protected function get leftBtn():DisplayObject {
			return new mc_progressbar_left();
		}
		
		protected function get rightBtn():DisplayObject {
			return new mc_progressbar_right();
		}
		
		private function addListeners():void {
			Context.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
			Context.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			Context.stage.addEventListener(MouseEvent.MOUSE_MOVE, onAnchorMove);
			
			_anchor.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			_anchor.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			_anchor.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
//			_track.addEventListener(MouseEvent.CLICK, onClick);
			_track.addEventListener(MouseEvent.MOUSE_DOWN, trackMouseDown);
			_track.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			_track.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			_track.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			
			_leftBtn.addEventListener(MouseEvent.CLICK, leftClick);
			_rightBtn.addEventListener(MouseEvent.CLICK, rightClick);
			
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.BI_PLAYER_INITED, onInit);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.VIDEO_INIT, startUpdate);
//			Global.eventManager.listen(PlayerEvents.BI_PLAYER_INITED, onInit);
//			Global.eventManager.listen(PlayerEvents.VIDEO_INIT, startUpdate);
		}
		
		private function startUpdate(data:Object):void {
			Ticker.tick(1, update, 0, true);
		}
		
		private function onInit(data:Object):void {
			visible = true;
		}
		
		private function update():void {
//			if (Global.videoData) {
//				var played:Number = Global.videoData.playedTime;
//				var total:Number = Global.videoData.totalTime;
			if (Context.getContext(ContextEnum.VIDEO_MANAGER) && (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data) {
				var played:Number = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.playedTime;
				var total:Number = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.totalTime;
				played = played > total ? total : played;
				if (total == 0) {
					_playProgress = 0;
				} else {
					_playProgress = played / total;
				}
				moveAnchor();
				
//				var totalToLoad:Number = Global.videoData.totalBytes;
				var totalToLoad:Number = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.totalBytes;
				if (totalToLoad > 0) {
//					var loaded:Number = Global.videoData.loadedBytes;
					var loaded:Number = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.loadedBytes;
					_loadProgress = loaded / totalToLoad;
					//由于理论数据和真实数据会有差异，因此能导致loaded大于totalToLoad
					if(_loadProgress > 1)
					{
						_loadProgress = 1;
					}
				}
				drawFill();
				drawloaded();
			}
		}
		
		/**
		 * 全屏变化时，需要更新进度条位置
		 */
		protected function onFullScreen(event:FullScreenEvent):void {
			resize();
		}
		
		protected function onRollOver(event:MouseEvent):void {
			onMove(event);
		}
		
		protected function onRollOut(event:MouseEvent):void {
			if (_tip && contains(_tip)) {
				removeChild(_tip);
			}
		}
		
		protected function trackMouseDown(event:MouseEvent):void {
			_moveAnchorByClickFlag = true;
		}
		
		protected function onMouseDown(event:MouseEvent):void {
			_mouseDragFlag = true;
			_mouseStartX = this.mouseX;
		}
		
		protected function onAnchorMove(event:MouseEvent):void {
			if(!_mouseDragFlag)
			{
				return;
			}
			_anchor.x += this.mouseX - _mouseStartX;
			if (_anchor.x < (_offset + _anchor.width / 2))
			{
				_anchor.x = _offset + _anchor.width / 2;
			}
			else if (_anchor.x > (Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoWidth - _offset - _anchor.width / 2))
			{
				_anchor.x = Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoWidth - _offset - _anchor.width / 2;
			}
//			else if (_anchor.x > (Global.uiManager.avalibleVideoWidth - _offset - _anchor.width / 2))
//			{
//				_anchor.x = Global.uiManager.avalibleVideoWidth - _offset - _anchor.width / 2;
//			}
			onMove(event);
			_mouseStartX = _anchor.x;
		}
		
		protected function onMouseUp(event:MouseEvent):void {
			var vd:IVideoManager = Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager;
			if(_mouseDragFlag)
			{
				_mouseDragFlag = false;
//				Global.videoManager.seek(Math.floor(Global.videoData.totalTime * (_tip.x - _anchor.width / 2 - _offset) / (getTrackWidth() - _anchor.width)));
				vd.seek(Math.floor(vd.data.totalTime * (_tip.x - _anchor.width / 2 - _offset) / (getTrackWidth() - _anchor.width)));
				_anchor.removeEventListener(MouseEvent.MOUSE_MOVE, onAnchorMove);
			}
			if(_moveAnchorByClickFlag)
			{
//				Global.videoManager.seek(Math.floor(Global.videoData.totalTime * (_tip.x - _anchor.width / 2 - _offset) / (getTrackWidth() - _anchor.width)));
				vd.seek(Math.floor(vd.data.totalTime * (_tip.x - _anchor.width / 2 - _offset) / (getTrackWidth() - _anchor.width)));
				_moveAnchorByClickFlag = false;
			}
		}
		
		protected function onMove(e:MouseEvent):void {
			if ((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data == null) return;
			if (e.target == _tip) {
				onRollOut(e);
				return;
			}
			if (_tip == null) {
				_tip = new ControlBarProgressTip();
			}
			addChild(_tip);
			var seekTime:Number = 0;
			if (e.target == _anchor || _mouseDragFlag) {
				_tip.x = _anchor.x;
				_tip.y = -_anchor.height / 2 - 15;
//				seekTime = Math.floor(Global.videoData.totalTime * (_anchor.x - _anchor.width / 2 - _offset) / ((getTrackWidth() - _anchor.width)));
				seekTime = Math.floor((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.totalTime * (_anchor.x - _anchor.width / 2 - _offset) / ((getTrackWidth() - _anchor.width)));
			} else {
				_tip.x = e.localX + _offset;
				_tip.y = e.target.y - 15;
//				seekTime = Math.floor(Global.videoData.totalTime * (e.localX) / getTrackWidth());
				seekTime = Math.floor((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.totalTime * (e.localX) / getTrackWidth());
			}
//			if(Global.videoData)
			if((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data)
			{
				_tip.time = seekTime;
			}
			else
			{
				_tip.time = 0;
			}
		}
		
		private function leftClick(evt:MouseEvent):void
		{
//			Global.videoManager.seek(Global.videoData.playedTime - 10);
			(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).seek((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.playedTime - 10);
		}
		
		private function rightClick(evt:MouseEvent):void
		{
//			Global.videoManager.seek(Global.videoData.playedTime + 10);
			(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).seek((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.playedTime + 10);
		}
		
		public function resize():void {
			if (_tip && contains(_tip) && _tip.x > Context.stage.stageWidth) {
				//在全屏状态下，seek后，马上缩小全屏，会出现tip的位置留在全屏的x位置，所以加一个判断
				removeChild(_tip);
			}
			showBtn();
			update();
			drawTrack();
			drawFill();
			drawloaded();
			moveAnchor();
			
			_anchor.y = _currentHeight / 2;
		}
		
		public function show():void {
			
		}
		
		public function hide():void {
			
		}
		
		private function showBtn():void
		{
			if (this.contains(_leftBtn))
			{
				if(!_mouseOn)
				{
					removeChild(_leftBtn);
					removeChild(_rightBtn);
				}
				else
				{
					//全屏的时候会出现这个逻辑
					_rightBtn.x = Context.stage.stageWidth - _rightBtn.width;
					_rightBtn.y = 0;
				}
			}
			else
			{
				if(_mouseOn)
				{
					addChildAt(_leftBtn, numChildren - 1);
					addChildAt(_rightBtn, numChildren - 1);
					_leftBtn.x = 0;
					_leftBtn.y = 0;
					_rightBtn.x = Context.stage.stageWidth - _rightBtn.width;
					_rightBtn.y = 0;
				}
			}
		}
		
		protected function drawTrack():void {
			_track.graphics.clear();
			_track.graphics.beginFill(0x474747, 1);
			_track.graphics.drawRect(0, 0, getTrackWidth(), _currentHeight);
			_track.graphics.endFill();
			if (_mouseOn)
			{
				_track.x = _leftBtn.width;
			}
			else
			{
				_track.x = 0;
			}
		}
		
		protected function drawFill():void {
			_fill.graphics.clear();
			_fill.graphics.beginFill(0xFCCD01);
			_fill.graphics.drawRect(0, 0, _anchor.x - _offset, _currentHeight);
			_fill.graphics.endFill();
		}
		
		protected function drawloaded():void
		{
			_loaded.graphics.clear();
			_loaded.graphics.beginFill(0x757575);
			_loaded.graphics.drawRect(0, 0, fillWidth, _currentHeight);
			_loaded.graphics.endFill();
		}
		
		protected function moveAnchor():void {
			if(!_mouseDragFlag && !_moveAnchorByClickFlag)
			{
				if (anchorPos <= 5) {
					_anchor.x = 5;
				} else {
					_anchor.x = anchorPos;
				}
			}
		}
		
		private function moveAnchorByNumber(value:Number):void
		{
			_anchor.x = value;
			drawFill();
		}
		
		protected function setProgressBarState(value:Boolean):void
		{
//			if(Global.videoManager && Global.videoManager.isFinished)
			if(Context.getContext(ContextEnum.VIDEO_MANAGER) && (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).isFinished)
			{
				return;
			}
			_mouseOn = value;
			if(_mouseOn)
			{
				_currentHeight = 8;
				_offset = 13;
				y = -3;
			}
			else
			{
				_currentHeight = 5;
				_offset = 0;
				y = 0;
			}
			resize();
		}
		
		/**
		 * 进度条偏移量，如果进度条中小圆点高于进度条宽度需要计算这个宽度，否则为0
		 */		
		public function get yOffset():int {
			return 0;
		}
		
		protected function get fillWidth():Number {
			return _loadProgress * getTrackWidth();
		}
		
		protected function get anchorPos():Number {
			//_offset标识_track.x
			return _offset + _playProgress * (getTrackWidth() - _anchor.width + _anchor.width / 2);
		}
		
		protected function getTrackWidth():Number
		{
			return Context.stage.stageWidth - (_offset * 2);
			
		}
		
		override public function get height():Number {
			return BAR_HEIGHT;
		}
		
		public function listen(event:String, data:Object):void {
			switch (event) {
				case SkinEvents.SHOW_FLOW : 
					setProgressBarState(true);
					break;
				case SkinEvents.HIDE_FLOW : 
					setProgressBarState(false);
					break;
				case SkinEvents.RESIZE : 
					resize();
					break;
			}
		}
	}
}