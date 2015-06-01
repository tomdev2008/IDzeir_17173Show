package com._17173.flash.show.base.module.dingyue
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.layer.UIManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.net.ServiceProvider;
	import com._17173.flash.show.base.module.dingyue.ui.DingyueGuideGm;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.ShowData;
	
	import flash.geom.Point;
	
	public class Subscribe extends BaseModule
	{
		private var _extDyPanels:Array = null;
		private var _extDatas:Array = null;
		private var _guide:DingyueGuideGm = null;
		private static const GETDATE_CD:int = 60 * 3 * 1000;
		public function Subscribe()
		{
			super();
			_extDyPanels = [];
			_extDatas = [];
			startLoopYdData();
			_guide = new DingyueGuideGm();
		}
		
		/**
		 *获取数据 
		 * 
		 */		
		private function getDyDate():void{
			(Context.getContext(CEnum.SERVICE) as ServiceProvider).http.getData(SEnum.SUB_SEACH,{},dyDateSucc);
		}
		
		/**
		 *获取数据 
		 * 
		 */		
		private function getDyDate1():void{
			(Context.getContext(CEnum.SERVICE) as ServiceProvider).http.getData(SEnum.SUB_SEACH,{},dyDateSucc);
		}
		
		
		private var testDates:Array;
		private function testDate():void{
			testDates = [];
			testDates[0] = {liveUrl:"http://show.17173.com/1108180506",masterId:41921769,userImg:"http://i1.17173cdn.com/avatar/YWxqaGBf/c7/e4/b7/41226769/small.jpg",nickname:"123顶顶顶顶"};
//			testDates[1] = {liveUrl:"http://show.17173.com/1108180506",masterId:41922769,userImg:"http://i1.17173cdn.com/avatar/YWxqaGBf/c7/e4/b7/41226769/small.jpg",nickname:"123顶顶顶顶"};
//			testDates[2] = {liveUrl:"http://show.17173.com/1108180506",masterId:41923769,userImg:"http://i1.17173cdn.com/avatar/YWxqaGBf/c7/e4/b7/41226769/small.jpg",nickname:"123顶顶顶顶"};
//			testDates[3] = {liveUrl:"http://show.17173.com/1108180506",masterId:41924769,userImg:"http://i1.17173cdn.com/avatar/YWxqaGBf/c7/e4/b7/41226769/small.jpg",nickname:"123顶顶顶顶"};
//			testDates[4] = {liveUrl:"http://show.17173.com/1108180506",masterId:41925769,userImg:"http://i1.17173cdn.com/avatar/YWxqaGBf/c7/e4/b7/41226769/small.jpg",nickname:"123顶顶顶顶"};
//			testDates[5] = {liveUrl:"http://show.17173.com/1108180506",masterId:41926769,userImg:"http://i1.17173cdn.com/avatar/YWxqaGBf/c7/e4/b7/41226769/small.jpg",nickname:"123顶顶顶顶"};
		}
		/**
		 *返回数据 
		 * @param data
		 * 
		 */		
		private function dyDateSucc(data:Array):void{
			//单元测试代码
//			testDate();
//			data = testDates;
			//比较数据
			var showData:Array = getData4OdlData(data);
			//逐个显示
			var dydata:Object;
			var len:int = showData.length;
			for (var i:int = 0; i < len; i++) 
			{
				dydata = showData[i];
				showDYdata(dydata);
			}
			
			//添加到已存在数据
			addData(showData);
		}
		
		/**
		 * 与老数据比较获取本次加家数据(自动去除本房间)
		 * @return 
		 * 
		 */		
		private function getData4OdlData(data:Array):Array{
			var len:int = data.length;
			var len1:int = _extDatas.length;
			
			var tmpDatas:Array = [];
			//去除本房间主播数据
			for (var k:int = 0; k < len; k++) 
			{
				var tData:Object = data[k];
				if(checkIsRoom(tData.masterId)){//检测是否在属于自己房间主播的订阅
					break;
				}else{
					tmpDatas[tmpDatas.length] = tData;
				}
			}
			//去除数据后赋值原数据
			data = tmpDatas;
			len = data.length;
			if(len1 == 0){ //如果当前没存在数据，则直接返回所有
				return data;
			}
			var result:Array = [];
			for (var i:int = 0; i < len; i++) 
			{
				var nData:Object = data[i];//新数据
				for (var j:int = 0; j < len1; j++) 
				{
					try{
						var odata:Object = _extDatas[j];//老数据
						if(odata.masterId == nData.masterId){ //如果主播ID已存在则不添加，暂时不考虑一个主播在两个直播间直播
							break;
						}else if(j == (len1 - 1)){
							result.push(nData);//不重复的添加到返回列表
						}
					}catch(e:Error){
						
					}
				}
			}
			return result;
		}
		
		private function addData(data:Array):void{
			_extDatas = _extDatas.concat(data);
		}
		
		/**
		 *开始轮寻
		 * 
		 */		
		private function startLoopYdData():void{
			var showData:ShowData = Context.variables["showData"] as ShowData;
			if(showData.masterID !=null && int(showData.masterID) > 0){
				//登录才会请求数据
				Ticker.tick(GETDATE_CD,getDyDate,-1);
				Ticker.tick(10000,getDyDate1);
			}
			
		}
		/**
		 *停止轮训 
		 * 
		 */		
		private function stopLoopYdData():void{
			Ticker.stop(getDyDate);
		}
		
		
		/**
		 *展示一个订阅信息 
		 * @param data
		 * 
		 */		
		private function showDYdata(data:Object):void{
			var string:String = JSON.stringify(data);
			var dy:DingyuePanel = new DingyuePanel();
			dy.setDate(data);
			dy.rePostion();
			(Context.getContext(CEnum.UI) as UIManager).popupPanel(dy,new Point(dy.x,dy.y));
		}
		/**
		 *检测此主播是否在本房间 
		 * @param MstId 主播id
		 * @return  是否
		 * 
		 */		
		private function checkIsRoom(MstId:String):Boolean{
			var result:Boolean = false;
			var showData:ShowData = Context.variables["showData"];
			var order:Object = showData.order;
			if(order != null){ //三麦
				if(order["1"]){
					if(MstId == order["1"].masterId){
						result = true;
					}
				}
				if(order["2"]){
					if(MstId == order["2"].masterId){
						result = true;
					}
				}
				if(order["3"]){
					if(MstId == order["3"].masterId){
						result = true;
					}
				}
			}
			if(showData.hasOwnProperty("roomOwnMasterID") && showData["roomOwnMasterID"] == MstId){ //单麦
				if(MstId == showData["roomOwnMasterID"]){
					result = true;
				}
			}
			
			return result;
		}
		
	}
}