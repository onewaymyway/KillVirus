package com.ww.effects
{
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import pubs.GameInfors;

	public class Monster extends Body
	{
		public function Monster()
		{
			super();
			isMonster=true;
			maxLineCount=15;
			this.clearCount=10;
			
//			this.filters = [new GlowFilter(0xFF0000, 1, 10, 10, 2, 1, false, false)];
			hurtCD=100;
		
			state.defaultTextFormat=GameInfors.monsterFormat;
//			state.filters = [new GlowFilter(0xFFFF00, 1, 10, 10, 2, 1, false, false)];
		}
		
		
		public static var MonsterMainBody:int=5;
		override public function create(x:Number, y:Number):void
		{
			// TODO Auto Generated method stub
//			super.create(x, y);
			this.color=0x00ff00+0xFF00FF*Math.random();
			this.MainBodyCount=MonsterMainBody;
			waitPints=PointTools.createPoints(new Point(x,y),40,8,3);
			addNewPoint();
		}
		
		public var waitPints:Array=[];
		
		public var wCount:int=0;
		
		public var cCount:int=0;
		 
		public var hurtCD:int;
		override public function render():void
		{
			// TODO Auto Generated method stub
			super.render();
			
			wCount--;
			if(wCount<0)
			{
				addNewPoint();
				wCount=2;
			}else
			{
				
			}
			
			cCount--;
			
			if(cCount<0)
			{
				cCount=100;
				if(this.oPoint&&waitPints.length<50&&this.weight>1000)
				waitPints=waitPints.concat(PointTools.createPoints(this.oPoint,40,20+MonsterMainBody*5*Math.random(),5));
			}else
			{
				
			}
			
			hurtCD--;
		}
		
		override public function canHurt():Boolean
		{
			// TODO Auto Generated method stub
			return hurtCD<0;
		}
		
		
		public function addNewPoint():void
		{
			if(waitPints.length>=1)
			{
				var tArr:Array;
				tArr=waitPints.shift();
				addPoint(tArr[0],tArr[1],tArr[2],tArr[3],30);
			}
		}
		
		
		
	}
}