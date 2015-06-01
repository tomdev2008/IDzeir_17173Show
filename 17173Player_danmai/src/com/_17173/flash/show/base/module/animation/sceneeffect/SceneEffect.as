package com._17173.flash.show.base.module.animation.sceneeffect
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.model.MessageVo;
	import com._17173.flash.show.base.module.animation.IAnimationFactory;
	import com._17173.flash.show.base.module.animation.base.AnimationType;
	import com._17173.flash.show.base.module.animation.base.IAnimationPlay;
	import com._17173.flash.show.model.CEnum;

	public class SceneEffect extends BaseModule
	{
		private var _bac:SceneEffectControl=null;
		private var _layer:SceneEffectLayer=null;
		private var _event:IEventManager=null;
		private var _cacheMsg:Array=null;

		public function SceneEffect()
		{
			super();
			_version="0.0.1";
			_cacheMsg=[];
		}

		override protected function init():void
		{
			_layer=new SceneEffectLayer();
			this.addChild(_layer);
			//创建控制类
			_bac=new SceneEffectControl(AnimationType.ATYPE_SCENE_CE, _layer);
			_bac.startPlay();
			_bac.playEndCallBack=onNext;
		}


		public function addGiftAmt(obj:Object):void
		{

			var giftClose:Boolean=false;

			//如果关闭礼物效果则不显示
			var showGift:Boolean=Context.variables["showData"].showGift;
			if (showGift == false)
			{
				giftClose=true;
			}
			//本地关闭
			var localshowGift:Boolean=Context.variables["showData"].selfGiftShow;
			if (localshowGift == false)
			{
				giftClose=true;
			}
			if (giftClose)
			{
				onEffectClose();
			}
			try
			{
				var message:MessageVo=new MessageVo();
				message.sName=obj.name;
				message.effectType=obj.enterEffectType;
				message.giftKey=obj.enterEffectSwfKey;
				message.giftSwfPath=obj.enterEffectPath;
				_cacheMsg.push(message);
				onNext();
			}
			catch (e:Error)
			{
				Debugger.log(Debugger.ERROR, "[SceneEffect]", "数据错误", obj);
			}
		}


		private function onNext():void
		{
			if (_cacheMsg && _cacheMsg.length > 0)
			{
				var obj:Object=_cacheMsg.shift();
				//测试代码
				obj.effectType = AnimationType.ATYPE_SCENE_TS;
				obj=setupType(obj);
				var at:IAnimationPlay;
				var ac:IAnimationFactory = (Context.getContext(CEnum.ANIMATIONFACTORY) as IAnimationFactory);
				if (checkGiftTypePass(obj.effectType))
				{
//					obj.giftKey = "qingrenjie_nvshen_201501231502";
					at=ac.getAmd(obj.giftSwfPath, obj.effectType, _layer);
//					at = ac.getAmd("assets/nvshen.swf",obj.effectType,_layer);
					at.data=obj;
				}
				addAmdData(at);
			}
		}


		/**
		 *根据数据获取动画类型
		 * @param data
		 * @return
		 *
		 */
		private function setupType(data:Object):Object
		{
			var type:String=data.effectType;
			switch (data.effectType)
			{
				case AnimationType.ATYPE_STOPSCENE:
				{
					data.effectType=AnimationType.ATYPE_SCENE_CE;
					break;
				}
				case AnimationType.ATYPE_SCENE_TS:
				{
					data.effectType = AnimationType.ATYPE_SCENE_TS;
					break;
				}
			}
			return data;
		}

		private function checkGiftTypePass(type:String):Boolean
		{
			if (type == AnimationType.ATYPE_SCENE_CE || type == AnimationType.ATYPE_SCENE_TS)
			{
				return true;
			}
			return false;
		}

		/**
		 *添加动画
		 * @param amtd
		 *
		 */
		public function addAmdData(amtd:IAnimationPlay):void
		{
			_bac.addData(amtd);
		}

		public function onEffectClose(data:Object=null):void
		{
			this.visible=false;
		}

		public function onEffectOpen(data:Object=null):void
		{
			this.visible=true;
		}

		/**
		 * 清空所有数据和当前动画
		 */
		private function clear():void
		{
		}
	}
}
