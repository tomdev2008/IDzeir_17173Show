package com._17173.flash.show.base.module.activity
{
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.module.activity.acts.chunjie.Act_CJ;
	import com._17173.flash.show.base.module.activity.acts.qrj.Act_QRJ;
	import com._17173.flash.show.base.module.activity.base.IActivity;
	import com._17173.flash.show.model.SEnum;
	
	import flash.utils.Dictionary;

	/**
	 *活动处理 
	 * @author zhaoqinghao
	 * 
	 */	
	public class Activity extends BaseModule
	{
		private var actDic:Dictionary;
		/**
		 *圣诞活动展示 
		 */		
//		private var msPanel:McsShowPanel;
		/**
		 *圣诞活动引导版 
		 */		
		private var actList:Array;
		public function Activity()
		{
			super();
			actList = [];
			initAct();
			createActByList();
		}  
		/**
		 *添加活动 
		 * 
		 */		
		private function initAct():void{
			actList[actList.length] = {cla:Act_QRJ,url:SEnum.ACT_INFO};
			actList[actList.length] = {cla:Act_CJ,url:SEnum.ACT_INFO};
		}
		
		/**
		 *初始化列表 
		 * 
		 */		
		private function createActByList():void{
			var obj:Object;
			var len:int = actList.length
			for (var i:int = 0; i < len; i++) 
			{
				createAct(actList[i]);
			}
			
		}
		/**
		 *创建单个活动 
		 * @param data
		 * 
		 */		
		private function createAct(data:Object):void{
			var yd:IActivity  = new data.cla();
			yd.parent = this;
			yd.getDate(data.url);
		}
		
	}
}