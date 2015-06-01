package com._17173.flash.show.base.module.dingyue.ui
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Cookies;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.context.user.User;
	import com._17173.flash.show.base.module.dingyue.DingyueBtn;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	import flash.geom.Point;

	public class DingyueGuideGm
	{
		public function DingyueGuideGm()
		{
			_mc = new DingyueGuide(guiCmpToSave);
			(Context.getContext(CEnum.EVENT)).listen(DingyueBtn.DINGYUE_GUIDE,showGuide);
			(Context.getContext(CEnum.EVENT)).listen(DingyueBtn.DINGYUE_GUIDE_RP,rePostion);
		}
		private var _mc:DingyueGuide;
		/**
		 *cookies 引导字段
		 */
		private static const CK_GUI:String = "show_guide";
		/**
		 *订阅的引导
		 */
		private static const CK_DINGYUE:String = "subscribe";
		/**
		 *使用flashcookie  或者使用游览器
		 */
		private static const USE_FLASH_COOKIE:Boolean = true;
		
		/**
		 *获取引导状态 
		 * @return 是否完成了引导
		 * 
		 */		
		private function getCookieState():Boolean
		{
			var isCmp:Boolean = false;
			if (USE_FLASH_COOKIE)
			{
				isCmp = Boolean(state4Flash);
			}
			else
			{
				isCmp = Boolean(state4IntExp);
			}
			return isCmp;
		}
		
		public function guideDingyue():void{
			if(!getCookieState()){
//				showGuide();
			}
		}
		
		
		private function showGuide(info:Point):void{
			var userdata:IUserData = (Context.getContext(CEnum.USER) as User).me;
			var showData:ShowData = Context.variables["showData"] as ShowData;
			//判断如果是自己则不显示
			//单麦
			if(showData.hasOwnProperty("roomOwnMasterID")){
				var roomMid:String = showData["roomOwnMasterID"];
				if(userdata.id == roomMid){
					return;
				}
			}
			//如果是三麦则不显示引导
			if(showData.hasOwnProperty("order") && showData["order"] != null){
				return;
			}
			if(!getCookieState() && _mc.parent == null){
				_mc.x = info.x - 205;
				_mc.y = info.y - 118;
				var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
				ui.addGuide(_mc);
				(Context.getContext(CEnum.EVENT)).send(SEvents.CHange_SCENE_DRAG,false);
			}
		}
		
		private function rePostion(info:Point):void{
			if(_mc.parent != null){
				_mc.x = info.x - 205;
				_mc.y = info.y - 118;
			}
		}
		
		private function guiCmpToSave():void
		{
			(Context.getContext(CEnum.EVENT)).send(SEvents.CHange_SCENE_DRAG,true);
			if (USE_FLASH_COOKIE)
			{
				state2Flash = 1;
			}
			else
			{
				state2IntExp = 1;
			}
		}
		
		private function get state4Flash():int
		{
			var state:int = 0;
			var cook:Cookies = new Cookies(CK_GUI,"/");
			state = cook.get(CK_DINGYUE) as int;
			return state;
		}
		
		private function get state4IntExp():int
		{
			return state4Flash;
		}
		
		private function set state2Flash(state:int):void
		{
			var cook:Cookies = new Cookies(CK_GUI,"/");
			cook.put(CK_DINGYUE,state);
		}
		
		private function set state2IntExp(state:int):void
		{
			state2Flash = state;
		}
	}
}