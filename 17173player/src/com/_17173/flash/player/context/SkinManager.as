package com._17173.flash.player.context
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.skin.BaseSkinManager;
	import com._17173.flash.core.skin.SkinObjectPrototype;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.SkinEvents;
	import com._17173.flash.player.ui.comps.Loading;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	
	/**
	 * 支持配置参数 
	 * 
	 * @author shunia-17173
	 */	
	public class SkinManager extends BaseSkinManager implements IContextItem
	{
		
		/**
		 * 除外的皮肤定义,如果该数组中存在该定义,则会被实例化为一个sprite
		 * 主要用于使用配置参数来除外某些正常情况下必须存在的皮肤 
		 */		
		protected var _excludeSkins:Array = null;
		
		public function SkinManager()
		{
			super();
			_excludeSkins = [];
		}
		
		protected function startUpInternal():void {
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.LOADING, Loading));
		}
		
		public function get contextName():String {
			return ContextEnum.SKIN_MANAGER;
		}
		
		public function startUp(param:Object):void {
			//判断是否有除外的皮肤
			if (param && param.hasOwnProperty("excludeSkins")) {
				_excludeSkins = param["excludeSkins"];
			}
			//监听事件并转发
			Context.getContext(ContextEnum.EVENT_MANAGER).listen(
				PlayerEvents.SKIN_EVENT, 
				function (data:Object):void {
					if (data && data.hasOwnProperty("event")) {
						notify(data.event, data.data);
					}
				});
			startUpInternal();
		}
		
		override public function hasSkinConfig(name:String):Boolean {
			return super.hasSkinConfig(name) && _excludeSkins.indexOf(name) == -1;
		}
		
		override public function resize():void {
			notify(SkinEvents.RESIZE, null);
		}
		
	}
}