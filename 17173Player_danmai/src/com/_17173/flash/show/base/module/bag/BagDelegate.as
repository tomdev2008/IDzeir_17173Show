package com._17173.flash.show.base.module.bag
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	
	/**
	 *背包模块 delegate 
	 * @author yeah
	 * 
	 */	
	public class BagDelegate extends BaseModuleDelegate
	{
		
		public function BagDelegate()
		{
			super();
			this._e.listen(SEvents.BAG_UPDATE, requestBagList);
			this._e.listen(SEvents.BAG_GET_INFO, requestBagInfo);
			this._e.listen(SEvents.BAG_MALL_BUY, requestMallBuy);
			this._e.listen(SEvents.BAG_MALL_SWITCHPROP, requestMmallSwitchprop);
			this._e.listen(SEvents.BAG_MALL_SWITCHAUTORENEW, requestMmallSwitchautorenew);
		}
		
		/**
		 *请求背包基础数据 
		 */		
		private function requestBagInfo():void
		{
			_s.http.getData(SEnum.MALL_FINDFC, {json:1}, requestBagInfoSucc, onFail);
		}
		
		/**
		 *背包信息返回 
		 * @param $data
		 */		
		private function requestBagInfoSucc($data:Object):void
		{
			module.data = {"updateBagInfo":[$data]};
		}
		
		/**
		 *获取背包列表分页信息 
		 * @param $data $data.type一级分类id $data.page请求的页面index $data.pageSize：每页个数
		 */		
		private function requestBagList($data:Object):void
		{
			$data.json = 1;
			$data.ajax = 1;
			_s.http.getData(SEnum.MALL_BACKPACKS, $data, requestBagListSucc, onFail);
		}
		
		/**
		 * 获取背包信息成功
		 * @param $data
		 */		
		private function requestBagListSucc($data:Object):void
		{
			module.data = {"updateBagList":[$data]};
		}
		
		/**
		 *购买或者续费 
		 * gId:商品id
    	* timeType:购买时长类型(0=7天，1=一个月，2=两个月，3=三个月，4=六个月，5=一年)
    	* buyType:购买类型(0=购买，1=续费)
    	 *toMasterId:被赠送人id
		 */		
		private function requestMallBuy($data:Object):void
		{
			if(!checkLogin())
			{
				return;
			}
			_s.http.getData(SEnum.MALL_BUY, $data, requestMallBuySucc, requestMallBuySucc, true);
		}
		
		/**
		 *购买、续费成功 
		 * @param $data
		 */		
		private function requestMallBuySucc($data:Object):void
		{
			module.data = {"updateItemDate":[$data]};
		}
		
		/**
		 * 切换商品使用状态
		 * @param $data
		 */		
		private function requestMmallSwitchprop($data:Object):void
		{
			if(!checkLogin())
			{
				return;
			}
			_s.http.getData(SEnum.MALL_SWITCHPROP, $data, requestMmallSwitchpropSucc, onFail);
		}
		
		/**
		 * 切换商品使用状态成功
		 * @param $data
		 */		
		private function requestMmallSwitchpropSucc($data:Object):void
		{
			module.data = {"updateItemUseState":[$data]};
		}
		
		/**
		 *切换自动续费状态 
		 * @param $data
		 */		
		private function requestMmallSwitchautorenew($data:Object):void
		{
			if(!checkLogin())
			{
				return;
			}
			_s.http.getData(SEnum.MALL_SWITCHAUTORENEW, $data, requestMmallSwitchautorenewSucc, onFail);
		}
		
		/**
		 *切换状态成功 
		 * @param $data
		 */		
		private function requestMmallSwitchautorenewSucc($data:Object):void
		{
			//此处不做处理
//			module.data = {"updateAutoReNew":[$data]};
		}
		
		/**
		 *获取背包信息失败 
		 * @param $data
		 */		
		private function onFail($data:Object):void
		{
			
		}
		
		/**
		 *是否处于登陆状态 
		 */		
		private function checkLogin():Boolean
		{
			var isLogin:Boolean = false;
			var showdata:Object = Context.variables["showData"];
			isLogin =  (showdata && showdata.masterID !=null && int(showdata.masterID) > 0);
			
			if(!isLogin)
			{
				Context.getContext(CEnum.EVENT).send(SEvents.LOGINPANEL_SHOW);
			}
			
			return isLogin;
		}
	}
}