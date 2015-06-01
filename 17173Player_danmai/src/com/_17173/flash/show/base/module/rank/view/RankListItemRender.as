package com._17173.flash.show.base.module.rank.view
{
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	/**
	 *排行榜list render 
	 * @author Administrator
	 */	
	public class RankListItemRender extends Sprite
	{
		/**
		 *排行数 
		 */		
		private var rankTF:Label;
		
		/**
		 *名称 
		 */		
		private  var nameTF:Label;
		
		/**
		 *财富 
		 */		
		private var goldTF:Label;
		
		/**
		 *财富图标 
		 */		
		private var goldIcon:Bitmap;
		
		/**
		 *排行数 
		 */		
		private var rankIcon:Bitmap;
		
		private var bg:Bitmap;
		
		private var df:TextFormat;
		
		public function RankListItemRender()
		{
			super();
			
			rankTF = new Label();
			rankTF.x = 10;
			rankTF.y = 7;
			this.addChild(rankTF);
			
			nameTF = new Label({maxW:105});
			nameTF.visible = false;
			nameTF.y = 10;
			this.addChild(nameTF);
			nameTF.x = width - nameTF.width - 7;
			
			goldTF = new Label({maxW:110});
			goldTF.visible = false;
			goldTF.y = 35;
			this.addChild(goldTF);
			
			goldIcon = new Bitmap(new RankGold());
			goldIcon.visible = false;
			goldIcon.y = goldTF.y + 4;
			this.addChild(goldIcon);
		}
		
		private var _data:Object;

		/**
		 *数据源 
		 */
		public function get data():Object
		{
			return _data;
		}

		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			if(_data == value) return;
			_data = value;
			renderByData();
		}
		
		private var _index:int = -1;

		/**
		 *索引 
		 * @return 
		 */		
		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			if(_index == value) return;
			_index = value;
			renderByIndex();
		}
		
		/**
		 *渲染背景 
		 */		
		private function renderByIndex():void
		{
			df = new TextFormat("Microsoft YaHei,微软雅黑,宋体", 14);
			if(index == 0)
			{
				rankTF.visible = false;
				
				if(!bg)
				{
					bg = new Bitmap(new RankItemBG());
					this.addChildAt(bg, 0);
				}
				
				if(!rankIcon)
				{
					rankIcon = new Bitmap(new RankFirst());
					rankIcon.x = 8;
					rankIcon.y = -5;
				}
				
				if(!rankIcon.parent)
				{
					this.addChild(rankIcon);
				}
				df.color = 0xffffff;
			}
			else
			{
				if(bg && bg.parent)
				{
					bg.parent.removeChild(bg);
					bg = null;
				}
				
				if(rankIcon)
				{
					rankIcon.visible = false;
				}
				
				var a:Number = .9 - (index - 1) * .3;
				a = a < .3?.3:a;
				
				this.graphics.clear();
				drawRect(18, 18, 0xc12e74, a, 8, 10);
				
				rankTF.visible = true;
				df.size = 14;
				df.color = index > 2 ? 0x999999 : 0xcccccc;
				rankTF.defaultTextFormat = df;
				rankTF.text = (index + 1) + "";
				
				df.color = 0xcccccc;
			}
			
			df.size = 12;
			df.bold = false;
			nameTF.defaultTextFormat = df;
			goldTF.defaultTextFormat = df;
		}		
		
		/**
		 *画方块 
		 * @param $w
		 * @param $h
		 * @param $color
		 * @param $alpha
		 */		
		private function drawRect($w:int, $h:int, $color:uint, $alpha:Number = 1, $x:int = 0, $y:int = 0):void
		{
			this.graphics.beginFill($color, $alpha);
			this.graphics.drawRect($x, $y, $w, $h);
			this.graphics.endFill();
		}
		
		/**
		 *数据渲染 
		 */		
		private function renderByData():void
		{
			if(!data)
			{
				goldTF.visible = nameTF.visible = goldIcon.visible = false;
				return;
			}
			
			nameTF.text = Utils.formatToString(data.fromNickname);
			(Context.getContext(CEnum.UI) as IUIManager).registerTip(nameTF, nameTF.text);
			nameTF.x = width - nameTF.width - 7;
			
			goldTF.text = data.sum;
			goldTF.x = width - goldTF.width - 7;
			
			goldIcon.x = goldTF.x - goldIcon.width - 5;
			goldTF.visible = nameTF.visible = goldIcon.visible = true;
		}
		
		override public function get width():Number
		{
			return 136;
		}
		
		override public function get height():Number
		{
			return 63;
		}
	}
}