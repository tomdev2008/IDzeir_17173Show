package com._17173.framework.preloader
{
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class Preloader extends Sprite 
	{
		
		/**
		 * 进度加载监听器 
		 */	    
		private var _preTimer:Timer;
		
		public function Preloader() 
		{
			
		}
		
		public function initialize():void
		{
			if(!_displayClass)
			{
				var t:TextField = new TextField();
				t.width = 100;
				t.height = 30;
				t.text = "loading......";
				
				addChild(t);
			}
			
			_preTimer = new Timer(10);
			_preTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			_preTimer.start();
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			if (!root)
				return;
			
			var li:LoaderInfo = root.loaderInfo;
			var loaded:int = li.bytesLoaded;
			var total:int = li.bytesTotal;
			if(loaded >= total)
			{			
				_preTimer.stop();
				_preTimer.removeEventListener(TimerEvent.TIMER,timerHandler);
				_preTimer = null;
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
			if(_displayClass)
				_displayClass.setProgress(Math.round(loaded/total)*20);
			else
			    setProgress(loaded,total);
		}
		
		private function setProgress(loaded:uint,total:uint):void 
		{
			var t:TextField = getChildAt(0) as TextField;
			t.text = "load: "+ loaded/1000 + "/" + total/1000;			
		}
		
		private var _displayClass:IPreloaderSkinnable;
		public function set preloader(displayclass:Class):void
		{
			_displayClass = new displayclass();
			this.addChild(_displayClass as DisplayObject);
		}
		
		public function get preloaderIns():IPreloaderSkinnable
		{
			return _displayClass;
		}
	}
}
