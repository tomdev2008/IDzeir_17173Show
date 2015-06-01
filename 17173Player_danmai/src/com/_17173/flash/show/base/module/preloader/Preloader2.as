package com._17173.flash.show.base.module.preloader
{
	import com._17173.framework.preloader.IPreloaderSkinnable;
	
	import flash.display.Sprite;
	
	
	/**
	 * @author Cray 
	 * @version 1.0
	 * @date Oct 30, 2014 9:43:08 AM
	 */
	public class Preloader2 extends Sprite implements IPreloaderSkinnable
	{
		private var _mcloadr:preloader_background;
		private var _welcomeTextArray:Array = ["人生值得等的东西不多，不妨多等一等","回眸2014，追忆那些属于我们的离愁感动，朝着笃定的2015启程"];
		public function Preloader2()
		{
			super();
			this.graphics.clear();
			this.graphics.beginFill(0);
			this.graphics.drawRect(0,0,685,520);
			this.graphics.endFill();
			
			_mcloadr = new preloader_background();
			_mcloadr.mouseEnabled = false;
			_mcloadr.mouseChildren = false;
			_mcloadr.cacheAsBitmap = true;
			
			_mcloadr.mc_pro.gotoAndStop(1);
			_mcloadr.x = -(_mcloadr.width>>1);//-385;
			_mcloadr.y = 7;
			
			this.addChild(_mcloadr);
			
			/** 欢迎文字 **/
			var index:int = Math.round(Math.random());
			_mcloadr.txt_title.text = _welcomeTextArray[index];
			_mcloadr.txt_title.mouseEnabled=false;
			_mcloadr.txt_title.selectable=false;
		}
		
		public function setProgress(value:Number):void
		{
			if(value<1)value=1;
			if(value>100)value=100;
			_mcloadr.mc_pro.gotoAndStop(value);
		}
	}
}