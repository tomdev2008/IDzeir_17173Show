package model 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class ButtonModel extends MovieClip {
		
		public function ButtonModel() {
			this.gotoAndStop(1);
			
			this.mouseChildren = false;
			this.buttonMode = this.useHandCursor = true;
			
			this.addEventListener(MouseEvent.ROLL_OVER, mouseHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseHandler);
			this.addEventListener(MouseEvent.CLICK, mouseHandler);
		}
		
		private function mouseHandler(e:MouseEvent):void {
			switch(e.type) {
				case MouseEvent.ROLL_OVER:
					this.gotoAndStop(_status?4:2);
					break;
				case MouseEvent.ROLL_OUT:
					this.gotoAndStop(_status?3:1);
					break;
				case MouseEvent.CLICK:
					_status = !_status;
					break;
			}
		}
		public function reset():void {
			_status = false;
			this.gotoAndStop(1);			
		}
		
		public function toggle(k:Number=0):void {
			if (k==1) {
				_status = true;
				this.gotoAndStop(3);
			}else {
				_status = false;
				this.gotoAndStop(1);
			}			
		}
		
		private var _status:Boolean = false;
	}
	
}