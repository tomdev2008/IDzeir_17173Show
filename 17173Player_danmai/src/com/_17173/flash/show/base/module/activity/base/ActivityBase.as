package com._17173.flash.show.base.module.activity.base
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 *带数据活动基类 
	 * @author zhaoqinghao
	 * 
	 */	
	public class ActivityBase extends Sprite implements IActivity
	{
		public function ActivityBase()
		{
			super();
			initUI();
			initLsn();
		}
		
		protected var _act:String;
		protected var _parent:DisplayObjectContainer;
		/**
		 *获取活动名 
		 * @return 
		 * 
		 */		
		public function get actName():String
		{
			// TODO Auto Generated method stub
			return _act;
		}
		
		public function getDate(url:String):void
		{
			// TODO Auto Generated method stub
			var server:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			var data:Object = {};
			data.masterId = Context.variables.showData.roomOwnMasterID;
			data.result = "json";
			if(_act){
				data.hd = _act;
			}
			data.roomId = (Context.variables["showData"]).roomID;
			server.http.getData(url,data,onDataback);
		}
		
		public function set parent(dsp:DisplayObjectContainer):void
		{
			// TODO Auto Generated method stub
			_parent = dsp;
		}
		
		public function remove():void
		{
			// TODO Auto Generated method stub
			if(parent && parent.contains(this)){
				parent.removeChild(this);
			}
		}
		
		public function show():void{
			_parent.addChild(this);
		}
		
		public function set actName(name:String):void
		{
			// TODO Auto Generated method stub
			_act = name;
		}
		
		private function onDataback(data:Object):void{
			setupData(data);
		}
		/**
		 *解析数据 
		 * @param data
		 * 
		 */		
		protected function setupData(data:Object):void{
			
		}
		
		/**
		 *初始化排行面板 
		 * 
		 */		
		protected function initUI():void{
			
		}
		
		protected function initLsn():void{
			
		}
		
		/**
		 *动态数据返回 
		 * @param data
		 * 
		 */		
		protected function onSocket(data:Object):void{
			
		}
	}
}