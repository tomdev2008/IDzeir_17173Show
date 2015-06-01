package com._17173.flash.show.base.components.common
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class RadioGroup
	{
		private var _groupArray:Array = null;
		
		private var _currentRadio:MovieClip;
		public function RadioGroup()
		{
			
		}
		
		private function addRadio(obj:Object):void
		{
			if(obj.hasOwnProperty("movieClip"))
			{
				obj["movieClip"].addEventListener(MouseEvent.CLICK,click);
				obj["movieClip"].stop();
				if(!_groupArray)
				{
					_groupArray = new Array();
				}
				_groupArray.push(obj);
			}
		}
		
		public function clear():void
		{
			for each(var obj:Object in _groupArray)
			{
				obj["movieClip"].removeEventListener(MouseEvent.CLICK,click);
			}
			_groupArray = null;
		}
		
		public function pushRadio(moveiClip:MovieClip,selectFun:Function = null,cancelFun:Function = null):void
		{
			var obj:Object = new Object();
			obj["movieClip"] = moveiClip;
			if(selectFun != null)
			{
				obj["selectFun"] = selectFun;
			}
			
			if(cancelFun != null)
			{
				obj["cancelFun"] = cancelFun;
			}
			addRadio(obj);
		}
			
		
		public function getCurrentRadio():MovieClip
		{
			return _currentRadio;
		}
		
		public function set radio(move:MovieClip):void{
			this._currentRadio = move;
		}
		
		public function updateRaido(move:MovieClip):void
		{
			this._currentRadio = move;
		}
		
		private function click(e:MouseEvent):void
		{
			if(this._currentRadio == e.target)
			{
				return;
			}
			
			if(!(e.target is MovieClip))
			{
				return;
			}
			
			for each(var obj:Object in _groupArray){
				if(e.target == obj["movieClip"]){
					if(obj["movieClip"].totalFrames > 2){
						obj["movieClip"].gotoAndStop(2);
						if(obj.hasOwnProperty("selectFun")){
							obj["selectFun"]();
						}
						this._currentRadio = obj["movieClip"];
					
					}
				}else{
					obj["movieClip"].gotoAndStop(1);
					if(obj.hasOwnProperty("cancelFun")){
						obj["cancelFun"]();
					}
				}
			}
		}
	}
}