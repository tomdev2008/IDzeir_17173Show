package com._17173.flash.core.net.moniter
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.utils.getTimer;

	public class NetStatusMoniter
	{
		
		private static var _infos:Object = {};
		
		public static function moniter(name:String, target:*):void {
			if (!_infos.hasOwnProperty(name)) {
				if (target is Loader) {
					target = Loader(target).contentLoaderInfo;
				}
				if (target is LoaderInfo || target is URLLoader) {
					var monitor:Object = {"loader":target};
					_infos[name] = monitor;
					var init:Function = function (e:Event):void {
						monitor.start = getTimer();
					};
					var progress:Function = function (e:ProgressEvent):void {
						
					};
					var complete:Function = function (e:Event):void {
						monitor.complete = getTimer();
					};
					
					target.addEventListener(Event.INIT, init);
					target.addEventListener(ProgressEvent.PROGRESS, progress);
					target.addEventListener(Event.COMPLETE, complete);
				}
			}
		}
		
		public static function getMoniterInfo(name:String):Object {
			return null;
		}
		
	}
}