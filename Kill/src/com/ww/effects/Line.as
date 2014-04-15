package com.ww.effects
{
	import flash.display.Sprite;
	
	import pubs.GameInfors;

	public class Line extends Sprite
	{
		static public var sets:Array = [];
		
		public var sX:int;
		public var sY:int;
		public var eX:int;
		public var eY:int;
		public var linesize:Number;
		
		public var dir:int=1;
		public var dCount:int=360;
		public var color:uint;
		public var len:int;
		public function Line($sX:int, $sY:int, $eX:int, $eY:int, $linesize:Number = 14)
		{
			sets.push(this);
			sX = $sX;
			sY = $sY;
			eX = $eX;
			eY = $eY;
			linesize = $linesize;
			len=Math.pow((sX-eX)*(sX-eX)+(sY-eY)*(sY-eY),0.5);
			if(len<=5) len=5;
			linesize=linesize*30/len;
			if(linesize>60) linesize=60;
//			trace("");

			draw();
			this.mouseEnabled=false;
			this.mouseChildren=false;
		}
		
		public function get weight():int
		{
			return len*linesize;
		}
		private function draw():void
		{
			graphics.clear();
			graphics.lineStyle(linesize, color);
			graphics.moveTo(sX, sY);
			graphics.lineTo(eX, eY);
		}
		public function update(type:Number=0):void
		{
			draw();
			
			if(type==0)
			{
				dir=1;
				type=-0.1;
			}else
			{
				dCount--;
				if(dCount<0)
				{
					dir*=-1;
					dCount=100*Math.random();
				}
				
			}
			linesize -= (0.1-type)*dir;
			if(linesize<5)
			{
				linesize -= (0.1-type)*dir;
			}
			//		trace("type:"+type);
			if (linesize < 1)
			{
				clear();
			}
		}
		public var isCleared:Boolean=false;
		public function clear():void
		{
			graphics.clear();

			GameInfors.remove(this);
			isCleared=true;
		}
	}
}