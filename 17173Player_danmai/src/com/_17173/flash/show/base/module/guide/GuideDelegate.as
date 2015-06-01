package com._17173.flash.show.base.module.guide
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Cookies;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.components.common.plugbutton.PlugButton;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class GuideDelegate extends BaseModuleDelegate
	{
		/**
		 *cookies 引导属性字段
		 */
		private static const NEWBE_GUIDE:String = "newbeguide";
		
		private static const GUIDE_STEP:String = "guideStep";	
		private var _stepObj:Object;
		private var _arrayPointObj:Array=new Array();
		private var cook:Cookies;
		public function GuideDelegate()
		{
			super();
			
			cook = new Cookies(NEWBE_GUIDE,"/");
			_stepObj = cook.get(GUIDE_STEP);
					
			this._e.listen(SEvents.USER_AUTH,function (value:Object):void{
				userAuthHandler(value);
			});
			this._e.listen(SEvents.FLUSH_GUIDE_COOKIE,flushCookieHandler);
			this._e.listen(SEvents.PLUGBUTTON_CHANGE_POSTION, function plugChangePosHandler(value:Object):void
			{
				if(value is PlugButton)
				{
					var plbtn:PlugButton = value as PlugButton;
					if(plbtn.eType == SEvents.IS_SHOW_TASK)
						var point:Point = plbtn.localToGlobal(new Point(plbtn.x,plbtn.y));
					if(_stepObj == 0 && module)
						module["setPostionByIndex"](0,point);
					else
						_arrayPointObj.push({"name":"btn","point":point});
				}				
			});
			
			_e.listen(SEvents.CHAT_RESIZE,function chatResizeHandler(data:Object):void
			{
				var point:Point = new Point(data.width,data.height);
				if(_stepObj < 8 && module)
					module["setPostionByIndex"](4,point);
				else
					_arrayPointObj.push({"name":"chat","point":point});
			});
		}
		/**
		 * 0 老用户
		 * 1 能令任务的用户
		 * @param value
		 * 
		 */		
		private function userAuthHandler(value:Object):void
		{
			if(_stepObj==null)
				_stepObj = 0;
			//如果不显示新手任务，并且首次开始则从第二步开始
			if(Number(value)==0 && Number(_stepObj) == 0)
				_stepObj = 1;

			//未完成的用户加载此模块
			if(Number(_stepObj) < 8)
			    this.load();
		}
		
		private function flushCookieHandler(data:Object):void
		{
			cook = new Cookies(NEWBE_GUIDE,"/");
			cook.put(GUIDE_STEP,Number(data),true);
		}
		
		override protected function onModuleLoaded():void
		{
			super.onModuleLoaded();
			
			this._e.send(SEvents.REG_SCENE_POS, this._swf);
			var timer:Timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER,function timerHandler(event:TimerEvent):void
			{
				if(Context.stage.contains(module as DisplayObject))
				{
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER,timerHandler);
					timer=null;
					delayShow(5000);
				}
			});
			timer.start();
		}
		
		private function delayShow(value:int):void
		{
			Ticker.tick(value, function ():void {
					
				for each(var obj:Object in _arrayPointObj)
				{
					if(_stepObj == 0 && obj.name == "btn")
						module["setPostionByIndex"](0,obj.point);
					if(obj.name == "chat")
						module["setPostionByIndex"](4,obj.point);
				}
				module.data = {"displayByIndex":[_stepObj]};
			});
		}
	}
}