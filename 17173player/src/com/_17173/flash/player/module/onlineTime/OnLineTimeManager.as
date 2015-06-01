package com._17173.flash.player.module.onlineTime
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;

	/**
	 *在线时长管理类
	 * @author zhaoqinghao
	 *
	 */
	public class OnLineTimeManager
	{
		/**
		 *断开时间
		 */
		private var overTime:int = 8 * 1000;
		/**
		 *领取奖励计时
		 */
		public static const CD_COUNT:int = 60*5;
		/**
		 *领取限制 
		 */		
		public static const REWARD_LIMIT:int = 6;
		/**
		 *房间id
		 */
		private var _rId:String = null;
		/**
		 *共享数据
		 */
		private var timeData:Object = null;
		/**
		 *本房间缓存数据{lt:本地时间,ct:剩余时间}
		 */
		private var currentData:Object = null;
		private const SB_KEY:String = "onLineTimeData";

		public function OnLineTimeManager(roomId:String)
		{
			currentData = {};
			_rId = roomId;
			//上来就从sb中获取数据
			var setting:Object = Context.getContext(ContextEnum.SETTING);
			timeData = setting.getCookie(SB_KEY);
			//清理数据
			checkAllSO();
			//获取自己数据;
			if (timeData && timeData.hasOwnProperty(roomId))
			{
				currentData = timeData[_rId];
			}else{
				Debugger.log(Debugger.INFO,"[OnLineTime]没有检测到共享对象："+roomId);
			}
		}

		public function update(time:int):void
		{
			var setting:Object = Context.getContext(ContextEnum.SETTING);
			timeData = setting.getCookie(SB_KEY);

			if (timeData == null)
			{
				timeData = {};
				timeData[_rId] = currentData;
			}
			checkAllSO();
			writeSO(time);
		}

		/**
		 *获取当前剩余时间
		 *
		 */
		public function getTimeCount():int
		{
			if (currentData && currentData.hasOwnProperty("ct"))
			{
				return currentData.ct;
			}
			else
			{
				return CD_COUNT;
			}
		}

		/**
		 *删除自己时间数据
		 *
		 */
		public function delectSelfdata():void
		{
			if (timeData.hasOwnProperty(_rId))
			{

			}
		}

		/**
		 *检查计时是否中断
		 *
		 */
		private function checkAllSO():void
		{
			for (var i:String in timeData)
			{
				if (checkTimeOver(timeData[i]))
				{
					Debugger.log(Debugger.INFO,"[OnLineTime]删除时间当前时间:",new Date().time,"记录时间：",timeData[i].lt);
					delete timeData[i];
				}
			}
		}

		/**
		 *检测超时
		 * @param data 房間時間信息
		 * @return 是否超時
		 *
		 */
		private function checkTimeOver(data:Object):Boolean
		{
			if (!data)
				return true;
			var result:Boolean = false;
			//当前时间
			var lTime:Number = (new Date().time);
			//共享对象记录的时间
			var solTime:Number = (data.lt);
			//如果当前时间小于记录时间则说明记录时间有误，删除
			if (lTime < solTime)
			{
				result = true;
			}
			else
			{
				//超时
				if ((lTime - solTime) >= overTime)
				{
					result = true;
				}
			}
			return result;
		}

		/**
		 *写入本地数据
		 * @param rId
		 * @param time
		 *
		 */
		private function writeSO(time:int):void
		{
			currentData = {lt: new Date().time, ct: time};
			//如果不存在 则新建写入
			timeData[_rId] = currentData;
			var setting:Object = Context.getContext(ContextEnum.SETTING);
			setting.saveCookie(SB_KEY, timeData);
		}

	}
}