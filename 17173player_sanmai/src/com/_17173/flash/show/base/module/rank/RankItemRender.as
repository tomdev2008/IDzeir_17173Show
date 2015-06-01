package com._17173.flash.show.base.module.rank
{
	import com._17173.flash.show.base.components.common.AslTextField;
	import com._17173.flash.show.base.utils.FontUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	public class RankItemRender extends Sprite
	{
		private var _index:int = 0;
		
		private var _nickName:AslTextField = null;
		
		private var _goldIngot:GoldIngot = null;
		
		private var _money:AslTextField = null;
		
		private var _mouseBg:Sprite = null;
		
		private var _hideSprite:Sprite = new Sprite();
//		
		public function RankItemRender(index:int)
		{
			this._index = index;
			super();
			createMouseBg();
			this.addChild(_hideSprite);
			_hideSprite.visible = false;
			createMedal();
			createNickName();
			createGoldIngot();
			createMoney();
			createLine();
			this.addEventListener(MouseEvent.MOUSE_OVER,over);
			this.addEventListener(MouseEvent.MOUSE_OUT,out);
		}
		
		public function update(obj:Object):void{
			_nickName.text = obj.fromNickname;
			_money.text = obj.money;
			if(obj.fromNickname == ""){
				_hideSprite.visible = false;
			}else{
				_hideSprite.visible = true;
			}
		}
		
		private function createMouseBg():void{
			_mouseBg = new Sprite();
			_mouseBg.graphics.beginFill(0x22033C,0);
			_mouseBg.graphics.drawRect(0,0,238,34);
			_mouseBg.graphics.endFill();
			_mouseBg.x = 3;
			_mouseBg.y = -2;
			this.addChild(_mouseBg);
		}
		
		private function over(e:MouseEvent):void{
			_mouseBg.graphics.clear();
			_mouseBg.graphics.beginFill(0x22033C,1);
			_mouseBg.graphics.drawRect(0,0,238,34);
			_mouseBg.graphics.endFill();
		}
		
		private function out(e:MouseEvent):void{
			_mouseBg.graphics.clear();
			_mouseBg.graphics.beginFill(0x22033C,0);
			_mouseBg.graphics.drawRect(0,0,238,34);
			_mouseBg.graphics.endFill();
		}
		
		private function createLine():void{
			var line:RankLine = new RankLine();
			this.addChild(line);
			line.x = 20;
			line.y = 30;
		}
		
		private function createNickName():void{
			var textFormat:TextFormat = FontUtil.DEFAULT_FORMAT;
			textFormat.color = 0x63ACFF;
			textFormat.size = 12;
			_nickName = new AslTextField(110);
			_nickName.defaultTextFormat = textFormat;
			_nickName.x = 36;
			_nickName.y = 5;
			_nickName.selectable = false;
			_nickName.text = "--";
			_hideSprite.addChild(_nickName);
		}
		
		private function createMoney():void{
			var textFormat:TextFormat = FontUtil.DEFAULT_FORMAT;
			textFormat.color = 0x63ACFF;
			textFormat.size = 12;
			_money = new AslTextField(140);
			_money.defaultTextFormat = textFormat;
			_money.x = 173;
			_money.y = 6;
			_money.selectable = false;
			_money.text = "--";
			_hideSprite.addChild(_money);
		}
		
		private function createGoldIngot():void{
			_goldIngot = new GoldIngot();
			_goldIngot.x = 152;
			_goldIngot.y = 5;
			_hideSprite.addChild(_goldIngot);
		}
		
		private function createMedal():void{
			var movieClip:MovieClip = null;
			switch(_index){
				case 0:
					movieClip = new GoldMedal();
					movieClip.x = 15;
					movieClip.y = 2;
					break;
				case 1:
					movieClip = new SilverMedal();
					movieClip.x = 15;
					movieClip.y = 2;
					break;
				case 2:
					movieClip = new CopperMedal();
					movieClip.x = 15;
					movieClip.y = 2;
					break;
				case 3:
					movieClip = new TheForth();
					movieClip.x = 16;
					movieClip.y = 4;
					break;
				case 4:
					movieClip = new TheFifth();
					movieClip.x = 16;
					movieClip.y = 4;
					break;
			}
			this.addChild(movieClip);
		}
		
	}
}