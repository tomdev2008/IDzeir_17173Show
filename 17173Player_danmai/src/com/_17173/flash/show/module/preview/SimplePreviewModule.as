package com._17173.flash.show.module.preview
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.authority.AuthorityStaitc;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.user.User;
	import com._17173.flash.show.base.module.video.base.JSProxy;
	import com._17173.flash.show.model.CEnum;
	
	import flash.events.Event;
	
	public class SimplePreviewModule extends BaseModule implements ISimplePreviewModule
	{
		private var _e:IEventManager = null;		
		private var _preview:SimplePreviewPanel = null;
		
		public function SimplePreviewModule()
		{
			super();
			_version = "0.0.4";
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
		}
		
		protected override function onAdded(event:Event):void{
			
			var user:User = Context.getContext(CEnum.USER) as User;
			var can:Boolean = user.validateAuthority(user.me,AuthorityStaitc.THING_42).can;
			if(can){
				showPreviewInit();
				JSProxy.getInstance().init();
				
			}
		}

		private function showPreviewInit():void{
			Debugger.log(Debugger.INFO,"[SimplePreviewModule]","初始化预览模块");
			_preview = new SimplePreviewPanel();
			addChild(_preview);
			_preview.show();
		}
		
		private function hide(data:Object):void{
			this.visible = false;	
		}
		
		public function resetPreview():void{
			if(_preview){
				_preview.resetPanel();
			}
		}
		
		/**
		 * 显示摄像头 
		 * 
		 */		
		public function showCamer(data:Object):void{
			if(_preview){
				_preview.updateBtn();
			}
		}
		/**
		 * 注册上麦消息 
		 * @param data
		 * 
		 */		
		public function onPushData(data:Object):void{
			this.visible = false;
		}
	}
}