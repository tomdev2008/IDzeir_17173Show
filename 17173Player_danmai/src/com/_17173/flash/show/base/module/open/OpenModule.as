package com._17173.flash.show.base.module.open
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.context.layer.UIManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	/**
	 * 开启房间模块 
	 * @author qiuyue
	 * 
	 */	
	public class OpenModule extends BaseModule implements IOpenModule
	{
		private var _e:IEventManager = null;
		/**
		 * 开启房间界面 
		 */		
		private var _openRoom:OpenRoomPanel = null;
		/**
		 * 关闭房间界面 
		 */		
		private var _closeRoom:CloseRoomPanel = null;
		
		public function OpenModule()
		{
			super();
			_version = "0.0.2";
		}
		protected override function init():void
		{
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			_e.listen(SEvents.OPENR_ROOM_SUCC, roomSucc);
			_e.listen(SEvents.OPEN_ROOM_FAIL, roomFail);
		}
		/**
		 * 改变房间状态 
		 * 
		 */		
		public function changeRoom():void{
			if(Context.variables.showData.roomStatus == 0){
				open();
			}else{
				close();
			}
			
		}
		
		/**
		 * 开启成功 
		 * @param data
		 * 
		 */		
		private function roomSucc(data:Object):void{
			roomFail(null);
			if(_openRoom){
				_openRoom.visible = false;
			}
		}
		
		/**
		 * 开启失败 
		 * @param data
		 * 
		 */		
		private function roomFail(data:Object):void{
			_e.remove(SEvents.OPENR_ROOM_SUCC, roomSucc);
			_e.remove(SEvents.OPEN_ROOM_FAIL, roomFail);
		}
		
		/**
		 * 显示开启房间界面 
		 * 
		 */		
		private function open():void{
			if(!_openRoom){	
				_openRoom = new OpenRoomPanel();
			}
			(Context.getContext(CEnum.UI) as UIManager).popupPanel(_openRoom);
		}
		
		/**
		 * 关闭房间界面 
		 * 
		 */		
		private function close():void{
			if(!_closeRoom){	
				_closeRoom = new CloseRoomPanel();
			}
			if(!this.contains(_closeRoom)){
				this.addChild(_closeRoom);
			}
			_closeRoom.visible = true;	
			_closeRoom.popAlert();
		}
	}
}