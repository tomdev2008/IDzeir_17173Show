package com._17173.flash.show.base.module.animation.extAnimation
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.model.MessageVo;
	import com._17173.flash.show.base.module.animation.base.AnimationPlay;
	import com._17173.flash.show.base.utils.Utils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 *香槟鸡尾酒跑道动画类 
	 * @author zhaoqinghao
	 * 
	 */	
	public class CACBarAnimation extends AnimationPlay
	{
		/**
		 *移动的图骗 
		 */		
		public function CACBarAnimation()
		{
			super();
		}
		/**
		 *附加操作 
		 * 
		 */		
		override protected function onLoadedAction():void{
			var tmc:MovieClip = _mc;
			if(tmc.hasOwnProperty("sLabel")){
				var tf1:TextField = tmc.sLabel as TextField;
				tf1.htmlText = getSName();
			}
		}
		
		
		override public function getBmp():Bitmap{
			bmp = new Bitmap();
			var bmd:BitmapData = new BitmapData(_mc.width,_mc.height,true,0x00CCCCCC);
			var rect:Rectangle = (_mc as MovieClip).getRect(_mc);
			var max:Matrix = new Matrix();
			max.translate(-rect.x,-rect.y);
			bmd.draw(_mc,max);
			bmp.bitmapData = bmd;
			return bmp;
		}
		
		private function getSName():String{
			var mv:MessageVo = data as MessageVo;
			var str:String = "<font color='#AE5A00' size='12'><font color='#DB2404' size='14'>[" +  Utils.formatToHtml(mv.sName) + "]</font>" + 
				" 送给 <font color='#DB2404' size='14'>[" + Utils.formatToHtml(mv.tName) + "]</font> " +  mv.giftCount + "个 " + mv.giftName + "</font>";
			return str;
		}
		
		override public function loadCmp(data:IResourceData):void
		{
			if(data != null){
				_loading = false;
				_loadFail = false;
				_loaded = true;
				_mc = data.source;
				_mc.mouseChildren = false;
				_mc.mouseEnabled = false;
				onLoadedAction();
				if(_onLoadCallBack != null){
					_onLoadCallBack()
				}
			}else{
				_loading = false;
				Debugger.log(Debugger.ERROR, "[加载动画错误]", "动画地址",_url);
				_loadFail = true;	
				_loaded = true;
				if(_onLoadCallBack != null){
					_onLoadCallBack()
				}
			}
		}
		
		override public function returnObj():void{
			_mc = null;
			_loaded = false;
			_loadFail = false;
			_url = null;
			_ttFrame = 0;
			_data = null;
			_type = null;
			_onLoadCallBack = null;
			_actionOk = false;
			returned = true;
			data = null;
			returnSelfPool();
			bmp = null;
		}
	}
}