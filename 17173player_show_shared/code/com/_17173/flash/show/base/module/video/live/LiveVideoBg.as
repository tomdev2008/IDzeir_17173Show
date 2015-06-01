package com._17173.flash.show.base.module.video.live
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.HtmlUtil;
	import com._17173.flash.show.base.components.common.AslTextField;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	public class LiveVideoBg extends Sprite
	{
		private var _s:IServiceProvider = null;
		private var _e:IEventManager = null;
		/**
		 * 坐标 
		 */		
		private var _pointArray1:Array = [675,28,568,438,37,16,515,20,23,42,520,390,221,181,23,9,35,18,11,14];
		private var _pointArray2:Array = [435,147,248,228,73,27,24,30,27,52,215,162,69,67,71,21,76,30,25,26];
		private var _pointArray3:Array = [1234,147,248,228,39,27,192,30,8,52,214,162,69,67,39,21,51,30,25,26];
		/**
		 * 麦序 
		 */		
		private var _micIndex:int = 1;
		/**
		 * 艺人名字
		 */		
		private var _nameText:AslTextField = null;
		
		private var _stateText:AslTextField = null;
		
		private var soundState:SoundState = null;
		
		private var _videoState:VideoState = null;
		
		private var _nameBg:MovieClip = null;
		
		private var _stateFrame:int = 1;
		public function LiveVideoBg(micIndex:int)
		{
			super();
			this._micIndex = micIndex;
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			if(micIndex == 1){
				this.addChild(new LiveBG1);
			}else if(micIndex == 2){
				this.addChild(new LiveBG2);
			}else{
				this.addChild(new LiveBG3);
			}
			
			_videoState = new VideoState();
			_videoState.x = this["_pointArray"+micIndex][8];
			_videoState.y = this["_pointArray"+micIndex][9];
			_videoState.stop();
			this.addChild(_videoState);
			
			if(micIndex == 1){
				_nameBg = new GuanMing();
			}else if(micIndex == 2){
				_nameBg = new GuanMing2();
			}else{
				_nameBg = new GuanMing3();
			}
			this.addChild(_nameBg);
			_nameBg.x = this["_pointArray"+micIndex][14];
			_nameBg.y = this["_pointArray"+micIndex][15];
			
			soundState = new SoundState();
			soundState.x =  this["_pointArray"+micIndex][16];
			soundState.y =  this["_pointArray"+micIndex][17];
			this.addChild(soundState);
			soundState.gotoAndStop(1);
			
			var textFormat:TextFormat = FontUtil.DEFAULT_FORMAT;
			textFormat.color = 0xFFFFFF;
			textFormat.size = 14;
			_stateText = new AslTextField(90);
			_stateText.defaultTextFormat = textFormat;
			if(micIndex == 1){
				_stateText.text = "主";
			}else if(micIndex == 2){
				_stateText.text = "二";
			}else{
				_stateText.text = "三";
			}
			
			_stateText.selectable = false;
			if(micIndex == 1){
				_stateText.x = soundState.x + soundState.width +  1;
			}else{
				_stateText.x = soundState.x + soundState.width +  2;
			}
			
			_stateText.y = this["_pointArray"+micIndex][18];
			this.addChild(_stateText);
			var textFormat1:TextFormat = FontUtil.DEFAULT_FORMAT;
			textFormat1.color = 0xFFFFFF;
			textFormat1.size = 12;
			_nameText = new AslTextField(90);
			_nameText.defaultTextFormat = textFormat1;
			_nameText.text = "";
			_nameText.selectable = false;
			if(micIndex == 1){
				_nameText.x = _stateText.x + _stateText.width + 1;
			}else{
				_nameText.x = _stateText.x + _stateText.width + 2;
			}
			
			_nameText.y = this["_pointArray"+micIndex][19];
			_nameText.addEventListener(MouseEvent.CLICK,popUserCard);
			this.addChild(_nameText);
			this.x = this["_pointArray"+micIndex][0];
			this.y = this["_pointArray"+micIndex][1];
			update();
			
		}
		
		/**
		 * 弹出用户选项卡 
		 * @param e
		 * 
		 */		
		private function popUserCard(e:MouseEvent):void{
			if(micIndex >=1 && micIndex <=3){
				if(_nameText.text != ""){
					var stagePos:Point=this.localToGlobal(new Point(this._nameText.width,this._nameText.y));
					var order:Object = Context.variables.showData.order[micIndex];
					if(order){
						(Context.getContext(CEnum.USER) as IUser).showCard(order.masterId, stagePos);
					}
				}
			}
			e.stopPropagation();
		}
		
		public function updateSoundState():void{
			var order:Object = Context.variables.showData.order[micIndex];
			if(order && order.masterId != 0){
				soundState.gotoAndStop(order.isMute == 1 ? 2: 1);
			}else{
				soundState.gotoAndStop(1);
			}
		}
		
		public function update():void{
			updateBg();
			updateName();
			updateSoundState();
		}
		
		public function onUserExit(data:Object):void{
			var userId:String = (data.user as IUserData).id;
			var order:Object = Context.variables.showData.order[micIndex];
			if(order && userId == order.masterId){
				updateBg();
			}
			
		}
		
		public function onUserEnter(data:Object):void{
			var userId:String = (data.user as IUserData).id;
			var order:Object = Context.variables.showData.order[micIndex];
			if(order && userId == order.masterId){
				updateBg();
			}
			
		}
		
		private function updateName():void{
			var order:Object = Context.variables.showData.order[micIndex];
			if(order){
				_nameText.text = HtmlUtil.decodeHtml(order.nickName);
			}else{
				_nameText.text = "等待艺人上麦";
			}
			
		}
		
		private function updateBg():void{
			var order:Object = Context.variables.showData.order;
			if(order){
				var obj:Object = order[micIndex];
				var locale:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
				var iuser:IUser = Context.getContext(CEnum.USER) as IUser;
				if(obj){
					if(iuser.me){
						if(obj.masterId == iuser.me.id){
							_stateFrame = 11;
						}else{
							var iuserData:IUserData = iuser.getUser(obj.masterId);
							if(iuserData && !iuserData.isWeak){
								_stateFrame = 7;
							}else{
								_stateFrame = 9;
							}
						}
					}
				}else{
					
					_stateFrame = 3;
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