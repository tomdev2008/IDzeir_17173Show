package
{
	public class PreloadConf
	{
		
		private var _url:String = "";
		private var _type:String = "";
		private var _verName:String = "";
		private var _verNum:String = "";
		
		public function PreloadConf()
		{
		}
		
		public function get conf():Object {
			return null;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get verName():String
		{
			return _verName;
		}

		public function set verName(value:String):void
		{
			_verName = value;
		}

		public function get verNum():String
		{
			return _verNum;
		}

		public function set verNum(value:String):void
		{
			_verNum = value;
		}

		
	}
}