package com._17173.flash.show.base.components.common.data
{
	import flash.display.DisplayObject;
	
	public class SourceData_Panel extends SourceData
	{
		public function SourceData_Panel(souce:DisplayObject=null, size:Object=null)
		{
			super(souce, size);
		}
		
		
		override protected function getNorSource():DisplayObject{
			return new Bg_Normal();
		}
	}
}