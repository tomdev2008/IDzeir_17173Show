package com._17173.flash.show.base.module.animation.sceneeffect
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	public class SceneEffectDelegate extends BaseModuleDelegate
	{
		public function SceneEffectDelegate()
		{
			super();
			initLsn();
			check();
		}
		
		private function initLsn():void{
			_e.listen(SEvents.SCENE_EFFECT,function(value:Object):void{
				excute(onGiftAmt,value);});
			_e.listen(SEvents.GIFT_EFFECT_CLOSE,function(value:Object):void{
				excute(onEffectClose,value);});
			_e.listen(SEvents.GIFT_EFFECT_OPEN,function(value:Object):void{
				excute(onEffectOpen,value);});
		}
		
		private function removeLsn():void{
			_e.remove(SEvents.SCENE_EFFECT,onGiftAmt);
			_e.remove(SEvents.GIFT_EFFECT_CLOSE,onEffectClose);
			_e.remove(SEvents.GIFT_EFFECT_OPEN,onEffectOpen);
		}
		
		
		private function check():void{
			var showdata:ShowData = Context.variables["showData"];
			checkAndSendEvent(showdata);
		}
		
		/**
		 *检测是否需要派发事件 
		 * @param roomInfo
		 * 
		 */		
		protected function checkAndSendEvent(showdata:Object):void{
			var roomInfo:Object = showdata.roomInfo
			//判断是否需要发送聊天区事件
			var isTest:Boolean = false;
			if(isTest || (roomInfo && roomInfo.hasOwnProperty("enterEffect") && roomInfo.enterEffect==1)){
				//发送聊天区特殊显示动画
//				roomInfo["enterEffectTip"] = "欢迎来到[name]的直播间！"
				
				if(roomInfo.hasOwnProperty("enterEffectTip") && roomInfo.enterEffectTip != ""){
					var tip:String = roomInfo.enterEffectTip;
					var name:String = "";
					if(showdata.hasOwnProperty("roomOwnMasterName")){
						name = showdata["roomOwnMasterName"]
					}
					tip = tip.replace("[name]",name);
					Context.getContext(CEnum.EVENT).send(SEvents.ADD_INFO_TO_CHAT,{info:tip,color:0xFF9900});
				}
				//驻场动画
				var obj:Object = {};
				obj.enterEffect = roomInfo.enterEffect;
				obj.enterEffectType = roomInfo.enterEffectType;
				obj.enterEffectSwfKey = roomInfo.enterEffectSwfKey;
				obj.enterEffectPath = roomInfo.enterEffectPath;
				Context.getContext(CEnum.EVENT).send(SEvents.SCENE_EFFECT,obj);
				
			}
			
			
		}
		
		public function onGiftAmt(data:Object):void{
			_swf["addGiftAmt"](data);
		} 
		
		public function onEffectClose(data:Object = null):void{
			_swf["onEffectClose"](data);
		}
		
		public function onEffectOpen(data:Object = null):void{
			_swf["onEffectOpen"](data);
		}
	}
}