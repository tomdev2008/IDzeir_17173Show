package com._17173.flash.show.base.module.video.base
{
	import com._17173.flash.core.components.base.BaseContainer;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.authority.AuthorityStaitc;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.context.user.User;
	import com._17173.flash.show.base.module.dingyue.DingyueBtn;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 *  操作界面
	 * @author qiuyue
	 * 
	 */	
	public class OperationPanel extends BaseContainer
	{
	
		private var _e:IEventManager = null;
		private var _s:IServiceProvider = null;
		/**
		 *  操作按钮
		 */		
		private var _operationBtn:Button;
		/**
		 *订阅按钮 
		 */		
		private var _dingyueBtn:DingyueBtn = null;
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
		
		/**
		 * 麦序 
		 */		
		private var _micIndex:int = -1;
		public function OperationPanel(micIndex:int = -1)
		{
			super();
			this._micIndex = micIndex;
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			_bg = new OperationBg();
			this.addChild(_bg);
			_bg.mouseEnabled = false;
			_bg.mouseChildren = false;
			_bg.visible = false;
			_operationBtn = new Button(Context.getContext(CEnum.LOCALE).get("operation", "camModule"));
			_operationBtn.width = 46;
			_operationBtn.height = 22;
			_operationBtn.x = 0;
			_operationBtn.y = 0;
			_operationBtn.addEventListener(MouseEvent.CLICK,opClick);
			this.addChild(_operationBtn);
			
			
			_dingyueBtn =  new DingyueBtn(_micIndex==1);
			_dingyueBtn.x = _operationBtn.x +  _operationBtn.width;
			_dingyueBtn.y = _operationBtn.y;
			_dingyueBtn.width = 60;
			_dingyueBtn.height = 22;
			_dingyueBtn.addEventListener("ButtonResieze",onDingyueResize);
			//设置房主ID
			this.addChild(_dingyueBtn);
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
				if(_micIndex != -1){
//					上麦
					can = user.validateAuthority(user.me,AuthorityStaitc.THING_15).can;
					if(can && _micIndex != user.getMicIndex(user.me.id)){
						var upCam:OperationItem = new OperationItem();
						upCam.updateItem(new UpCamIcon(),Context.getContext(CEnum.LOCALE).get("upCamIcon", "camModule"),upCamVideo);
						_listGroup.addChild(upCam);
					}
//					下麦
					var order1:Object = Context.variables.showData.order[_micIndex];
					if(order1){
						var user1:IUserData =  user.getUser(order1.masterId);
						if(user1){
							can = user.validateAuthorityTo(user.me, AuthorityStaitc.THING_43,user1).can;
						}else{
							can = user.validateAuthority(user.me, AuthorityStaitc.THING_43).can;
						}
						Debugger.log(Debugger.INFO, "[OperationPanel]" + user.me.auth + "   " + can);
						if(can || _micIndex == user.getMicIndex(user.me.id)){
							var downCam:OperationItem = new OperationItem();
							downCam.updateItem(new DownCamIcon(),Context.getContext(CEnum.LOCALE).get("downCamIcon", "camModule"),downCamVideo);
							_listGroup.addChild(downCam);
						}
					}
//					开闭麦
					can = user.validateAuthority(user.me,AuthorityStaitc.THING_17).can;
					if(can || user.me.id == Context.variables.showData.masterID){
						var closeSound:OperationItem = new OperationItem();
						var movieClip:MovieClip = new CloseSoundIcon();
						movieClip.stop();
						var order:Object = Context.variables.showData.order[_micIndex];
						if(order){
							if(order.isMute == 0){
								movieClip.gotoAndStop(1);
								closeSound.updateItem(movieClip,Context.getContext(CEnum.LOCALE).get("bimai", "camModule"),closePushSound);
							}else{
								movieClip.gotoAndStop(2);
								closeSound.updateItem(movieClip,Context.getContext(CEnum.LOCALE).get("kaimai", "camModule"),openPushSound);
							}
						}else{
							closeSound.updateItem(movieClip,Context.getContext(CEnum.LOCALE).get("kaimai", "camModule"),openPushSound);
						}
						_listGroup.addChild(closeSound);
					}
				}
			}else{
				if(!_listGroup){
					_listGroup = new VGroup();
				}
				_listGroup.removeChildren();
			}
			_bg.visible = !_isListShow;
			_isListShow = !_isListShow;
			_listGroup.y = -_listGroup.height - 2;
			_bg.x = _operationBtn.x;
			_listGroup.x = _operationBtn.x;
			_bg.y = -_listGroup.height - 2;
			_bg.height = _listGroup.height;
		}
		
		override protected function onRePosition():void{
			rePostion();
		}
		private function rePostion():void{
			_dingyueBtn.x = this.width - _dingyueBtn.width + 2;
			_operationBtn.x = this._dingyueBtn.x - _operationBtn.width - 2;
		}
		
		/**
		 *订阅按钮更新宽度 
		 * @param e
		 * 
		 */		
		private function onDingyueResize(e:Event):void{
			rePostion();
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
		 * 上麦操作 
		 * 
		 */		
		private function upCamVideo():void
		{
			var obj:Object = Context.variables.showData;
			_e.send(SEvents.MIC_UP,{"userId":Context.variables.showData.masterID, "micIndex":_micIndex});
			if(!Context.variables.showData.camInit){
				_e.send(SEvents.INIT_CAM_PREVIEW);
			}
			hideList();
		}
		/**
		 * 下麦操作 
		 * 
		 */		
		private function downCamVideo():void
		{
			_e.send(SEvents.MIC_DOWN,{"micIndex":_micIndex});
			hideList();
		}
		/**
		 * 闭麦 
		 * 
		 */		
		private function closePushSound():void
		{
			_e.send(SEvents.MIC_SOUND_CLOSE,{"micIndex":_micIndex, "userId":Context.variables.showData.order[_micIndex].masterId});
			hideList();
		}
		/**
		 * 开麦 
		 * 
		 */		
		private function openPushSound():void
		{
			_e.send(SEvents.MIC_SOUND_OPEN,{"micIndex":_micIndex, "userId":Context.variables.showData.order[_micIndex].masterId});
			hideList();
		}
		/**
		 * 送礼点击 
		 * @param e
		 * 
		 */		
		private function preClick(e:MouseEvent):void
		{
			e.stopPropagation();
			var order:Object = Context.variables.showData.order[_micIndex];
			if(order != null){
				_e.send(SEvents.ADD_TO_GIFT_SELECT_USERS,order.masterId);
			}
		}
		
		override public function update():void{
			var order:Object = Context.variables.showData.order[_micIndex];
			var iUser:IUser = Context.getContext(CEnum.USER) as IUser;
			if(order){
				//更新订阅
				_dingyueBtn.setData(order.masterId);
				if(iUser.getMicIndex(iUser.me.id) == _micIndex){
					this._operationBtn.visible = true;
					this._dingyueBtn.visible = true;
				}else{
					var user:User = Context.getContext(CEnum.USER) as User;
					
					var can:Boolean;
					var user1:IUserData =  user.getUser(order.masterId);
					if(user1){
						can = user.validateAuthorityTo(user.me, AuthorityStaitc.THING_43,user1).can;
					}else{
						can = user.validateAuthority(user.me, AuthorityStaitc.THING_43).can;
					}
					if(!user.validateAuthority(user.me,AuthorityStaitc.THING_15).can && !can && !user.validateAuthority(user.me,AuthorityStaitc.THING_17).can){
						this._operationBtn.visible = false;
						
					}else{
						this._operationBtn.visible = true;
					}
					this._dingyueBtn.visible = true;
				}
			}else{
				this._operationBtn.visible = false;
				this._dingyueBtn.visible = false;
			}
			hideOper();
		}
	}
}