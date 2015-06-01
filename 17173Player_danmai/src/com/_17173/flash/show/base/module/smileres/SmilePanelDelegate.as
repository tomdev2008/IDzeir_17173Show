package com._17173.flash.show.base.module.smileres
{
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEvents;

	/** 
	 * @author idzeir
	 * 创建时间：2014-2-20  下午7:52:22
	 */
	public class SmilePanelDelegate extends BaseModuleDelegate
	{

		//private var iSmileres:ISmileres;
		
		public function SmilePanelDelegate()
		{
			super();	
			this._e.listen(SEvents.APP_INIT_COMPLETE,onAppReady);			
		}
		
		override protected function onModuleLoaded():void
		{
			//iSmileres=this._swf as ISmileres;
			this._e.listen(SEvents.OPEN_SMILE_PANEL,openHandler);	
			this._e.listen(SEvents.CLOSE_SMILE_PANEL,function(value:* = null):void
			{
				module.data = {"closePanel":null};
			});
		}
		
		private function onAppReady(value:*):void
		{
			this._e.remove(SEvents.APP_INIT_COMPLETE,onAppReady);			
			//时序提前到InitConfig
			//(Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).initFactory(Context.variables["conf"].smileres);
		}
		
		private function openHandler(value:*=null):void
		{
			//this.iSmileres.show(value);
			this.module.data = {"show":[value]};
		}
	}
}