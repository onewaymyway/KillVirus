package com.ww.effects
{
	import flash.geom.Point;

	public class PointTools
	{
		public function PointTools()
		{
		}
		
		public static function createPoints(oPoint:Point,lLine:Number,len:int=5,d:Number=2):Array
		{
			var rst:Array;
			rst=[];
			var tLine:Array;
			var tLineLen:Number;
			tLineLen=lLine;
		    var i:int;
			var sX:Number;
			var sY:Number;
			
			var theta:Number;
			theta=Math.PI*10*Math.random();
			var dTheta:Number;
			dTheta=Math.PI*0.1*Math.random();
			sX=oPoint.x;
			sY=oPoint.y;
			
			for(i=0;i<len;i++)
			{
				if(lLine<5) return rst;
				tLine=getNewPoint(sX,sY,lLine,theta);
				sX=tLine[2];
				sY=tLine[3];
				rst.push(tLine);
				
				theta+=dTheta;
				lLine-=d;
			}
			
			return rst;
		}
		
		public static function getNewPoint(oX:Number,oY:Number,len:Number,theta:Number):Array
		{
			var rst:Array;
			rst=[oX,oY,oX+len*Math.cos(theta),oY+len*Math.sin(theta)];
			return rst;
		}
		
		
		public static function getARandomPoint(cX:Number,cY:Number,r:Number):Array
		{
			var theta:Number;
			theta=Math.PI*10*Math.random();
		
			var rst:Array;
			rst=[cX+r*Math.cos(theta),cY+r*Math.sin(theta)];
			return rst;
		}
	}
}