package com._17173.flash.show.base.module.video.live
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class LiveVolumeBar extends Sprite
	{
		private var _e:IEventManager = null;
		private var _btn:DisplayObject = null;
		private var moveNum:Number = 0;
		
		private var _volumeNumber:int;
		private var lastVolumeNumber:int;
		private var lastMoveNumber:int;
		
		private static const VOLUMENUMBER:int = 75;
		
		/**
		 * 麦序 
		 */		
		private var _index:int = 1;
		private var _liveVouleBG:LiveVolumeBg = new LiveVolumeBg();
		private var _liveVolumeLine:LiveVolumeLine = new LiveVolumeLine();
		private var _liveVolumeLineBg:LiveVolumeLineBg = new LiveVolumeLineBg();
		
		private var _maxNum:int = 0;
		
		public function LiveVolumeBar(index:int)
		{
			super();
			this._index = index;
			_btn = new VolumeBtn();
			_maxNum = _liveVolumeLineBg.width - _btn.width;
			this.rotation = 270;
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			
			this.addChild(_liveVouleBG);
			_liveVouleBG.width += 20;
			_liveVouleBG.x = -42;
			_liveVouleBG.y = _liveVolumeLineBg.height/2 -_liveVouleBG.height /2;
			
			_liveVolumeLineBg.x = 0;
			_liveVolumeLineBg.y = 0 ;
			this.addChild(_liveVolumeLineBg);
			_liveVolumeLine.x = 0;
			_liveVolumeLine.y = 0;
			this.addChild(_liveVolumeLine);
		
			_volumeNumber = lastVolumeNumber = VOLUMENUMBER;
		
			_btn.x = int(volumeNumber * _maxNum /100);
			_btn.y = Number(-_liveVolumeLineBg.height/2);
			moveNum = lastMoveNumber =_btn.x;
			addChild(_btn);
			init();
			resize();
		}
		
		
		
		public function get volumeNumber():int
		{
			return _volumeNumber;
		}

		private function init():void
		{
//			_liveVouleBG.addEventListener(MouseEvent.CLICK,mouseClick);
			_btn.addEventListener(MouseEvent.MOUSE_DOWN, btnMoseDown);
			_btn.addEventListener(MouseEvent.MOUSE_UP, btnMoseUp);
		}
		
		public function isMute(data:Object):void
		{
			if(!Boolean(data))
			{
				moveNum = 0;
				_volumeNumber = 0;
			}
			else
			{
				if(lastVolumeNumber <= 0)
				{
					_volumeNumber = lastMoveNumber = VOLUMENUMBER;
					moveNum = lastMoveNumber = int(volumeNumber * _maxNum /100);
				}
				else
				{
					moveNum = lastMoveNumber;
					_volumeNumber = lastVolumeNumber;
				}
				
			}
			_btn.x = moveNum;
			resize();
		}
		
		private function setVolumeByMoveNum(number:int):void
		{
			moveNum =lastMoveNumber = number;
			_volumeNumber = lastVolumeNumber = int(moveNum/_maxNum * 100);
			_e.send(SEvents.CHANGE_MUTE_STATE,{"volumeNumber":_volumeNumber, "index":_index});
			resize();
		}
		
		private function mouseClick(event:MouseEvent):void
		{
			event.stopPropagation();
			_btn.x = event.localX;
			setVolumeByMoveNum(_btn.x);
			
		}
		private function btnMoseDown(evt:MouseEvent):void
		{
			evt.stopPropagation();
			Sprite(evt.target).startDrag(false,new Rectangle(0 , int(-_liveVolumeLineBg.height/2) , _maxNum , 0)); 
			this.removeEventListener(Event.ENTER_FRAME,mouseMoveHandler);
			this.addEventListener(Event.ENTER_FRAME,mouseMoveHandler);
			Context.stage.removeEventListener(MouseEvent.MOUSE_UP,btnMoseUp);
			Context.stage.addEventListener(MouseEvent.MOUSE_UP,btnMoseUp);
		}
		
		public function btnMoseUp(evt:MouseEvent = null):void
		{
			Sprite(_btn).stopDrag();
			this.removeEventListener(Event.ENTER_FRAME,mouseMoveHandler);
			Context.stage.removeEventListener(MouseEvent.MOUSE_UP,btnMoseUp);
			mouseMoveHandler();
			
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
			if(_liveVolumeLine && contains(_liveVolumeLine)) {
				_liveVolumeLine.width = moveNum;
				if(volumeNumber <= 0) {
					_volumeNumber = 0;
				}
				if(volumeNumber >= 100) {
					_volumeNumber = 100;
				}
				var obj:Object = new Object();
				obj.index = _index;
				obj.volumeNumber = volumeNumber;
				_e.send(SEvents.ON_LIVE_VOLUME_CHANGE,obj);
			}
		}
	}
}


