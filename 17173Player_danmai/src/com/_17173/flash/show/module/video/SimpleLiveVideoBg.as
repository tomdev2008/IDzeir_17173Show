package com._17173.flash.show.module.video
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Sprite;
	
	public class SimpleLiveVideoBg extends Sprite
	{
		private var _s:IServiceProvider = null;
		private var _e:IEventManager = null;
		/**
		 * 麦序 
		 */		
		private var _micIndex:int = 1;
		
		private var _videoState:VideoState = null;
		
		private var _stateFrame:int = 1;
		
		public function SimpleLiveVideoBg(micIndex:int)
		{
			super();
			this._micIndex = micIndex;
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			
//			this.graphics.clear();
//			this.graphics.lineStyle(1, 0x971C69, 1);
//			this.graphics.beginFill(0x240642,.9);
//			this.graphics.drawRect(0,0,572,414);
//			this.graphics.endFill();
			this.addChild(new VideoBG);
			
			
			_videoState = new VideoState();
			_videoState.x = (572-_videoState.width)/2;
			_videoState.y = 10;
			_videoState.stop();
			this.addChild(_videoState);
			
			
//			this.x = 684;
//			this.y = 42;
			
			update();
		}
		
		public function update():void{
			updateBg();
		}
		
		/**
		 *更改订阅人数 用于订阅或取消订阅操作 
		 * @param isAdd
		 * 
		 */		
		private function changeToCount(isAdd:Boolean):void{
		
		}
		
		
		public function onUserExit(data:Object):void{
			var userId:String = (data.user as IUserData).id;
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(userId == liveInfo.masterId){
				updateBg();
			}
		}
		
		public function onUserEnter(data:Object):void{
			var userId:String = (data.user as IUserData).id;
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(userId == liveInfo.masterId){
				updateBg();
			}
		}
		
		private function updateBg():void{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo){
				if(liveInfo){
					var locale:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
					if(liveInfo.masterId == 0){
						_stateFrame = 1;
					}else{
						if(liveInfo.masterId == (Context.getContext(CEnum.USER) as IUser).me.id){
							_stateFrame = 11;
						}else{
							var iuser:IUser = Context.getContext(CEnum.USER) as IUser;
							var iuserData:IUserData = iuser.getUser(liveInfo.masterId);
							if(iuserData && !iuserData.isWeak){
								_stateFrame = 7;
							}else{
								_stateFrame = 9;
							}
						}
					}
				}else{
					_stateFrame = 1;
				}
				
				if(micIndex == 1){
					_videoState.gotoAndStop(_stateFrame);
				}else{
					_videoState.gotoAndStop(_stateFrame +1);
				}
			}
		}
		
		/**
		 * 麦序，表示在主麦，1麦，2麦 
		 */
		public function get micIndex():int
		{
			return _micIndex;
		}
		
	}
}


