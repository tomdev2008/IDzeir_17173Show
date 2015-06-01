package com._17173.flash.show.base.module.gift
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.base.context.module.IModuleManager;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.model.MessageVo;
	import com._17173.flash.show.base.module.animation.base.AnimationType;
	import com._17173.flash.show.base.module.animation.biganimation.BigAnimationDelegate;
	import com._17173.flash.show.base.module.animation.cac.CACConfig;
	import com._17173.flash.show.base.module.animation.cac.CocktailAndChampagneDelegate;
	import com._17173.flash.show.base.module.animation.carmini.CarRunwayDelegate;
	import com._17173.flash.show.base.module.animation.flowermini.FlowerMiniDelegate;
	import com._17173.flash.show.base.module.gift.data.GiftInfo;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.PEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	import flash.net.URLVariables;

	public class GiftDelegate extends BaseModuleDelegate
	{
		/**
		 *迷你鲜花是否加载完成 
		 */		
		private var _flowerMiniLoaded:Boolean = false;
		/**
		 *大动画是否加载完成 
		 */		
		private var _bigEffLoaded:Boolean = false;
		/**
		 *小车动画加载是否完成 
		 */		
		private var _carrunwayLoaded:Boolean = false;
		/**
		 *香槟鸡尾酒是否加载完成 
		 */		
		private var _cacEffLoaded:Boolean = false;
		private var _giftReady:Boolean = false;
		private var _giftCacheMsg:Array;
		private var _cacheMsg:Array;
		
		private var _effectTypePassList:Array;

		public function GiftDelegate()
		{
			super();
			_s.socket.listen(SEnum.R_GIFT_MSG.action, SEnum.R_GIFT_MSG.type, 
				function(value:Object):void{
					excute(onGiftCache,value);});
			_s.socket.listen(SEnum.R_CENTER_MSG.action, SEnum.R_CENTER_MSG.type,function(value:Object):void{
				excute(onCenterCache,value);});
			_s.socket.listen(SEnum.R_GIFT_MESSAGE.action, SEnum.R_GIFT_MESSAGE.type, onGiftMessage);
			_s.socket.listen(SEnum.R_ACT_GIFT_MESSAGE.action, SEnum.R_ACT_GIFT_MESSAGE.type, onActGiftMessage);
			_s.socket.listen(SEnum.LUCKGIFT_MSG.action,SEnum.LUCKGIFT_MSG.type,function(value:Object):void{
				excute(luckMessage,value);});
			_cacheMsg = [];
			_giftCacheMsg = [];
			_effectTypePassList = [];
			initPassList();
		}
		/**
		 *初始化大动画类型过滤，以用户礼物数据派发 
		 * 
		 */		
		private function initPassList():void{
			_effectTypePassList[_effectTypePassList.length] = AnimationType.ATYPE_CAR;
			_effectTypePassList[_effectTypePassList.length] = AnimationType.ATYPE_FLOWER;
			_effectTypePassList[_effectTypePassList.length] = AnimationType.ATYPE_TUZI;
			_effectTypePassList[_effectTypePassList.length] = AnimationType.ATYPE_TECH;
			_effectTypePassList[_effectTypePassList.length] = AnimationType.ATYPE_GUOQING1;
			_effectTypePassList[_effectTypePassList.length] = AnimationType.ATYPE_GUOQING2;
			_effectTypePassList[_effectTypePassList.length] = AnimationType.ATYPE_D11;
			_effectTypePassList[_effectTypePassList.length] = AnimationType.ATYPE_SHOWNAME;
		}

		override protected function onModuleLoaded():void
		{
			super.onModuleLoaded();
			//读取配置
			var conft:Object = Context.variables["conf"];
			CACConfig.getInstans().setup(conft.cacConfig);
			getGiftData();
		}

		private function getGiftData():void
		{
			Debugger.log(Debugger.INFO, "[init]", "礼物数据开始加载!");
			regGiftEffDelegate();
			var roomData:URLVariables = new URLVariables();
			roomData["roomId"] = Context.variables["roomId"];
			_s.http.getData(SEnum.GET_GIFT, roomData, onGiftData, onGiftDataError);
		}

		private function onGiftData(data:Object):void
		{
			Debugger.log(Debugger.INFO, "[init]", "解析礼物数据!");
			try
			{
				GiftInfo.getInstance().setupGiftInfo(data);
			}
			catch (error:Error)
			{
				Debugger.log(Debugger.INFO, "[init]", "解析礼物数据失败!");
			}
			_e.send(SEvents.REG_SCENE_POS, _swf);
			_e.send(SEvents.GIFT_DATA_LOAD_CMP);
			checkEffStatus();
			addServerLsn();
		}


		private function regGiftEffDelegate():void
		{
			//加载动画模块
			var m:IModuleManager = Context.getContext(CEnum.MODULE) as IModuleManager;
			//加载动画模块
			if (!m.get(PEnum.BIGANIMATION))
			{
				m.regDelegate(PEnum.BIGANIMATION, BigAnimationDelegate);
				m.load(PEnum.BIGANIMATION);
			}

			if (!m.get(PEnum.CARRUNWAY))
			{
				m.regDelegate(PEnum.CARRUNWAY, CarRunwayDelegate);
				m.load(PEnum.CARRUNWAY);
			}

			if (!m.get(PEnum.FLOWERMINI))
			{
				m.regDelegate(PEnum.FLOWERMINI, FlowerMiniDelegate);
				m.load(PEnum.FLOWERMINI);
			}
			if (!m.get(PEnum.CACEFFECT))
			{
				m.regDelegate(PEnum.CACEFFECT, CocktailAndChampagneDelegate);
				m.load(PEnum.CACEFFECT);
			}

		}


		private function addServerLsn():void
		{
			//监听用户信息改变 如头像，名字，图标
			//监听广播消息
			//监听 按钮数据信息
			var server:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			//监听礼物消息
			_s.socket.listen(SEnum.CHANGE_GIFT_EFF.action, SEnum.CHANGE_GIFT_EFF.type, serverGiftEff);
			_e.listen(SEvents.GIFT_EFF_CHANGE, localGiftEff);
			_e.listen(SEvents.FW_MODULE_LOADED, moduleLoaded);
		}

		private function onGiftCache(data:Object):void
		{
			var tmpArr:Array = data.ct as Array;
			var len:int = tmpArr.length;
			for (var i:int = 0; i < len; i++)
			{
				var vo:MessageVo = MessageVo.getMsgVo(JSON.parse(tmpArr[i]));
				_cacheMsg.push(vo);
			}
			sendGiftCache();
		}


		private function sendGiftCache():void
		{
			if (_flowerMiniLoaded)
			{
				_e.send(SEvents.GIFT_ANIMATION_HX, _cacheMsg);
			}
		}

		/**
		 *如果是小花模块加载完成
		 * @param name
		 *
		 */
		private function moduleLoaded(name:String):void
		{
			if (name == PEnum.FLOWERMINI)
			{
				_flowerMiniLoaded = true;
				if(_cacheMsg != null){
					_e.send(SEvents.GIFT_ANIMATION_HX, _cacheMsg);
					_cacheMsg = null;
				}
			}
			if(name == PEnum.BIGANIMATION){
				_bigEffLoaded = true;
			}
			if(name == PEnum.CACEFFECT){
				_cacEffLoaded = true
			}
			if(name == PEnum.CARRUNWAY){
				_carrunwayLoaded = true
			}
			checkReady();
		}
		
		/**
		 *检测是否礼物相关模块全部加载完毕，然后将缓存信息发送出去 
		 * 
		 */		
		private function checkReady():void{
			if(_cacEffLoaded && _carrunwayLoaded && _flowerMiniLoaded && _bigEffLoaded){
				_giftReady = true;
				var obj:Object;
				var len:int = _giftCacheMsg.length
				for (var i:int = 0; i < len; i++) 
				{
					obj = _giftCacheMsg[i];
					onGiftMessage(obj);
				}
				
			}
		}
		
		/**
		 *幸运里布跑道 
		 * @param data
		 * 
		 */		
		private function luckMessage(data:Object):void{
			//整理数据
			var infos:Array = (data.ct as Array);
			var len:int = infos.length;
			for (var i:int = 0; i < len; i++) 
			{
				var gdata:Object = infos[i];
				var vo:MessageVo = MessageVo.getMsgVo(null);
				vo.sName = gdata.nickName;
				vo.giftName = gdata.giftName;
				vo.giftCount = gdata.count;
				vo.giftNum = gdata.giftNum;
				vo.price = gdata.totalPrice;
				vo.giftSwfPath = gdata.giftEffectUrl;
				vo.giftKey = gdata.giftEffectSwfKey;
				vo.effectType = AnimationType.ATYPE_D11;
				_e.send(SEvents.GIFT_BIG_ANIMATION,vo);
			}
			
			
		}

		/**
		 *本地关闭开启礼物效果
		 * @param data
		 *
		 */
		private function localGiftEff(data:Object = null):void
		{
			checkEffStatus();
		}

		/**
		 *服务器开启关闭房间礼物效果
		 * @param data
		 *
		 */
		private function serverGiftEff(data:Object):void
		{
			var status:int = data.ct.giftShow;
			var showData:ShowData = Context.variables["showData"] as ShowData;
			showData.giftShow = status;
//			_e.send(SEvents.GIFT_EFF_CHANGE);
			checkEffStatus();
		}

		/**
		 * 控制礼物开关逻辑
		 */
		private function checkEffStatus():void
		{
			var showData:ShowData = Context.variables["showData"] as ShowData;
//			Debugger.log(Debugger.INFO, "[gift]", "礼物开关状态: " + showData.showGift);
			if (showData.showGift)
			{
				_e.send(SEvents.GIFT_EFFECT_OPEN);
			}
			else
			{
				_e.send(SEvents.GIFT_EFFECT_CLOSE);
			}
		}
		/**
		 *接受到双节活动数据 
		 * @param data
		 * 
		 */		
		private function onActGiftMessage(data:Object):void{
			//对活动数据进行转发
			if(data.ct.activity == 0){
				data.ct.effectType = AnimationType.ATYPE_TUZI;
			}else if(data.ct.activity == 1){
				data.ct.effectType = AnimationType.ATYPE_TECH;
			}
			sentToModule(data,false);
		}
		
		/**
		 *送礼消息回显 
		 * @param data
		 * 
		 */		
		private function onCenterCache(data:Object):void{
			//trace("发送cmg");
			data.ct.time = data.timestamp;
			data = data.ct;
			var vo:MessageVo = MessageVo.getMsgVo(data);
			_e.send(SEvents.CENTER_MESSAGE, vo);
		}
		
		private function onGiftMessage(data:Object):void
		{
				//test
//				if(!_giftReady){
//					_giftCacheMsg.push(data);
					if(Context.variables["debug"]){
						Debugger.log(Debugger.INFO, "[init]", "动画模块加载信息","小花："+ _flowerMiniLoaded + "　大花：" +_bigEffLoaded　+　"小车:" + _carrunwayLoaded + "香槟：" +　_cacEffLoaded);
					}
//					return;
//				}
				sentToModule(data);
		}
		/**
		 *发送到其他模块 
		 * @param data  数据
		 * @param isSendChat 是否发送到聊天区
		 * 
		 */		
		private function sentToModule(data:Object,isSendChat:Boolean = true):void{
			try{
				data.ct.time = data.timestamp;
				data = data.ct;
				if(Context.variables["debug"]){
					Debugger.log(Debugger.INFO, "[init]", "接收到礼物消息" ,data);
				}
				var vo:MessageVo = MessageVo.getMsgVo(data);
				//			转发业务消息
				if(vo.giftType == "1502"){
					_e.send(SEvents.SUP_GIFT_MESSAGE, vo);
				}
				else if(isSendChat && vo.canSendChat){
					_e.send(SEvents.NORMAL_GIFT_MESSAGE, vo);
				}
				//如果是中心区域消息
				if (vo.showCenter == 1)
				{
					_e.send(SEvents.CENTER_MESSAGE, vo);
				}
				
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
				//如果关闭动画，则判断是否是鲜花动画，如果是则派发小花动画缓动事件
				if(giftClose){
					if(vo.effectType == AnimationType.ATYPE_FLOWER){
						Debugger.log(Debugger.INFO, "[gift]", "显示小花");
						Context.getContext(CEnum.EVENT).send(SEvents.GIFT_ANIMATION_HX,[vo]);
					}
					return;
				}
				
				//判断是否是组图
				if(data.hasOwnProperty("giftCoEffectPower") && data.giftCoEffectPower  == 1){
					var vo1:MessageVo = MessageVo.getMsgVo(data);
					if(data.giftCoEffect && data.giftCoEffect != null && data.giftCoEffect != ""){
						vo1.giftSwfPath = data.giftCoEffect;
						vo1.giftKey = data.giftKey;
						vo1.effectType = AnimationType.GROUP_AM;
						_e.send(SEvents.GIFT_BIG_ANIMATION, vo1);
					}
				}
				
				//播放小动画或者大动画(在隐藏动画时不会执行)
				if (vo.effectType == AnimationType.ATYPE_CAC)
				{
					_e.send(SEvents.GIFT_CAC_ANIMATION, vo);
				}
				else
				{
					var type:String = vo.effectType;
					//					_e.send(SEvents.GIFT_ANIMATION, vo);//以前在大动画代理中判断是否播放大动画现在直接放到这里判断，从而减少转发处理逻辑
					//判断是否是大动画类型 或者是手动动画类型
					if(checkSendToBigAnm(type)){
						_e.send(SEvents.GIFT_BIG_ANIMATION,vo);
					}
				}
			}catch(e:Error){
				Debugger.log(Debugger.INFO, "[init]", "发送礼物数据错误",e.message);
			}
		}
		
		/**
		 *检测是否可以发送动画消息 
		 * @param type
		 * @return 
		 * 
		 */
		private function checkSendToBigAnm(type:String):Boolean{
			var result:Boolean = false;
			//车类动画，花类动画//各种活动 
			
			var len:int = _effectTypePassList.length;
			var fType:String = "";
			for (var i:int = 0; i < len; i++) 
			{
				fType = _effectTypePassList[i];
				if(fType == type){
					result = true;
				}
			}
			
			
			if(type == AnimationType.ATYPE_CAR || type == AnimationType.ATYPE_FLOWER  
				|| type == AnimationType.ATYPE_TECH || type == AnimationType.ATYPE_TUZI){
				result = true;
			}
			return result;
		}
		
		

		private function onGiftDataError(data:Object):void
		{
			Debugger.log(Debugger.ERROR, "[init]", "礼物数据加载错误!5秒后重试", data.msg);
			Ticker.tick(5000,getGiftData);
		}
	}
}