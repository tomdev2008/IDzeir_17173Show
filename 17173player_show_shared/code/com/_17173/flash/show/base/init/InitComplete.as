package com._17173.flash.show.base.init
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.init.base.BaseInit;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	/**
	 * 初始化后的检查.
	 * 如果需要对之前的业务进行判断以作为是否允许最终渲染进入界面的依据的话,可以增加到这里.
	 * 也可以用来检测某些重要的模块是否完成.
	 *  
	 * @author shunia-17173
	 */	
	public class InitComplete extends BaseInit
	{
		public function InitComplete()
		{
			super();
			this._weight = 10;
			_name = "最后的准备";
		}
		
		override public function enter():void {
			super.enter();
			checkAndSendEvent();
			complete();
		}
		
		
		/**
		 *检测是否需要派发事件 
		 * @param roomInfo
		 * 
		 */		
		private function checkAndSendEvent():void{
			
			var showData:Object = Context.variables["showData"];
			var roomInfo:Object = showData.roomInfo;
			//判断是否需要发送聊天区事件
			if(roomInfo && roomInfo.hasOwnProperty("enterEffect") && roomInfo.enterEffect==1){
				//发送聊天区特殊显示动画
				Context.getContext(CEnum.EVENT).send(SEvents.ADD_INFO_TO_CHAT,{info:"您来到的是中秋节活动冠军-嫦娥仙子"+roomInfo.masterNick+"的房间！",color:0x66FF00});
				//驻场动画
				var obj:Object = {};
				obj.enterEffect = roomInfo.enterEffect;
				obj.enterEffectType = roomInfo.enterEffectType;
				obj.enterEffectSwfKey = roomInfo.enterEffectSwfKey;
				obj.enterEffectPath = roomInfo.enterEffectPath;
				Context.getContext(CEnum.EVENT).send(SEvents.SCENE_EFFECT,obj);
				
			}
		}
		
	}
}