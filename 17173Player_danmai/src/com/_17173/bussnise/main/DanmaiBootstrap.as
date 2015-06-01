package com._17173.bussnise.main
{
	import com._17173.flash.show.base.module.preloader.Preloader2;
	import com._17173.framework.core.manager.ApplicationBootstrapManager;

	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 22, 2014 10:01:41 AM
	 */
	public class DanmaiBootstrap extends ApplicationBootstrapManager
	{
		public function DanmaiBootstrap()
		{
			super();
		}
		/**
		 *  
		 * @return 
		 * 
		 */		
		override protected function info():Object
		{
			return {preloader: Preloader2};
		}
	}
}