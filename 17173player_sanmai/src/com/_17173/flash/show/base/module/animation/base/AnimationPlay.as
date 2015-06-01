package com._17173.flash.show.base.module.animation.base
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.module.animation.IAnimationFactory;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 *单个动画类，调用 AnimationData.getAmd静态方法获取；
	 * @author zhaoqinghao
	 * 
	 */
	public class AnimationPlay implements IAnimationPlay
	{
		/**
		 *动画容器 
		 */		
		protected var _parentLayer:IAnimactionLayer = null;
		/**
		 *加载完毕后回调 
		 */		
		protected var _onLoadCallBack:Function = null;
		protected var _onPlayEndCallBack:Function = null;
		protected var _url:String= null;
		protected var _bmp:Bitmap;
		/**
		 *动画类型 
		 */		
		protected var _type:String= null;
		/**
		 *动画 
		 */		
		protected var _mc:*= null;
		/**
		 *总帧数 
		 */		
		protected var _ttFrame:int= 0;
		/**
		 *是否加载完成 
		 */		
		protected var _loaded:Boolean = false;
		protected var _loadFail:Boolean = false;
		/**
		 *是否已经返回对象池 
		 */		
		protected var _returned:Boolean = false;
		protected var _data:Object = null;
		protected var _actionOk:Boolean = false;
		protected var _loading:Boolean = false;
		protected var _bgEffect:Sprite = null;
		protected var _bfEffect:Sprite = null;
		protected var _mcX:int = 0;
		protected var _mcY:int = 0;
		public function AnimationPlay()
		{
			
		}
		
		
		/**
		 * 设置数据
		 */
		public function setup(apath:String,atype:String,layer:IAnimactionLayer):void{
			_url =  apath;
			_type = atype;
			_parentLayer = layer;
		}
		/**
		 *回收时检测如果加载失败的则重置所有属性(以便复用效果MC)
		 * 
		 */		
		public function returnObj():void{
			if(_loaded == true && _loadFail == true){
				_mc = null;
				_loaded = false;
				_loadFail = false;
				_url = null;
				_ttFrame = 0;
				_bfEffect = null;
				_bgEffect = null;
				_data = null;
			}
			_type = null;
			_onLoadCallBack = null;
			_actionOk = false;
			returned = true;
			data = null;
			returnSelfPool();
		}
		
		protected function returnSelfPool():void{
			//返回池
			(Context.getContext(CEnum.ANIMATIONFACTORY) as IAnimationFactory).returnAmt(this);
		}
		
		public function loadAnimation(loadEndCallBack:Function = null):void
		{
			_loading = true;
			_onLoadCallBack = loadEndCallBack;
			var iss:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
			var claName:String = getClassName();
			iss.loadResource(_url,loadCmp,claName);
			
		}
		
		
		protected function getClassName():String{
			var claName:String = _data.giftKey;
			if(type == AnimationType.ATYPE_CAC_LINE || type == AnimationType.ATYPE_CAR_MINI || type == AnimationType.ATYPE_FLOWER_MINI){
				claName = claName+"_other";
			}
			return claName;
		}
		
		protected function loadFailBack(data:IResourceData):void{
			_loading = false;
			Debugger.log(Debugger.ERROR, "[加载动画错误]", "动画地址",_url);
			_loadFail = true;	
			_loaded = true;
			if(_onLoadCallBack != null){
				_onLoadCallBack()
			}
		}
		
		
		public function loadCmp(data:IResourceData):void
		{
			if(data != null && data.source != null){
				_loading = false;
				_loadFail = false;
				_loaded = true;
				_mc = data.source;
				_mc.mouseChildren = false;
				_mc.mouseEnabled = false;
				onLoadedAction();
				if(_onLoadCallBack != null){
					_onLoadCallBack()
				}
			}else{
				_loading = false;
				Debugger.log(Debugger.ERROR, "[加载动画错误]", "动画地址",_url);
				_loadFail = true;	
				_loaded = true;
				if(_onLoadCallBack != null){
					_onLoadCallBack()
				}
			}
		}
		
		
		
		public function play(playEndCall:Function = null):void
		{
			_onPlayEndCallBack = playEndCall;
			_parentLayer.addAnimation(this);
			startChild(mc);
		}
		
		public function remove():void{
			if(_parentLayer){
				_parentLayer.removeAnimation(this);
				returnObj();
			}
		}
		
		public function playEnd():void
		{
			var event:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			event.send(SEvents.GIFT_ANIMATION_PLAY_END,[_type,_data]);
			remove();
			if(_onPlayEndCallBack != null){
				_onPlayEndCallBack();
			}
		}
		
		public function run():void
		{
			var mc:MovieClip = _mc as MovieClip;			
			if(checkFrame(mc)){
				stopChild(mc);
				playEnd();
			}
		}
		/**
		 *检测是否播放完 
		 * @param mc
		 * @return 
		 * 
		 */		
		protected function checkFrame(mc:*):Boolean{
			if(mc.currentFrame == mc.totalFrames){
				stopChild(mc);
				return true;
			}
			otherAction();
			return false;
		}
		/**
		 *每帧中的其他操作 
		 * 
		 */		
		protected function otherAction():void{
			
		}
		/**
		 *加载后执行 
		 * 
		 */		
		protected function onLoadedAction():void{
			
		}
		
		protected function stopChild(mc:*):void{
			mc.stop();
			var len:int = mc.numChildren;
			for (var i:int = 0; i < len; i++) 
			{
				if(mc.getChildAt(i) is MovieClip){
					stopChild(mc.getChildAt(i) as MovieClip)
				}
			}
			
			
		}
		
		protected function startChild(mc:*):void{
			mc.gotoAndPlay(0);
			var len:int = mc.numChildren;
			for (var i:int = 0; i < len; i++) 
			{
				if(mc.getChildAt(i) is MovieClip){
					startChild(mc.getChildAt(i) as MovieClip)
				}
			}
		}
		/**
		 *停止 
		 * 
		 */		
		public function toStopEnd():void{
		}
		
		
		/**********************************************************
		 * 
		 * get/set 
		 * 
		 ***********************************************************/
		
		/**
		 *是否加载完成 
		 */
		public function get loaded():Boolean
		{
			return _loaded;
		}
		
		/**
		 * @private
		 */
		public function set loaded(value:Boolean):void
		{
			_loaded = value;
		}
		
		/**
		 *总帧数 
		 */
		public function get ttFrame():int
		{
			return _ttFrame;
		}
		
		/**
		 * @private
		 */
		public function set ttFrame(value:int):void
		{
			_ttFrame = value;
		}
		
		/**
		 *动画 
		 */
		public function get mc():*
		{
			return _mc;
		}
		
		/**
		 * @private
		 */
		public function set mc(value:*):void
		{
			_mc = value;
		}
		
		/**
		 *动画类型 
		 */
		public function get type():String
		{
			return _type;
		}
		
		/**
		 * @private
		 */
		public function set type(value:String):void
		{
			_type = value;
		}
		
		public function get returned():Boolean
		{
			return _returned;
		}
		
		public function set returned(value:Boolean):void
		{
			_returned = value;
		}
		
		public function getBmp():Bitmap{
			return null;
		}
		public function get mcY():int
		{
			return _mcY;
		}
		
		public function set mcY(value:int):void
		{
			_mcY = value;
		}
		
		public function get mcX():int
		{
			return _mcX;
		}
		
		public function set mcX(value:int):void
		{
			_mcX = value;
		}
		
		public function get bmp():Bitmap
		{
			return _bmp;
		}
		
		public function set bmp(value:Bitmap):void
		{
			_bmp = value;
		}
		
		/**
		 *前景效果 
		 */
		public function get bfEffect():Sprite
		{
			return _bfEffect;
		}
		
		/**
		 * @private
		 */
		public function set bfEffect(value:Sprite):void
		{
			_bfEffect = value;
		}
		
		/**
		 *背景效果 
		 */
		public function get bgEffect():Sprite
		{
			return _bgEffect;
		}
		
		/**
		 * @private
		 */
		public function set bgEffect(value:Sprite):void
		{
			_bgEffect = value;
		}
		
		public function get loading():Boolean
		{
			return _loading;
		}
		
		public function set loading(value:Boolean):void
		{
			_loading = value;
		}
		
		/**
		 *播放完成后回调 
		 */
		public function get onPlayEndCallBack():Function
		{
			return _onPlayEndCallBack;
		}
		
		/**
		 * @private
		 */
		public function set onPlayEndCallBack(value:Function):void
		{
			_onPlayEndCallBack = value;
		}
		
		/**
		 *动画地址 
		 */
		public function get url():String
		{
			return _url;
		}
		
		/**
		 * @private
		 */
		public function set url(value:String):void
		{
			_url = value;
		}
		
		/**
		 *加载失败 
		 */
		public function get loadFail():Boolean
		{
			return _loadFail;
		}
		
		/**
		 * @private
		 */
		public function set loadFail(value:Boolean):void
		{
			_loadFail = value;
		}
		
		/**
		 * 数据
		 */
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			_data = value;
		}
	}
}