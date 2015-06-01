package com._17173.bussnise.main
{	
	import com._17173.framework.components.IApplication;
	import com._17173.manager.authority.IAuthority;
	import com._17173.manager.errorrecord.IErrorRecordManager;
	import com._17173.manager.keyboard.IKeyboardManager;
	import com._17173.manager.layer.IUIManager;
	import com._17173.manager.local.ILocale;
	import com._17173.manager.resource.IResourceManager;
	import com._17173.manager.text.IGraphicTextManager;
	import com._17173.manager.user.IUserManager;
	import com._17173.manager.video.IMicManager;
	import com._17173.module.animation.IAnimationFactory;
	import com._17173.vo.globe.Flashvars;

	/**
	 * @author Cray
	 * @version 1.0
	 * @date Oct 24, 2014 6:23:44 PM
	 */
	public interface IDanmaiApplication extends IApplication
	{
		function getResourceManager():IResourceManager;
		function getAuthority():IAuthority;
		function getMicManager():IMicManager;
		function getKeyboardManager():IKeyboardManager;
		function getUIManager():IUIManager;
		function getGraphicTextManager():IGraphicTextManager;
		function getErrorRecordManger():IErrorRecordManager;
		function getAnimationFactory():IAnimationFactory;
		function getUserManager():IUserManager;
		function getLocal():ILocale;
		
		/** 公共方法 **/
		function getDomainPath():String;
		function getHttpPath(value:String):String;
		function getFlashvars():Flashvars;
	}
}