package com._17173.framework.core.manager
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.framework.preloader.Preloader;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.Security;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	
	
	public class ApplicationBootstrapManager extends MovieClip implements IAppliactionManager
	{	
		private var _preloader:Preloader;
		
		public function ApplicationBootstrapManager() {
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			if (stage)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.quality = StageQuality.HIGH;
			}
			/**停到第一帧**/
			stop();
			
			if (root && root.loaderInfo)
				root.loaderInfo.addEventListener(Event.INIT, initHandler);
		}
		
		/**
		 * 初始化事件
		 * 获得舞台参数 
		 * @param event
		 * 
		 */		
		private function initHandler(event:Event):void
		{		
			root.loaderInfo.removeEventListener(Event.INIT, initHandler);
			
			if(!AMGlobals.sm)
				AMGlobals.sm = this;
			if (!AMGlobals.info)
				AMGlobals.info = info();
			if (!AMGlobals.parameters)
				AMGlobals.parameters = loaderInfo.parameters;

			addEventListener(Event.ENTER_FRAME, docFrameListener);
			
			initialize();
		}
		/**
		 * 进入第二帧   当前帧标签 为主应用类名字
		 * 初始化应用
		 * @param event
		 * 
		 */		
		private function docFrameListener(event:Event):void
		{
			stageResizeHandler(null);
			if (currentFrame == 2)
			{
				removeEventListener(Event.ENTER_FRAME, docFrameListener);					
				initApplication();
			}
		}
		/**
		 * 初始化 
		 * 
		 */        
		private function initialize():void
		{
			_preloader = new Preloader();
			_preloader.addEventListener(Event.COMPLETE,preloader_completeHandler);
			var preClass:Object = info()["preloader"];
			if(preClass && preClass is Class)
				_preloader.preloader = preClass as Class;
			addChild(_preloader);
			
			_preloader.x = (stage.stageWidth - _preloader.width)/2;
			_preloader.y = 0;
			
			_preloader.initialize();
			
			if(stage)
				stage.addEventListener(Event.RESIZE,stageResizeHandler);
		}
		
		private function stageResizeHandler(event:Event):void
		{
			_preloader.x = (stage.stageWidth - _preloader.width)/2;
			_preloader.y = 0;
		}
		
		/**
		 * 进度加载完成 进入下一帧并停止
		 * @param event
		 * 
		 */        
		private function preloader_completeHandler(event:Event):void
		{
			//移除preloader
			//this.removeChild(_preloader);
			nextFrame();
		}
		/**
		 * 初始化主应用 
		 * 
		 */	
		private var _e:IEventManager;
		private function initApplication():void {
			/**这里不能直接写成：
			 var app:Application = new Application();
			 这样的由于引用到 Application，Application中所有的资源都会被编译到第一帧来
			 这样的话 PreLoader就没有意义了，你也看不到PreLoader，就跳到第二帧了
			 **/
			var mainAppName:String = AMGlobals.info["mainAppName"];
			
			if (mainAppName == null)
			{
				var url:String = loaderInfo.loaderURL;
				var dot:int = url.lastIndexOf(".");
				var slash:int = url.lastIndexOf("/");
				mainAppName = url.substring(slash + 1, dot);
			}
			
			var mainApp:Class = Class(getDefinitionByName(mainAppName));
			var app:DisplayObject = new mainApp() as DisplayObject;
			addChild(app);
			
			
			var timer:Timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER,function timerHandler(event:TimerEvent):void{
				if(Context.getContext(CEnum.EVENT) != null)
				{
					Timer(event.target).removeEventListener(TimerEvent.TIMER,timerHandler);
					
					_e = Context.getContext(CEnum.EVENT) as IEventManager;
					_e.listen(SEvents.FW_INIT_ITEM_PROGRESS, onProgress);
					_e.listen(SEvents.APP_LOAD_SUBDELEGATE,onComplete);
				}
			});
			timer.start();
		}

		private var _progress:Number=0;
		private function onProgress(data:Number):void
		{	
			if(_progress >= 90)
				_e.remove(SEvents.FW_INIT_ITEM_PROGRESS, onProgress);
			_progress += data;
			_preloader.preloaderIns.setProgress(_progress);
		}
		
		private function onComplete(data:Object):void
		{
			//移除preloader
			this.removeChild(_preloader);
		}
		
		/**
		 * 可用属性：
		 * preloader: 显示对象,
		 * scoketPath:"scoket文件位置",
		 * modulePath:"module文件位置"
		 * @return 
		 * 
		 */		
		protected function info():Object
		{
			return {};
		}
	}
}
