package com._17173.flash.show.module.video.bottom
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.context.authority.AuthorityStaitc;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.user.User;
	import com._17173.flash.show.base.module.dingyue.DingyueBtn;
	import com._17173.flash.show.base.module.video.base.OperationItem;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 *  操作界面
	 * @author qiuyue
	 * 
	 */	
	public class BottomPanel extends Sprite
	{
		
		private var _e:IEventManager = null;
		private var _s:IServiceProvider = null;
		/**
		 * 麦序 
		 */		
		private var _micIndex:int = -1;
		/** 艺人信息面板  **/	
		private var _masterPanel:MasterPanel;
		/**
		 *订阅按钮 
		 */		
		private var _dingyueBtn:DingyueBtn = null;
		
		/**
		 *  操作按钮
		 */		
		private var _operationBtn:Button;
		/**
		 * 操作列表 
		 */		
		private var _listGroup:VGroup;
		/**
		 * 是否显示List 
		 */		
		private var _isListShow:Boolean = false;
		/**
		 * 列表背景 
		 */		
		private var _bg:OperationBg;
		
		public function BottomPanel(micIndex:int = -1)
		{
			super();
			
			this.graphics.clear();
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,0,480,44);
			this.graphics.endFill();
			
			this._micIndex = micIndex;
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			
			_masterPanel = new MasterPanel();
			this.addChild(_masterPanel);
			
			_bg = new OperationBg();
			this.addChild(_bg);
			_bg.visible = false;
			_operationBtn = new Button(Context.getContext(CEnum.LOCALE).get("operation", "camModule"));
			_operationBtn.width = 46;
			_operationBtn.height = 22;
			_operationBtn.x = 432;
			_operationBtn.y = -22;
			_operationBtn.addEventListener(MouseEvent.CLICK,opClick);
			this.addChild(_operationBtn);
			
		
			_dingyueBtn =  new DingyueBtn(_micIndex==1);
			_dingyueBtn.x = 176;
			_dingyueBtn.y = 42 - _dingyueBtn.height;
			_dingyueBtn.width = 60;
			_dingyueBtn.height = 22;
			//设置房主ID
			_dingyueBtn.setData(Context.variables.showData.roomOwnMasterID)
//			_dingyueBtn.addEventListener("ButtonResieze",onDingyueResize);
			this.addChild(_dingyueBtn);
		}
	
        public function get masterPanel():MasterPanel
		{
			return _masterPanel;
		}
		
		/**
		 *  操作点击
		 * @param e
		 * 
		 */		
		private function opClick(e:MouseEvent = null):void
		{
			if(!_isListShow){
				if(!_listGroup){
					_listGroup = new VGroup();
				}
				if(!this.contains(_listGroup)){
					this.addChild(_listGroup);
				}
				_listGroup.removeChildren();
				var can:Boolean;
				var user:User = Context.getContext(CEnum.USER) as User;
				var liveInfo:Object = Context.variables.showData.liveInfo;
				if(_micIndex != -1){
					can = user.validateAuthority(user.me,AuthorityStaitc.THING_43).can;
					if(can || liveInfo.liveId != 0){
						var downCam:OperationItem = new OperationItem();
						downCam.updateItem(new DownCamIcon(),Context.getContext(CEnum.LOCALE).get("closeCam", "camModule"),downCamVideo);
						_listGroup.addChild(downCam);
					}
					//					照相功能
					//					if(user.me.id == liveInfo.masterId){
					//						var photo:OperationItem = new OperationItem();
					//						photo.updateItem(new PhotoIcon(),Context.getContext(CEnum.LOCALE).get("photo", "camModule"),photoShow);
					//						_listGroup.addChild(photo);
					//					}
					can = user.validateAuthority(user.me,AuthorityStaitc.THING_17).can;
					if(can){
						var sound:OperationItem = new OperationItem();
						var movieClip:MovieClip = new CloseSoundIcon();
						movieClip.stop();
						if(liveInfo){
							if(liveInfo.isMute == 0){
								movieClip.gotoAndStop(1);
								sound.updateItem(movieClip,Context.getContext(CEnum.LOCALE).get("bimai", "camModule"),closePushSound);
							}else{
								movieClip.gotoAndStop(2);
								sound.updateItem(movieClip,Context.getContext(CEnum.LOCALE).get("kaimai", "camModule"),openPushSound);
							}
						}else{
							sound.updateItem(movieClip,Context.getContext(CEnum.LOCALE).get("kaimai", "camModule"),openPushSound);
						}
						_listGroup.addChild(sound);
					}
				}else{
				}
			}else{
				if(!_listGroup){
					_listGroup = new VGroup();
				}
				_listGroup.removeChildren();
			}
			_bg.visible = !_isListShow;
			_isListShow = !_isListShow;
			_listGroup.x = _operationBtn.x - _listGroup.width + _operationBtn.width;
			_listGroup.y = -_listGroup.height - _operationBtn.height;
			_bg.x = _listGroup.x;
			_bg.y = _listGroup.y;
			_bg.height = _listGroup.height;
		}
		
		private function hideOper():void{
			_bg.visible = false;
			_isListShow = false;
			if(_listGroup){
				_listGroup.removeChildren();
			}
		}
		
		/**
		 * 隐藏列表 
		 * 
		 */		
		private function hideList():void
		{
			opClick();
		}
		/**
		 * 下麦操作 
		 * 
		 */		
		private function downCamVideo():void
		{
			_e.send(SEvents.MIC_DOWN);
			hideList();
		}
		/**
		 * 闭麦 
		 * 
		 */		
		private function closePushSound():void
		{
			_e.send(SEvents.MIC_SOUND_CLOSE);
			hideList();
		}
		/**
		 * 开麦 
		 * 
		 */		
		private function openPushSound():void
		{
			_e.send(SEvents.MIC_SOUND_OPEN);
			hideList();
		}
		/** 
		 *  照相功能
		 * 
		 */		
		private function photoShow():void
		{
			_e.send(SEvents.PHOTO_SHOW_MESSAGE);
			hideList();
			
		}
		/**
		 * 送礼点击 
		 * @param e
		 * 
		 */		
		private function preClick(e:MouseEvent):void
		{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo != null){
				_e.send(SEvents.ADD_TO_GIFT_SELECT_USERS,liveInfo.masterId);
			}
		}
		
	    public function update():void{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			var user:User = (Context.getContext(CEnum.USER) as User);
			if(liveInfo && liveInfo.hasOwnProperty("masterId") && liveInfo.masterId != 0){
				if(liveInfo.masterId == user.me.id){
					this._operationBtn.visible = true;
				}else{
					var can:Boolean;
					if(!user.validateAuthority(user.me,AuthorityStaitc.THING_43).can && !user.validateAuthority(user.me,AuthorityStaitc.THING_17).can){
						this._operationBtn.visible = false;
						
					}else{
						this._operationBtn.visible = true;
					}
				}
			}else{
				this._operationBtn.visible = false;
			}
			hideOper();
		}
	}
}
