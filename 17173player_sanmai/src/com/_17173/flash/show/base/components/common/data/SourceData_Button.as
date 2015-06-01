package com._17173.flash.show.base.components.common.data
{
	import flash.display.DisplayObject;
	
	public class SourceData_Button extends SourceData
	{
		/**
		 * @param souce 底图资源 如果是按钮则需要 3帧 1：UP状态 ，2：OVER状态,3：DOWN状态 (默认为普通按钮资源)
		 * 
		 */	
		public function SourceData_Button(souce:DisplayObject=null, size:Object=null)
		{
			super(souce, size);
		}
		
		override protected function getNorSource():DisplayObject{
			return new Button_NormalBg();
		}
	}
}