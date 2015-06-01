package com._17173.flash.core.components.skin
{
	import flash.utils.Dictionary;

	public class SkinConfig
	{

		private var _confs:Dictionary = null;
		private var _names:Array;
		public const DEFNAME:String = "def";

		public function SkinConfig()
		{
			_confs = new Dictionary();
			_names = [DEFNAME];
			initConfig();
		}

		private static var _conf:SkinConfig;

		public static function getInstance():SkinConfig
		{
			return _conf ||= new SkinConfig();
		}


		public function getSkinByType(type:String):Object
		{
			return clone(_confs[_names[0]][type]);
		}


		public function getSkins():Dictionary
		{
			return _confs;
		}
		
		
		private function clone(data:Object):Object{
			var nData:Object = {};
			for(var key:String in data) 
			{
				nData[key] = data[key];
			}
			return nData;
		}

		private function initConfig():void
		{
			var obj:Object = {};
			obj[SkinType.SKIN_TYPE_BUTTON] = {"button":Button_NormalBg};
			obj[SkinType.SKIN_TYPE_BASE] = {"bg": Bg_Normal};
			obj[SkinType.SKIN_TYPE_PANEL] = {"line": Line_Normal, "close": Button_NormalClose,"bg":Bg_Normal};
			obj[SkinType.SKIN_TYPE_CHECKBOX] = {"button": CheckBox_Normal};
			_confs[_names[0]] = obj;
		}
	}
}
