package com._17173.flash.player.ui.comps.progressbar
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class ControlBarProgressSeoVideo extends ControlBarProgress
	{
		/**
		 * anchor的透明边框宽度
		 */		
		private var _ballBorderWidth:int = 3;
		
		public function ControlBarProgressSeoVideo()
		{
			_currentHeight = 10;
			super();
		}
		
		override protected function get anchor():DisplayObject {
			return new mc_ball_seo_video();
		}
		
		override protected function get leftBtn():DisplayObject {
			return new mc_progressbar_left_seo_video();
		}
		
		override protected function get rightBtn():DisplayObject {
			return new mc_progressbar_right_seo_video();
		}
		
		override public function resize():void {
			super.resize();
			_anchor.y =  -(_anchor.height - _currentHeight) / 2;
		}
		
		override protected function drawTrack():void {
			_track.graphics.clear();
			_track.graphics.beginFill(0x474747, 1);
//			_track.graphics.beginFill(0xff00ff, 1);
			_track.graphics.drawRect(0, 0, getTrackWidth(), _currentHeight);
			_track.graphics.endFill();
			if (_mouseOn)
			{
				_track.x = _leftBtn.width + 7;
			}
			else
			{
				_track.x = 0;
			}
		}
		
		override protected function drawFill():void {
			_fill.graphics.clear();
			_fill.graphics.beginFill(0xd83727);
			var temp:Number = _anchor.x - _offset;
			_fill.graphics.drawRect(0, 0, temp > -2 ? temp + _ballBorderWidth : 0, _currentHeight);
			_fill.graphics.endFill();
		}
		
		override protected function drawloaded():void
		{
			_loaded.graphics.clear();
			_loaded.graphics.beginFill(0x999999);
			_loaded.graphics.drawRect(0, 0, fillWidth, _currentHeight);
			_loaded.graphics.endFill();
		}
		
		override protected function moveAnchor():void {
			if(!_mouseDragFlag && !_moveAnchorByClickFlag)
			{
				if (anchorPos <= 1) {
					_anchor.x = -_ballBorderWidth;
				} else {
					_anchor.x = anchorPos - _ballBorderWidth;
				}
			}
		}
		
		override protected function onAnchorMove(event:MouseEvent):void {
			if(!_mouseDragFlag)
			{
				return;
			}
			//由于使用了movieClipe所以需要减去一般的按钮的宽度
			_anchor.x += this.mouseX - _mouseStartX - _anchor.width / 2;
			if (_anchor.x < (_offset - _ballBorderWidth))
			{
				_anchor.x = _offset - _ballBorderWidth;
			}
			else if (_anchor.x > (Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoWidth - _offset - _anchor.width + _ballBorderWidth))
			{
				_anchor.x = Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoWidth - _offset - _anchor.width + _ballBorderWidth;
			}
			onMove(event);
			_mouseStartX = _anchor.x;
		}
		
		override protected function get anchorPos():Number {
			//_offset标识_track.x
//			trace(getTrackWidth() + "   " + _playProgress + "    " +  (_offset + _playProgress * (getTrackWidth() - _anchor.width + _ballBorderWidth)));
			return _offset + _playProgress * (getTrackWidth() - _anchor.width + _ballBorderWidth);
		}
		
		override protected function onMove(e:MouseEvent):void {
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
				_tip.x = _anchor.x + _anchor.width / 2;
				_tip.y = -_anchor.height / 2 - 15;
				var temp:Number = (_anchor.x  - _offset - _ballBorderWidth) >= 0 ? (_anchor.x  - _offset - _ballBorderWidth) : 0;
				seekTime = Math.floor((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.totalTime * (temp) / ((getTrackWidth() - _anchor.width + _ballBorderWidth)));
			} else {
				_tip.x = e.localX + _offset;
				_tip.y = e.target.y - 15;
				seekTime = Math.floor((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.totalTime * (e.localX) / (getTrackWidth()));
			}
			if (seekTime == 0) {
				seekTime = 1;
			}
			if((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data)
			{
				_tip.time = seekTime;
			}
			else
			{
				_tip.time = 0;
			}
		}
		
		override protected function setProgressBarState(value:Boolean):void
		{
			if(Context.getContext(ContextEnum.VIDEO_MANAGER) && (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).isFinished)
			{
				return;
			}
			_mouseOn = value;
			if(_mouseOn)
			{
				_currentHeight = 10;
				//7为设计给定的间距
				_offset = _leftBtn.width + 7;
				y = -10;
			}
			else
			{
				_currentHeight = 5;
				_offset = 0;
				y = -5;
			}
			resize();
		}
		
		override public function get yOffset():int {
			return -5;
		}
		
		override protected function onMouseUp(event:MouseEvent):void {
			if (!_tip) {
				return;
			}
			var vd:IVideoManager = Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager;
//			var temp:Number = (_tip.x  - _offset) >= 0 ? (_tip.x  - _offset) : 0;
			var temp:Number = (_anchor.x  - _offset) >= 0 ? (_anchor.x  - _offset) : 0;
			if(_mouseDragFlag)
			{
				_mouseDragFlag = false;
				if (temp >= vd.data.totalTime ) {
					vd.seek(temp- 2);
				} else {
					vd.seek(Math.floor((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.totalTime * (temp) / ((getTrackWidth() - _anchor.width + _ballBorderWidth))));
				}
				_anchor.removeEventListener(MouseEvent.MOUSE_MOVE, onAnchorMove);
			}
			if(_moveAnchorByClickFlag)
			{
				if (_tip.time >= vd.data.totalTime ) {
					vd.seek(_tip.time - 2);
				} else {
					vd.seek(_tip.time);
				}
				_moveAnchorByClickFlag = false;
			}
		}
		
		
	}
}