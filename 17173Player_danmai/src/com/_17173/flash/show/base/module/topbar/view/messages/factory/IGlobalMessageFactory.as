package com._17173.flash.show.base.module.topbar.view.messages.factory
{
	import com._17173.flash.show.base.module.topbar.view.messages.base.IGlobalMessageShow;

	public interface IGlobalMessageFactory
	{
		function getMessageByType(data:Object):IGlobalMessageShow;
		
		function returnMessage(msg:IGlobalMessageShow):void;
	}
}