package com._17173.flash.core.components.skin
{
	import com._17173.flash.core.components.interfaces.ISkinClass;
	
	import flash.display.DisplayObject;
	import flash.sensors.Accelerometer;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class SkinManager
	{
		
		private static var _skinManager:SkinManager;
		/**
		 *皮肤存放数组 
		 */		
		private var _skins:Dictionary;
		private var _skinGroup:Dictionary;
		private var _skinDefName:String;
		private var _skinNames:Array;
		public function SkinManager()
		{
			_skins = new Dictionary();
			_skinGroup = SkinConfig.getInstance().getSkins();
			_skinDefName = SkinConfig.getInstance().DEFNAME;
			_skinNames = [];
			initDefSkin();
		}
		
		public static function getInstance():SkinManager{
			return _skinManager ||=  new SkinManager();
		}
		/**
		 *添加到皮肤管理 
		 * @param sKey
		 * @param skinDObj
		 * 
		 */		
		public function addManager(sKey:String,skinDObj:ISkinClass):void{
			
		}
		
		/**
		 *从皮肤管理一处 
		 * @param sKey
		 * @param skinDObj
		 * 
		 */		
		public function removeManger(sKey:String,skinDObj:ISkinClass):void{
			
		}
		
		/**
		 *更换皮肤组 
		 * 
		 */		
		public function changeSkinGroupByName(SkinsName:String):void{
			_skinDefName = SkinsName;
			changeAllSkinByName();
		}
		
		/**
		 *初始化所有皮肤组 
		 * @param SkinName
		 * @param SkinsConfi
		 * 
		 */		
		public function addSkinGroup(skinName:String,SkinsConfi:Object):void{
			_skinNames[skinName];
			_skinGroup[skinName] = SkinsConfi;
		}
		/**
		 *更换皮肤组 
		 * 
		 */		
		public function changeAllSkinByName():void{
			
		}
		/**
		 *初始化默认皮肤 
		 * 
		 */		
		private function initDefSkin():void{
			
		}
		/**
		 *获取所有皮肤组名称 
		 * @return 
		 * 
		 */		
		public function getSkinNames():Array{
			return _skinNames;
		}
		
		/**
		 *获取默认皮肤 
		 * @param Type
		 * @return 
		 * 
		 */		
		public function getSkinByDef(type:String):Object{
			var obj:Object;
			if(_skinGroup[_skinDefName]){
				var tmp:Object = _skinGroup[_skinDefName]
				if(tmp.hasOwnProperty(type)){
					obj =  clone(tmp[type]);
				}
			}
			return obj;
		}
		
		
		private function clone(data:Object):Object{
			var nData:Object = {};
			for(var key:String in data) 
			{
				nData[key] = getDobj(data[key]);
			}
			return nData;
		}
		
		/**
		 *获取资源对象 
		 * @param source 资源类（可以是class或显示对象）
		 * @param isCreate 如果是不是class 是否创建（默认创建新的显示对象）
		 * @return 
		 * 
		 */		
		public function getDobj(source:Object,isCreate:Boolean = true):DisplayObject{
			var result:DisplayObject;
			if(source is Class){
				result = new source();
			}
			if(source is DisplayObject){
				if(isCreate){ 
					var className:String = getQualifiedClassName(source);
					var cla:Class = getDefinitionByName(className) as Class;
					result = new cla();
				}else{
					result = source as DisplayObject;
				}
			}
			return result;
		}
	}
}