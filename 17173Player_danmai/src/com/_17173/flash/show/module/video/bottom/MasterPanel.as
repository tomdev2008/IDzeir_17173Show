package com._17173.flash.show.module.video.bottom
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.HtmlUtil;
	import com._17173.flash.show.base.components.common.AslTextField;
	import com._17173.flash.show.base.components.common.BitmapMovieClip;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.module.userCard.UserCardData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	public class MasterPanel extends Sprite
	{
		
		/**
		 * 艺人名字
		 */		
		private var _nameText:AslTextField = null;
		private var _nameHit:Sprite = null;
		private var soundState:SoundState = null;
		private var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
		
		private var _levelMc:BitmapMovieClip;
		private var _locationText:AslTextField;
		private var _liveTimeText:AslTextField;
		private var _timeMc:LiveTimeMc;
		private const BASE_URL:String = "assets/img/level/";
		
		public function MasterPanel()
		{
			super();			
			
			/** 声音图标 **/
			soundState = new SoundState();
			soundState.y = 5;
			this.addChild(soundState);
			soundState.gotoAndStop(1);
			
			/** 艺人名字 **/
			var textFormat1:TextFormat = FontUtil.DEFAULT_FORMAT;
			textFormat1.color = 0xFFFF66;
			textFormat1.size = 12;
			_nameText = new AslTextField(100);
			_nameText.defaultTextFormat = textFormat1;
			_nameText.text = "";
			_nameText.selectable = false;
			_nameText.mouseEnabled = false;
			_nameText.x = soundState.x + soundState.width + 3;
			_nameText.y = 4;
			this.addChild(_nameText);
			
			/** 艺人等级 **/
			_levelMc = new BitmapMovieClip();	
//			_levelMc.y = -2;
			this.addChild(_levelMc);
			
			/** 艺人地址  **/
			var locationMc:LocationMc = new LocationMc();
			locationMc.x = 2;
			locationMc.y = 27;
			this.addChild(locationMc);
			var tf2:TextFormat = FontUtil.DEFAULT_FORMAT;
			tf2.color = 0xA197B1;
			tf2.size = 12;
			_locationText = new AslTextField(100);
			_locationText.defaultTextFormat = tf2;
			_locationText.text = "";
			_locationText.selectable = false;
		    _locationText.mouseEnabled = false;
			_locationText.x = locationMc.x + locationMc.width + 3;
			_locationText.y = locationMc.y - 5;
			this.addChild(_locationText);
			
			
			/** 开播时间 **/
			_timeMc = new LiveTimeMc();
			_timeMc.x = 62;
			_timeMc.y = 27;
			this.addChild(_timeMc);
			var tf3:TextFormat = FontUtil.DEFAULT_FORMAT;
			tf3.color = 0xA197B1;
			tf3.size = 12;
			_liveTimeText = new AslTextField(100);
			_liveTimeText.defaultTextFormat = tf3;
			_liveTimeText.text = "未直播";
			_liveTimeText.selectable = false;
			_liveTimeText.mouseEnabled = false;
			_liveTimeText.x = _timeMc.x + _timeMc.width + 3;
			_liveTimeText.y = _timeMc.y - 5;
			this.addChild(_liveTimeText);
		}
		
		public function updateSoundState():void{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo && liveInfo.masterId != 0){
				soundState.gotoAndStop(liveInfo.isMute == 1 ? 2: 1);
			}
		}
		
		/**
		 * 更新名字 
		 * 
		 */		
		private var _nameTipBg:Sprite;
		public function updateName():void{
			_nameText.text = HtmlUtil.decodeHtml(Context.variables.showData.roomOwnMasterName);
			_nameText.width = _nameText.textWidth + 4;
			
			//_nameText.backgroundColor = 0x000000;
			if(_nameHit==null)
			{
//				_nameTipBg = new Sprite();
//				_nameTipBg.graphics.beginFill(0);
//				_nameTipBg.graphics.drawRect(_nameText.x,_nameText.y,_nameText.width,_nameText.height);
//				_nameTipBg.graphics.endFill();
//				this.addChild(_nameTipBg);
//				ui.registerTip(_nameHit,HtmlUtil.decodeHtml(Context.variables.showData.roomOwnMasterName));
				
				_nameHit = new Sprite();
				_nameHit.mouseChildren = false;
				_nameHit.buttonMode = true;
				_nameHit.graphics.beginFill(0,0);
				_nameHit.graphics.drawRect(0,0,_nameText.width,_nameText.height);
				_nameHit.graphics.endFill();
				this.addChild(_nameHit);
				_nameHit.x = _nameText.x;
				_nameHit.y = _nameText.y;
				_nameHit.addEventListener(MouseEvent.CLICK,popUserCard);
				ui.registerTip(_nameHit,HtmlUtil.decodeHtml(Context.variables.showData.roomOwnMasterName));
			}
			
		}
		/**
		 * 更新财富等级 
		 * 
		 */		
		public function updateStarLevel():void
		{
			var roomInfo:Object = Context.variables.showData.roomInfo;
			if(roomInfo.hasOwnProperty("masterStarLevel"))
			{
				var type:String = (int(roomInfo.masterStarLevel) > 25) ? ".swf" : ".png";
				_levelMc.url = BASE_URL + "lv" + roomInfo.masterStarLevel + type;
			}
		}
		/**
		 * 更新艺人地址 
		 * 
		 */		
		public function updateLocation():void
		{
			var roomInfo:Object = Context.variables.showData.roomInfo;
			if(roomInfo.hasOwnProperty("masterLocation"))
			{
				_locationText.text = roomInfo.masterLocation;
				_locationText.width = _locationText.textWidth + 4;
			}
		}
		
		public function updateLiveTime():void
		{
			var roomInfo:Object = Context.variables.showData.roomInfo;
			if(roomInfo.hasOwnProperty("masterLiveTime") && roomInfo.masterLiveTime != "")
			{
				if(roomInfo.masterLiveTime == "0")
					_liveTimeText.text = "未直播";
				else
				    _liveTimeText.text = roomInfo.masterLiveTime + " 直播";
				_liveTimeText.width = _liveTimeText.textWidth + 4;
			}
//			else
//			{
//				var e:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
//				e.listen(SEvents.CONNECT_STREAM_SUCCESS, function(data:Object):void{
//					var date:Date = new Date();
//					_liveTimeText.text = date.hours + ":" + date.minutes +  " 直播";
//					_liveTimeText.width = _liveTimeText.textWidth + 4;
//				});
//			}
		}
		/**
		 * 更新显示列表 
		 * 
		 */		
		public function updateDisplayList():void
		{						
			_levelMc.x = _nameText.x + _nameText.width + 2;
			
		}
		/**
		 * 弹出用户选项卡 
		 * @param e
		 * 
		 */		
		private function popUserCard(e:MouseEvent):void{
			if(_nameText.text != ""){
				var stagePos:Point=this.localToGlobal(new Point(this._nameHit.x+this._nameHit.width+5,this._nameHit.y));
				(Context.getContext(CEnum.USER) as IUser).showCard(Context.variables.showData.roomOwnMasterID, stagePos,[UserCardData.HIDE_MIC_LIST]);
			}
			e.stopPropagation();
		}
	}
}