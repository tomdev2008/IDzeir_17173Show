package com._17173.flash.show.base.module.animation
{
	import com._17173.flash.show.base.module.animation.base.IAnimactionLayer;
	import com._17173.flash.show.base.module.animation.base.IAnimationPlay;

	public interface IAnimationFactory
	{
		
		function getAmd(apath:String,atype:String,layer:IAnimactionLayer):IAnimationPlay;
		
		function getAmdByPath(url:String):IAnimationPlay;
		
		function returnAmt(amt:IAnimationPlay):void;
	}
	
}