package com._17173.flash.player.ui.comps.volume
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.RedirectDataAction;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class VolumeSideSeo extends Sprite
	{
		private var alphaBg:Sprite = null;
		private var _bg:Shape = null;
		private var _fill:Shape = null;
		private var _btn:MovieClip = null;
		private var moveNum:Number = 0;
		private var btnHalfWidth:int;
		private var btnHalfHeight:int;
		
		private var volumeNumber:int;
		private var lastVolumeNumber:int;
		private var lastMoveNumber:int;
		private var _buttonWidth:int = 15;
		private var _e:IEventManager;
		private var _colorBG:int = 0x474747;
		private var _clolorFill:int = 0xfdcd00;
		private var _barWidth:int = 60;
		private var _barHeight:int = 4;
		private var _barBGHeight:int = 23;
		private var _maxHeight:int = 60;
		private var _inited:Boolean = false;
		
		private static const VOLUMENUMBER:int = 50;
		
		public function VolumeSideSeo()
		{
			super();
		}
		
		public function init():void {
			if (_inited) {
				return;
			}
			_inited = true;
			volumeNumber = lastVolumeNumber = Number(Context.getContext(ContextEnum.SETTING).volume);
			_maxHeight = barBGHeight > barHeight ? barBGHeight : barHeight;
			initComp();
			addListens();
			resize();
		}
		
		private function initComp():void {
			_btn = btn;
//			_btn.rotation = 90;
			
			_maxHeight = _btn.height > _maxHeight ? _btn.height : _maxHeight;
			
			alphaBg = new Sprite();
			alphaBg.graphics.beginFill(0x000000, 0);
			alphaBg.graphics.drawRect(0, 0, barWidth, _maxHeight);
			alphaBg.graphics.endFill();
			alphaBg.x = 0;
			alphaBg.y = 0;
			alphaBg.alpha = 0;
			addChild(alphaBg);
			
			_bg = new Shape();
			_bg.graphics.beginFill(colorBG);
			_bg.graphics.drawRect(0, 0, barWidth, barHeight);
			_bg.graphics.endFill();
			_bg.x = 0;
			_bg.y = (_maxHeight - barHeight) / 2;
			addChild(_bg);
			
			_fill = new Shape();
			_fill.y = _bg.y;
			_fill.x = 0;
			addChild(_fill);
			
			btnHalfWidth  = int(_btn.width/2);
			btnHalfHeight  = int(_btn.height/2);
			
			_btn.x = int(volumeNumber * _bg.width /100 - btnHalfWidth);
			_btn.y = getBtnY();
			
			moveNum = lastMoveNumber =_btn.x;
			addChild(_btn);
		}
		
		private function getBtnY():Number {
			if (_btn.height >= _maxHeight) {
				return 0;
			} else {
				return (_maxHeight - _btn.height) / 2 - btnHalfHeight;
			}
		}
		
		protected function get btn():MovieClip {
			return new mc_volume_ball_seo_video();
		}
		
		private function addListens():void {
			_e = (Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager);
			
			_e.listen(PlayerEvents.UI_VOLUME_MUTE,isMute);
			_e.listen(PlayerEvents.UI_CHANGE_VOLUME,setVolume);
			_e.listen(PlayerEvents.VIDEO_START,videoStart);
			
			alphaBg.addEventListener(MouseEvent.CLICK,mouseClick);
			_btn.addEventListener(MouseEvent.MOUSE_DOWN, btnMoseDown);
			_btn.addEventListener(MouseEvent.MOUSE_UP, btnMoseUp);
		}
		
		private function videoStart(data:Object):void{
			volumeNumber = lastVolumeNumber = Number(Context.getContext(ContextEnum.SETTING)["volume"]);
			resize();
		}
		
		private function isMute(data:Object):void
		{
			if(!Boolean(data))
			{
				moveNum = 0 - btnHalfWidth;
				volumeNumber = 0;
			}
			else
			{
				if(lastVolumeNumber <= 0)
				{
					volumeNumber = lastMoveNumber = 50;
					moveNum = lastMoveNumber = int(volumeNumber * _bg.width /100 -btnHalfWidth);
				}
				else
				{
					moveNum = lastMoveNumber;
					volumeNumber = lastVolumeNumber;
				}
				
			}
			_btn.x = moveNum;
			resize();
		}
		private function setVolume(data:Object):void {
			var v:int = int(data);
			if(v <= 0) {
				v = 0;
			}
			if(v >= 100) {
				v = 100;
			}
			
			volumeNumber = lastMoveNumber = v;
			moveNum = lastMoveNumber = int(volumeNumber * _bg.width /100 -btnHalfWidth);
			_btn.x = moveNum;
			resize();
		}
		
		private function setVolumeByMoveNum(number:int):void
		{
			moveNum =lastMoveNumber = number;
			volumeNumber = lastVolumeNumber = int((moveNum + btnHalfWidth)/_bg.width * 100);
			resize();
		}
		
		private function mouseClick(event:MouseEvent):void
		{
			event.stopPropagation();
			_btn.x = event.localX - btnHalfWidth;
			setVolumeByMoveNum(_btn.x);
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_REDIRECT, {"action":RedirectDataAction.ACTION_CLICK_SOUND, "click_type":RedirectDataAction.CLICK_TYPE_NORMAL});
		}
		private function btnMoseDown(evt:MouseEvent):void
		{
			MovieClip(evt.target).startDrag(false,new Rectangle(int(0 -btnHalfWidth) , getBtnY() , _bg.width , 0)); 
			this.removeEventListener(Event.ENTER_FRAME,mouseMoveHandler);
			this.addEventListener(Event.ENTER_FRAME,mouseMoveHandler);
			Context.stage.removeEventListener(MouseEvent.MOUSE_UP,btnMoseUp);
			Context.stage.addEventListener(MouseEvent.MOUSE_UP,btnMoseUp);
		}
		
		public function btnMoseUp(evt:MouseEvent = null):void
		{
			MovieClip(_btn).stopDrag();
			this.removeEventListener(Event.ENTER_FRAME,mouseMoveHandler);
			Context.stage.removeEventListener(MouseEvent.MOUSE_UP,btnMoseUp);
			
			mouseMoveHandler();
			
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_REDIRECT, {"action":RedirectDataAction.ACTION_CLICK_SOUND, "click_type":RedirectDataAction.CLICK_TYPE_NORMAL});
		}
		
		private function mouseMoveHandler(evt:Event = null):void
		{
			if(moveNum == _btn.x)
			{
				return;
			}
			setVolumeByMoveNum(_btn.x);
		}
		
		private function resize():void
		{
			if(_fill && contains(_fill)) {
				_fill.graphics.clear();
				_fill.graphics.beginFill(clolorFill);
				_fill.graphics.drawRect(0, 0,moveNum + btnHalfWidth , barHeight);
				_fill.graphics.endFill();
				
				if(volumeNumber <= 0) {
					volumeNumber = 0;
				}
				if(volumeNumber >= 100) {
					volumeNumber = 100;
				}
				Context.getContext(ContextEnum.SETTING).volume = volumeNumber;
				_e.send(PlayerEvents.UI_VOLUME_CHANGE, volumeNumber);
			}
		}
		
		override public function get height():Number {
			return _btn.height;
		}
		
		public function showBac(value:Boolean):void {
			if (value) {
				alphaBg.alpha = 1;
			} else {
				alphaBg.alpha = 0;
			}
		}
		
		public function get buttonWidth():int
		{
			return _buttonWidth;
		}
		
		public function get colorBG():int
		{
			return _colorBG;
		}
		
		public function set colorBG(value:int):void
		{
			_colorBG = value;
		}
		
		public function get clolorFill():int
		{
			return _clolorFill;
		}
		
		public function set clolorFill(value:int):void
		{
			_clolorFill = value;
		}
		
		public function get barWidth():int
		{
			return _barWidth;
		}
		
		public function set barWidth(value:int):void
		{
			_barWidth = value;
		}
		
		public function get barHeight():int
		{
			return _barHeight;
		}
		
		public function set barHeight(value:int):void
		{
			_barHeight = value;
		}
		
		public function get barBGHeight():int
		{
			return _barBGHeight;
		}
		
		public function set barBGHeight(value:int):void
		{
			_barBGHeight = value;
		}
		
	}
}