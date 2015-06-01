package com._17173.flash.show.base.module.animation.entereffect
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.model.MessageVo;
	import com._17173.flash.show.base.module.animation.IAnimationFactory;
	import com._17173.flash.show.base.module.animation.base.AnimationType;
	import com._17173.flash.show.base.module.animation.base.BaseAmtControl;
	import com._17173.flash.show.base.module.animation.base.BaseAnimationLayer;
	import com._17173.flash.show.base.module.animation.base.IAnimationPlay;
	import com._17173.flash.show.base.module.animation.biganimation.BigAmtControl;
	import com._17173.flash.show.model.CEnum;

	/**
	 *进场动画 
	 * @author zhaoqinghao
	 * 
	 */	
	public class EnterEffect extends BaseModule
	{
		private var _bac:BaseAmtControl = null;
		private var _layer:BaseAnimationLayer = null;
		private var _event:IEventManager = null;
		private var _cacheMsg:Array = null;
		public function EnterEffect()
		{
			super();
			_version = "0.0.1";
			mouseChildren = false;
			mouseEnabled = false;
			_cacheMsg = [];
		}
		
		override protected function init():void{
			_layer = new BaseAnimationLayer();
			this.addChild(_layer);
			//创建控制类
			_bac = new BigAmtControl(AnimationType.ATYPE_ENTER,_layer);
			_bac.startPlay();
			_bac.playEndCallBack = onNext;
		}
		
		
		
		public function addGiftAmt(obj:Object):void{
			
			var giftClose:Boolean = false;
			
			//如果关闭礼物效果则不显示
			var showGift:Boolean = Context.variables["showData"].showGift;
			if (showGift == false)
			{
				giftClose = true;
			}
			//本地关闭
			var localshowGift:Boolean = Context.variables["showData"].selfGiftShow;
			if (localshowGift == false)
			{
				giftClose = true;
			}
			if(giftClose) return;
			
			_cacheMsg.push(obj);
			if(!_bac.playItem && !_bac.loading){
				onNext();
			}
		}
		
		
		private function onNext():void{
			if(_cacheMsg && _cacheMsg.length > 0){
				//进场动画数据进来后是用户信息，从用户信息中
				var obj:IUserData = _cacheMsg.shift() as IUserData;
				var ext:Object = obj.extInfo;
				var name:String = obj.name;
				
				//测试数据开启
//				ext = {"enterEffect":1,"enterEffectType":AnimationType.ATYPE_ENTER};
//				name = "333";
//					
				if(ext && ext.hasOwnProperty("enterEffect") && ext.enterEffect == 1){
					var msg:MessageVo = new MessageVo();
					//组装数据
					msg.sName = name;
					msg.effectType = setupType(ext);
					msg.giftKey = ext.enterEffectSwfKey;
					msg.giftSwfPath = ext.enterEffectPath;
					var at:IAnimationPlay;
					if(msg.effectType == AnimationType.ATYPE_ENTER){
						var ac:IAnimationFactory = (Context.getContext(CEnum.ANIMATIONFACTORY) as IAnimationFactory);
						at = ac.getAmd(msg.giftSwfPath,AnimationType.ATYPE_ENTER,_layer);
//						msg.giftKey = "yingchunjiefu_1441";
//						at = ac.getAmd("assets/ycjf.swf",AnimationType.ATYPE_ENTER,_layer);
						at.data = msg;
					}
					addAmdData(at);
				}else{
					onNext();
				}
			}
		}
		
		/**
		 *根据数据获取动画类型 
		 * @param data
		 * @return 
		 * 
		 */		
		private function setupType(data:Object):String{
			var type:String = AnimationType.ATYPE_ENTER;
			switch(data.enterEffectType)
			{
				case AnimationType.ATYPE_ENTER:
				{
					return AnimationType.ATYPE_ENTER;
					break;
				}
				case AnimationType.ATYPE_ENTER:
				{
					return AnimationType.ATYPE_ENTER;
					break;
				}
			}
			return type;
		}
		
		/**
		 *添加动画 
		 * @param amtd
		 * 
		 */		
		public function addAmdData(amtd:IAnimationPlay):void{
			_bac.addData(amtd);
		}
		
		public function onEffectClose(data:Object = null):void{
			clear();
			this.visible = false;
		}
		
		public function onEffectOpen(data:Object = null):void{
			_bac.startPlay();
			this.visible = true;
		}
		
		/**
		 * 清空所有数据和当前动画 
		 */		
		private function clear():void {
			//清空已缓存的
			_cacheMsg = [];
			_bac.stopPlay();
		}
	}
}