package com._17173.flash.show.base.module.animation.base
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	
	import flash.events.Event;

	/**
	 *动画控制器
	 * @author zhaoqinghao
	 * 
	 */	
	public class BaseAmtControl
	{
		public function BaseAmtControl(type:String,parentLayer:IAnimactionLayer)
		{
			_type = type;
			_datas = [];
			_parent = parentLayer;
		}
		
		public var autoLoadNext:Boolean = false;
		protected var _type:String = null; 
		
		/**
		 *是否加载中 
		 */
		public function get loading():Boolean
		{
			return _loading;
		}

		/**
		 * @private
		 */
		public function set loading(value:Boolean):void
		{
			_loading = value;
		}

		public var playEndCallBack:Function;
		/**
		 *需要播放动画集合 
		 */		
		protected var _datas:Array = null;
		/**
		 *父容器 
		 */		
		protected var _parent:IAnimactionLayer = null;
		/**
		 *当前播放数据 
		 */		
		protected var _cPlayData:IAnimationPlay = null;
		/**
		 *是否播放子动画 
		 */		
		protected var _playingItem:Boolean = false;
		/**
		 * 控制器播放中
		 */		
		protected var _playing:Boolean = false;
		protected var _loading:Boolean = false;
		/**
		 *加载完成数据 
		 */		
		protected function onLoadCmp():void{
			_loading = false;
			loadNext();
		}
		
		/**
		 *播放加载完成的动画
		 * 
		 */		
		protected function playNewForLoad():void{
			if(_datas.length > 0){
				_cPlayData = _datas.shift() as IAnimationPlay;
				if(_cPlayData.loadFail || _cPlayData.mc == null){
					_cPlayData.returnObj();
					playNewForLoad();
				}else{
					_cPlayData.play(onPlayEnd);
					_playingItem = true;
				}
				//播放
			}
			autoPlayStop();
		}
		
		/**
		 *播放完成 
		 * 
		 */		
		protected function onPlayEnd():void{
			_playingItem = false;
			playNewForLoad();
			if(playEndCallBack !=null){
				playEndCallBack();
			}
		}
		/**
		 *运行 
		 * 
		 */		
		public function run(e:Event = null):void{
			if(_cPlayData == null || _cPlayData.returned) return;
			_cPlayData.run();
		}
	
		/**
		 *添加数据 
		 * @param data
		 * 
		 */		
		public function addData(data:IAnimationPlay):void{
			_datas.push(data);
			loadNext();
		}
		/**
		 *加载下一个要播放的动画 
		 * 
		 */		
		protected function loadNext():void{
			if(_playingItem){
				loadBeforehand();
			}else{
				//播放下一个
				var data:IAnimationPlay = _datas[0] as IAnimationPlay;
				if(data.loaded){
					playNewForLoad();
				}else{
					//判断如果有缓存的，则不用新建的对象;
//					var tData:IAnimationPlay = AnimationObject.getAmdByPath(data.url);
//					if(tData){
//						data = null;
//						_datas[0]  = null;
//						_datas[0] = tData;
//						playNewForLoad();
//					}else{
						_loading = true;
						data.loadAnimation(onLoadCmp);
//					}
					
				}
			}
		}
		/**
		 *预加载 
		 * 
		 */		
		protected function loadBeforehand():void{
			if(_loading || !autoLoadNext) return;
			var count:int = _datas.length;
			var i:int = 0;
			var data:IAnimationPlay;
			while(i < count){
				data = _datas[i];
				if(data.loaded == false){
					_loading = true;
					data.loadAnimation(onLoadCmp);
					return;
				}
				i++;
			}
		}
		public function startPlay():void{
			startEnter();
		}
		
		public function stopPlay():void{
			try{
				stopEnter();
				_playingItem = false;
				clearDatas();
			}catch(e:Error){
				Debugger.log(Debugger.INFO,"[动画模块]",e.message);
			}
		}
		
		
		protected function clearDatas():void{
			if (_cPlayData) {
				_cPlayData.remove();
				_cPlayData = null;
			}
			var len:int = _datas.length;
			var data:IAnimationPlay;
			for (var i:int = 0; i < len; i++) 
			{
				data = _datas[i];
				if(data){
					data.remove();
				}
			}
			_datas.splice(0, _datas.length);
			
		}
		/**
		 *自动播放或停止 
		 * 
		 */		
		private function autoPlayStop():void{
			if(_playing == true){
				if(_playingItem == false && _datas.length <= 0){
					stopEnter();
				}
			}else{
				if(_playingItem == true || _datas.length > 0){
					startEnter();
				}
			}
		}
		/**
		 *开始enterframe 
		 * 
		 */		
		private function startEnter():void{
			if(_playing == false){
				_playing = true;
				Context.stage.addEventListener(Event.ENTER_FRAME,run);
			}
		}
		/**
		 *停止enterframe  
		 * 
		 */		
		private function stopEnter():void{
			if(_playing == true){
				_playing = false;
				Context.stage.removeEventListener(Event.ENTER_FRAME,run);
			}
		}
		
		public function get playItem():Boolean{
			return _playingItem;
		}
		
	}
}