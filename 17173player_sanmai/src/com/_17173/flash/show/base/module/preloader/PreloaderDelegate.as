package com._17173.flash.show.base.module.preloader
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	
	/**
	 * flash加载模块.提供加载进度显示及用户房间选择等逻辑.
	 *  
	 * @author shunia-17173
	 */	
	public class PreloaderDelegate extends BaseModuleDelegate
	{
		
		//private var _preloader:IPreloader = null;
		private var _progress:Number = 0;
		
		public function PreloaderDelegate()
		{
			super();
			//监听全局初始化结束的消息,用以移除preloader
//			_e.listen(SEvents.APP_INIT_COMPLETE, onRemovePreloader);
			//监听初始化项的状态变更
			_e.listen(SEvents.FW_INIT_ITEM_START, onStart);
			_e.listen(SEvents.FW_INIT_ITEM_PROGRESS, onProgress);
			_e.listen(SEvents.FW_INIT_ALL_COMPLETE, onComplete);
			
		}
		
		private function onComplete(data:String):void
		{
			if (this.module) {
				onProgress(100 - _progress);
				
				Ticker.tick(1, function ():void {
					//_preloader.complete(data);
					module.data = {"complete":[data]};
					//_preloader = null;
					TweenLite.to(_swf, 1, {"alpha":0, "onComplete":function ():void {
						unload();
					}});
				},1,true);
				
				_e.remove(SEvents.FW_INIT_ITEM_START, onStart);
				_e.remove(SEvents.FW_INIT_ITEM_PROGRESS, onProgress);
				_e.remove(SEvents.FW_INIT_ALL_COMPLETE, onComplete);
			}
		}
		
		private function onProgress(data:Number):void
		{
			_progress += data;
			if (module) {
				//_preloader.progress(_progress);
				module.data = {"progress":[_progress]};
			}
		}
		
		private function onStart(data:String):void
		{
			if (module) {
				//_preloader.start(data);
				module.data = {"start":[data]};
			}
		}
		
		override protected function onModuleLoaded():void {
			super.onModuleLoaded();
			
			//_preloader = _swf as IPreloader;
			
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			ui.popupPanel(_swf, new Point(0, 0));
//			Context.stage.addChild(_swf);
		}
		
	}
}