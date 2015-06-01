package com._17173.flash.core.context
{
	public interface IContextItem {
		
		function get contextName():String;
		function startUp(param:Object):void;
		
	}
}