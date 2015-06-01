package com._17173.flash.show.base.module.enterRoom
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.layer.UIManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.model.CEnum;
	
	public class EnterRoomModule extends BaseModule implements IEnterRoomModule
	{
		/**
		 * 进入房间界面 
		 */		
		private var _enterRoom:EnterRoomPanel = null;
		
		public function EnterRoomModule()
		{
			super();
			_version = "0.0.3";
		}
		/**
		 * 进入房间 
		 * 
		 */		
		public function enterRoom():void{
			if(Context.variables.showData.limit != 0){
				if(!_enterRoom){
					_enterRoom = new EnterRoomPanel();
					
				}
				_enterRoom.createPanel();
				(Context.getContext(CEnum.UI) as UIManager).popupPanel(_enterRoom);
				
			}
		}
	}
}