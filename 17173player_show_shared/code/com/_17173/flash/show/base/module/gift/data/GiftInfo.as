package com._17173.flash.show.base.module.gift.data
{
	import com._17173.flash.core.util.debug.Debugger;
	
	import flash.utils.Dictionary;

	/**
	 *礼物信息 
	 * @author zhaoqinghao
	 * 
	 */	
	public class GiftInfo implements IGiftManager
	{
		/**
		 *礼物信息字典 
		 */		
		private var _gifts:Dictionary = null;
		/**
		 *礼物与类型对应字典 
		 */		
		private var _idsOfType:Dictionary = null;
		/**
		 * 类型信息
		 */		
		private var _typeInfos:Array = null;
		/**
		 *数据对象原型 
		 */		
		private var _prototypeObject:Object;
		
		private static var instance:GiftInfo;
		public function GiftInfo(){
			
		}
		
		public static function getInstance():GiftInfo{
			if(instance == null){
				instance = new GiftInfo();
			}
			return instance;
		}
		
		public function setupGiftInfo(data:Object):Boolean
		{
			_prototypeObject = data;
			var result:Boolean = false;
			//解析礼物数据
			if(data){
				//解析类型
				setupTypes(data.types);
				setupGifts(data.gifts);
			}else{
				throw Error("解析数据错误" + data);
			}
			return result;
		}
		
		
		private function setupTypes(data:Object):void{
			if(data is Array){
				_typeInfos = [];
				_idsOfType = new Dictionary();
				var array:Array = data as Array;
				var len:int = array.length;
				var obj:Object;
				var typedata:GiftTypeData;
				for (var i:int = 0; i < len; i++) 
				{
					obj = array[i];
					//解析类型
					typedata = new GiftTypeData(obj);
					//初始化类型对应所有礼物id
					_idsOfType[typedata.id] = [];
					//放入类型信息数组
					_typeInfos[_typeInfos.length] = typedata;
				}
				//排序
				_typeInfos.sortOn("order",Array.NUMERIC);
			}else{
				throw Error("解析数据错误" + data);
			}
		}
		
		private function setupGifts(data:Object):void{
			_gifts = new Dictionary();
			var len:int = _typeInfos.length;
			var gid:String;
			var ids:Array;
			var tmpGifts:Array;
			var giftdata:GiftData;
			for (var i:int = 0; i < len; i++) 
			{
				//该类型的所有礼物ID
				ids = [];
				//取出type ID
				gid = (_typeInfos[i] as GiftTypeData).id;
				//解析该TYEP ID的所有gift
				tmpGifts = data[gid];
				var len1:int = tmpGifts.length;
				for (var j:int = 0; j < len1; j++) 
				{
					giftdata = new GiftData(tmpGifts[j]);
					
					ids.push(giftdata.id);
					//存入礼物数据
					_gifts[giftdata.id] = giftdata;
				}
				//存入类型礼物 结构
				_idsOfType[gid] = ids
			}
		}
		
		
		public function getAllGiftData():Array
		{
			var result:Array = [];
			var len:int = _typeInfos.length;
			for (var i:int = 0; i < len; i++) 
			{
				var typedata:GiftTypeData = _typeInfos[i] as GiftTypeData;
				result = result.concat(getGiftsByType(typedata.id));
			}
			return result;
		}
		
		public function getGiftById(id:String):GiftData
		{
			return _gifts[id];
		}
		
		public function getGiftsByType(type:String):Array
		{
			var result:Array = [];
			var ids:Array = _idsOfType[type];
			if(ids){
				var len:int = ids.length;
				for (var i:int = 0; i < len; i++) 
				{
					result[result.length] = _gifts[ids[i]];
				}
				
			}
			return result;
		}
	}
}