package com._17173.flash.show.base.module.login
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	public class LoginDelegate extends BaseModuleDelegate
	{
		private var _moduleLoaded:Boolean = false;
		public function LoginDelegate()
		{
			super();
			_cacheMsg = [];
			addLsn();
		}
		
		override protected function onModuleLoaded():void
		{
			super.onModuleLoaded();
			_moduleLoaded = true;
			sendCache();
		}
		private var _cacheMsg:Array = null;
		
		private function addLsn():void
		{
			Context.getContext(CEnum.EVENT).listen(SEvents.LOGINPANEL_SHOW,onShowLogin);
			Context.getContext(CEnum.EVENT).listen(SEvents.LOGINPANEL_HIDE,hideLogin);
		}
		
		
		private function onShowLogin(data:Object):void{
			if(!cacheToMsg(onShowLogin,data)){
				_swf["showHideLogin"](1);
			}
		}
		
		private function hideLogin(data:Object):void{
			if(!cacheToMsg(hideLogin,data)){
				_swf["showHideLogin"](2);
			}
		}
		
		/**
		 *是否缓存 如果模块没加载完毕则自动加入缓存中
		 * @param fun 缓存回调
		 * @param data 回调数据
		 * @return 
		 * 
		 */
		private function cacheToMsg(fun:Function, data:Object):Boolean
		{
			var iscache:Boolean = !_moduleLoaded;
			if(iscache){
				_cacheMsg[_cacheMsg.length] = {back:fun,data:data};
			}
			return iscache;
		}
		
		/**
		 *派发缓存数据
		 *
		 */
		private function sendCache():void
		{
			
			//所有缓存数据进行处理
			var fun:Function;
			var data:Object;
			var msg:Object;
			var len:int = _cacheMsg.length;
			for (var j:int = 0; j < len; j++) 
			{
				msg = _cacheMsg[j];
				fun = msg.back;
				data = msg.data;
				fun.apply(null,[data]);
			}
			
			
		}
	}
}