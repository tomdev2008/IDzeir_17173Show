package com._17173.flash.show.base.module.preloader
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.components.common.BitmapAnim;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * 加载进度模块.
	 *  
	 * @author shunia-17173
	 */	
	public class Preloader extends BaseModule implements IPreloader
	{
		
		private var _bg:MovieClip = null;
		private var _spark:MovieClip = null;
		private var _angle:MovieClip = null;
		private var _targetFrame:int = 0;
		private var _mask:Shape = null;
		private var _leftStar:BitmapAnim = null;
		private var _rightStar:BitmapAnim = null;
		private var _titleMask:Shape = null;
		
		public function Preloader()
		{
			super();
			_version = "0.0.1";
			mouseEnabled = false;
			mouseChildren = false;
			
			_bg = new mc_preloader_background();
			_bg.mouseEnabled = false;
			_bg.mouseChildren = false;
			_bg.cacheAsBitmap = true;
			addChild(_bg);
			onAddTitleMask();
			
			
			_angle = new mc_preloader_progress();
			_angle.mouseChildren = false;
			_angle.mouseEnabled = false;
			_angle.gotoAndStop(1);
			addChild(_angle);
			
			var max:ColorMatrixFilter = new ColorMatrixFilter();
			var rs:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
			rs.addAnimDatas4Mc("mc_process_star",new mc_process_star());
			
			_leftStar = new BitmapAnim();
			_leftStar.filters = [Utils.GRAY_FILTER1];
			_leftStar.scaleX = _leftStar.scaleY = .77;
			_leftStar.x = -20;
			_leftStar.y = 3;
			_leftStar.data = rs.getAnimDatas("mc_process_star");
			
			_rightStar = new BitmapAnim();
			_rightStar.filters = [Utils.GRAY_FILTER1];
			_rightStar.scaleX = _rightStar.scaleY = .77;
			_rightStar.x = -20;
			_rightStar.y = 3;
			_rightStar.data = rs.getAnimDatas("mc_process_star");
			onAddStar();
			
			_spark = new mc_preloader_spark();
			addChild(_spark);
			
			Context.stage.addEventListener(Event.RESIZE, onResize);
			onResize(null)
		}
		
		protected function onCheck(event:Event):void
		{
			//onResize(null);
			if (_angle.currentFrame == _angle.totalFrames) {
//				_angle.removeEventListener(Event.ENTER_FRAME, onCheck);
//				_angle.stop();
//				removeChild(_angle);
//				showOpenAnim();
//				animComplete();
			} else if (_angle.currentFrame != _targetFrame) {
				_angle.play();
			} else {
				_angle.stop();
//				onStarStop();
			}
		}
		
		protected function onAddTitleMask():void{
			if(_bg.mc_title){
				_titleMask = new Shape();
				_titleMask.graphics.beginFill(0xff0000);
				_titleMask.graphics.drawRect(0,0,_bg.mc_title.width,_bg.mc_title.height);
				_titleMask.graphics.endFill();
				_titleMask.x = -_titleMask.width;
				_bg.mc_title.mask = _titleMask;
				_bg.mc_title.addChild(_titleMask);
				
				//开始缓动
				onMoveEnd();
			}
		}
		/**
		 *文字遮罩移动 
		 * 
		 */		
		private function onMoveEnd():void{
			_titleMask.x = -_titleMask.width;
			TweenLite.to(_titleMask,2.7,{x:0,onComplete:onMoveEnd});
		}
		/**
		 *停止文字遮罩移动 
		 * 
		 */		
		private function killTitleMask():void{
			if(_titleMask){
				TweenLite.killTweensOf(_titleMask);
				if(_titleMask.parent){
					_titleMask.parent.removeChild(_titleMask);
				}
				_titleMask = null;
			}
			if(_bg.mc_title){
				_bg.mc_title.mask = null;
			}
		}
		
		/**
		 *添加星星动画 
		 * 
		 */		
		protected function onAddStar():void{
			var find:Boolean = false;
			if(_angle.leftStar){
				_angle.leftStar.addChild(_leftStar);
				_leftStar.playEndCall = onStarEnd;
				_leftStar.play();
			}
			if(_angle.rightStar){
				_angle.rightStar.addChild(_rightStar);
				_rightStar.playEndCall = onStarEnd;
				_rightStar.play();
			}
			
		}
		private function onStarStop():void{
			_leftStar.gotoAndStop(1);
			_rightStar.gotoAndStop(1);
		}
		
		/**
		 *循环播放 
		 * 
		 */		
		protected function onStarEnd():void{
			_leftStar.gotoAndPlay(16);
			_rightStar.gotoAndPlay(16);
		}
		
//		private function showOpenAnim():void {
//			_mask = new Shape();
//			_mask.graphics.beginFill(0, 1);
//			_mask.graphics.drawRect(0, 0, 1, 1);
//			_mask.graphics.endFill();
//			addChild(_mask);
//			mask = _mask;
//			addEventListener(Event.RESIZE, onResize);
//			onResize(null);
//			
//			Ticker.anim(3000, _mask)
//				.addProp("width", this.width)
//				.addProp("x", 0)
//				.onComplete = animComplete;
//		}
		
		protected function onResize(event:Event):void {
			if (width != Context.stage.stageWidth || height != Context.stage.stageHeight) {
				graphics.clear();
				graphics.beginFill(0, 1);
				graphics.drawRect(0, 0, Context.stage.stageWidth, Context.stage.stageHeight);
				graphics.endFill();
				
				_bg.x = (Context.stage.stageWidth - _bg.width) / 2;
				_bg.y = 0;
				_angle.y = 460;
				_angle.x = (Context.stage.stageWidth - _angle.width) / 2;
				_spark.x = Context.stage.stageWidth / 2;
				_spark.y = 300;
			}
		}
		
		public function complete(name:String):void {
			_angle.gotoAndStop(_angle.totalFrames);
			_angle.stop();
			onStarStop();
			_angle.removeEventListener(Event.ENTER_FRAME, onCheck);
			Context.stage.removeEventListener(Event.RESIZE, onResize);
			TweenLite.to(_angle, 0.2, {"alpha":0});
			killTitleMask();
			
		}
		
		public function progress(progress:Number):void {
			if (_angle) {
				_targetFrame = progress / 100 * _angle.totalFrames;
			}
		}
		
		public function start(name:String):void {
			if (!_angle.hasEventListener(Event.ENTER_FRAME)) {
				_angle.addEventListener(Event.ENTER_FRAME, onCheck);
			}
		}
		
	}
}