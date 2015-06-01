package com._17173.flash.show.base.module.centermessage
{
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.base.model.MessageVo;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	public class CenterMessageDelegate extends BaseModuleDelegate
	{
		protected var moduleLoaded:Boolean = false;
		protected var cacheMsg:Array = null;
		public function CenterMessageDelegate()
		{
			super();
			cacheMsg = [];
			addServerLsn();
		}
		
		private function addServerLsn():void{
			//监听用户信息改变 如头像，名字，图标
			//监听广播消息
			//监听 按钮数据信息
			_s.socket.listen(SEnum.R_GIFT_GLOBAL.action, SEnum.R_GIFT_GLOBAL.type,onGiftGonggao);
			_s.socket.listen(SEnum.R_GONGGAO_MSG.action,SEnum.R_GONGGAO_MSG.type,onGiftGonggao);
			
		}
		
		override protected function onModuleLoaded():void{
			moduleLoaded = true;
			var data:Object;
			var len:int = cacheMsg.length;
			for (var i:int = 0; i < len; i++) 
			{
				_e.send(SEvents.SHOW_GLOBAL_GIFT_MESSAGE,cacheMsg[i]);
			}
			cacheMsg = [];
		}
		
		
		private function onGiftGonggao(data:Object):void{
			data.ct.time = data.timestamp;
			data = MessageVo.getMsgVo(data.ct);
			if(moduleLoaded){
				//转发业务消息
				_e.send(SEvents.SHOW_GLOBAL_GIFT_MESSAGE,data);
			}else{
				cacheMsg.push(data);
			}
			
		}
	}
}