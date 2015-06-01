package com._17173.flash.player.module.quiz.ui.out
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.plugin.ExternalPluginItem;
	import com._17173.flash.core.plugin.IPluginManager;
	import com._17173.flash.core.plugin.PluginEvents;
	import com._17173.flash.player.business.stream.StreamDataRetriver;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.module.PluginEnum;
	import com._17173.flash.player.ui.stream.extra.IExtraUIItem;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	/* 
	*
	* 站外竞猜按钮
	*
	*/
	public class OutQuizStartBtn extends Sprite implements IExtraUIItem
	{
		
		/**
		 * 轮询竞猜数据的间隔
		 */		
		private static const GET_QUIZ_SEQ_TIME:int = 15000;
		
		private var _btn:Button = null;
		private var _quizOut:DisplayObject = null;
		
		private var _moduleOpened:Boolean = false;
		private var _hasData:Boolean = false;
		
		private var _isPrevFs:Boolean = true;
		
		public function OutQuizStartBtn()
		{
			super();
			var w:int = Context.stage.stageWidth;
			if (w >= 360)
			{
				init();
			}
		}
		
		/**
		 * 初始化 
		 */		
		private function init():void {
			_btn = new Button();
			_btn.setSkin(new mc_out_quiz_btn());
			_btn.x = -_btn.width;
			_btn.addEventListener(MouseEvent.CLICK, onClick);
			//loadQuiz();
			addChild(_btn);
			
			//广告后才开始加载竞猜数据
			if (Context.variables["isADPlayComplete"]) {
				postInit();
			} else {
				var e:IEventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
				e.listen(PlayerEvents.BI_AD_COMPLETE, postInit);
			}
		}
		
		protected function postInit(data:Object = null):void {
			var interval:uint = setInterval(function ():void {
				clearInterval(interval);
				checkQuiz();
			}, 3000);
		}
		
		/**
		 * 检查quiz的数据 
		 */		
		private function checkQuiz():void {
			if (Context.variables["liveRoomId"]) {
				StreamDataRetriver(Context.getContext(ContextEnum.DATA_RETRIVER)).LoadQuzi(
					Context.variables["liveRoomId"], true, onQuizSucc, onQuizFail);
			} else {
				onQuizFail(null);
			}
		}
		
		private function onQuizSucc(data:Object):void {
			if (data && data.length > 0) {
				_hasData = true;
				updateQuizStatus();
			} else {
				onQuizFail(data);
			}
		}
		
		private function onQuizFail(data:Object):void {
			_hasData = false;
			updateQuizStatus();
			
			//失败则轮询
			var interval:uint = setTimeout(function ():void {
				clearTimeout(interval);
				
				checkQuiz();
			}, GET_QUIZ_SEQ_TIME);
		}
		
		override public function set visible(value:Boolean):void {
			_moduleOpened = value;
			
			updateQuizStatus();
			super.visible = _hasData;
		}
		
		/**
		 * 根据是否有竞猜数据,控制当前竞猜面板的显隐规则 
		 */		
		private function updateQuizStatus():void {
			super.visible = _hasData;
			if (_hasData) {
				if (_quizOut) {
					addQuiz();
				} else {
					loadQuiz();
				}
			} else {
				removeQuiz();
			}
		}
		
		protected function onClick(event:MouseEvent):void {
			if (_quizOut) {
				if (_quizOut.parent && _quizOut.parent.contains(_quizOut)) {
					_quizOut.alpha = 1;
					TweenLite.to(
						_quizOut,0.3,{'alpha':0,"onComplete":removeQuiz}
					);
				} else {
					addQuiz();
				}
			} else {
				loadQuiz();
			}
		}
		
		/**
		 * 加载 
		 */		
		protected function loadQuiz():void {
			var func:Function = function (e:Event):void {
				//模块加载成功
				_quizOut = ex.warpper;
				_quizOut.addEventListener("close", onQuizFail);
				//add
				addQuiz();
				//移除加载监听
				ex.removeEventListener(PluginEvents.COMPLETE, func);
			};
			//加载站外竞猜模块
			var p:IPluginManager = Context.getContext(ContextEnum.PLUGIN_MANAGER) as IPluginManager;
			var ex:ExternalPluginItem = p.getPlugin(PluginEnum.QUIZ_OUT) as ExternalPluginItem;
			ex.addEventListener(PluginEvents.COMPLETE, func);
		}
		
		/**
		 * 添加到舞台 
		 */		
		protected function addQuiz():void {
			//加到舞台上
			Context.stage.addChild(_quizOut);
			//更新模块的全屏与非全屏状态
			updateModuleFullscreen(_isPrevFs);
		}
		
		/**
		 * 从舞台移除 
		 */		
		protected function removeQuiz():void {
			if (_quizOut && _quizOut.parent && _quizOut.parent.contains(_quizOut)) {
				_quizOut.parent.removeChild(_quizOut);
			}
		}
		
		/**
		 * 外部调用方法 
		 * 
		 * @param isFullScreen
		 */		
		public function refresh(isFullScreen:Boolean=false):void {
			if (isFullScreen != _isPrevFs) {
				_isPrevFs = isFullScreen;
				
				updateModuleFullscreen(isFullScreen);
			}
		}
		
		/**
		 * 更新模块的全屏与非全屏状态 
		 */		
		private function updateModuleFullscreen(fs:Boolean):void {
			if (_quizOut && _quizOut["onFullscreenChange"]) {
				var func:Function = _quizOut["onFullscreenChange"];
				if (func != null) {
					func.apply(null, [fs]);
				}
			}
		}
		
		public function get side():Boolean
		{
			return false;
		}
	}
}