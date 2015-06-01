package com._17173.framework.core.manager
{
	import flash.display.LoaderInfo;
	import flash.display.Stage;

	/**
	 * @author Cray
	 * @version 1.0
	 * @date Oct 21, 2014 9:14:04 AM
	 */
	public interface IAppliactionManager
	{
		function get loaderInfo():LoaderInfo;
		
		function get stage():Stage;
	}
}