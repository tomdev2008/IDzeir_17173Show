package com._17173.flash.show.base.module.animation.cac
{
	import com._17173.flash.show.base.module.animation.base.AnimationObject;
	import com._17173.flash.show.base.module.animation.base.BaseAmtControl;
	import com._17173.flash.show.base.module.animation.base.IAnimactionLayer;
	
	import flash.events.Event;
	
	public class CACAmtControl extends BaseAmtControl
	{
		public function CACAmtControl(type:String, parentLayer:IAnimactionLayer)
		{
			super(type, parentLayer);
		}
		
		/**
		 *添加数据 
		 * @param data
		 * 
		 */		
		override public function addData(data:AnimationObject):void{
			data.loadAnimation();
			_datas.push(data);
		}
		
		override public function run(e:Event=null):void{
			var len:int = _datas.length;
			var data:AnimationObject;
			for (var i:int = 0; i < len; i++) 
			{
				data = _datas[i] as AnimationObject;
				if(data && data.loaded && data.returned == false){
					data.run();
					if(data.returned){
						_datas.splice(i,1);
						i--;
					}
				}
			}
		}
		
	}
}