package com._17173.flash.show.base.components.common
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.utils.FontUtil;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 *
	 * @author		idzeir
	 * @email		qiyanlong@wozine.com
	 * @created		Dec 25, 2014||11:50:38 AM
	 */
	public class MasterNoMovie extends BitmapMovieClip
	{
		private var _noTxt:TextField;
		
		private const BASE_URL:String = "assets/img/level/"
		
		public function MasterNoMovie(isFix:Boolean=false, fixToW:Number=24, fixToH:Number=24)
		{
			super(isFix, fixToW, fixToH);
			
			_noTxt = new TextField();
			_noTxt.autoSize = "left";
			_noTxt.defaultTextFormat = new TextFormat(FontUtil.f,12,0xffffff);
			
			this.mouseChildren = false;
		}
		
		public function set no(value:String):void
		{
			var offY:Number = 0;
			var file:String;
			/*if(value == "18181"||value=="81818")
			{
				file = "no_51_20.swf";
				setFWH(true,51,20);
				offY = 2;
			}else{
				file = Context.variables["conf"].masterNoIcon[value.length.toString()];
				var arr:Array = file.split("_");
				setFWH(true,uint(arr[1]),uint(arr[2].split(".swf")[0]));
			}			*/
			//this.url = BASE_URL + file;
			_noTxt.text = value;
			_noTxt.x = _toW - _noTxt.width>>1;
			_noTxt.y = (_toH - _noTxt.height>>1) + offY;
		}
		
		
		override public function set data(value:Array):void
		{
			super.data = value;
			this.addChild(_noTxt);
		}
		
		override protected function align():void
		{
			super.align();
		}
	}
}