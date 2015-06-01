package com._17173.flash.show.base.context.resource
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	
	import avmplus.getQualifiedClassName;

	public class MovieClipResourceData extends BaseResourceData implements IResourceData
	{
		
		public function MovieClipResourceData(source:*,keyStr:String)
		{
			super(source, keyStr);
			isAutoGc = true;
		}
		
		override protected function setupSource(source:*):void{
			var mc:MovieClip = _resource = source;
//			var domain:ApplicationDomain = (_resource.parent as Loader).contentLoaderInfo.applicationDomain;
//			var calssName:String = getQualifiedClassName(mc.getChildAt(0));
//			_prototype = domain.getDefinition(calssName) as Class;
			_resource = source;
//			_resource.mouseChildren = false;
//			_resource.mouseEnabled = false;
//			(source as MovieClip).stop();
		}
		
		override public function get source():*{
			updateUserTime();
			return _resource;
		}
		
		override public function get newSource():*{
			updateUserTime();
//			var mc:MovieClip = new MovieClip();
//			mc.addChild(new _prototype());
//			mc.mouseChildren = false;
//			mc.mouseEnabled = false;
			return _resource;
		}
	}
}