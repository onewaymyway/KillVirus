package com.ww.effects
{
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import pubs.GameInfors;

	public class Body extends Sprite
	{
		public function Body()
		{
			lines=[];
			state=GameInfors.getANewTxt();
			shapeLayer=new Sprite();
			shapeLayer.mouseChildren=false;
			shapeLayer.mouseEnabled=false;
			this.addChild(shapeLayer);
			
//			this.filters = [new GlowFilter(0x00CCFF, 1, 10, 10, 2, 1, false, false)];
		}
		
		public var lines:Array;
		
		public var color:uint;
		
		public var weight:int;
		
		private var shapeLayer:Sprite;
		
		public var isMonster:Boolean=false;
		
		public var clearCount:int=30;
		
		public var state:TextField;
		
		private var tRenderCount:int=0;
		
		private function doReleave():void
		{
			var l:int;
			var r:int;
			l=0;
			r=lines.length-1;
			
//			trace("doRelease: l:"+l+" r:"+r+" lineCount:"+lines.length);
			
			var i:int;
			var lLine:Line;
			var rLine:Line;
			
			if(lines.length>maxLineCount*0.4)
			{
				clearCount=lines.length-MainBodyCount*3;
				if(clearCount<10) clearCount=10;
			}else
			{
				clearCount=10;
			}
			if(isMonster)
			{
				clearCount=10;
			}
			if(lines.length<MainBodyCount)
			{
				clearCount=1; 
			}
			for(i=0;i<clearCount;i++)
			{
				 if(l>r) break;
			     lLine=lines[l];
				 rLine=lines[r];
				 if(lLine.linesize>rLine.linesize)
				 {
					rLine.update(0);
					weight+=rLine.weight;
					r--;
//					trace("release r");
				 }else
				 {
					 lLine.update(0);
					 weight+=lLine.weight;
//					 trace("release l");
					 l++;
				 }
			}
			simpleUpdate(l,r);
//			removeCleared();
		}
		private function simpleUpdate(l:int,r:int):void
		{
			l=l>0?l:0;
			r=r<lines.length-1? r:lines.length-1;
			
//			trace("simpleUpdate: l:"+l+" r:"+r);
			var i:int;
			var tLine:Line;
			var type:Number;
			for(i=l;i<=r;i++)
			{
				tLine=lines[i];
				
				if(tLine&&(!tLine.isCleared))
				{
					type=+0.2+0.01*Math.random();
					tLine.color=this.color;
					tLine.update(type);
					weight+=tLine.weight;
				}else
				{
					
				}
			}
		}
		private function removeCleared():void
		{
			var i:int;
			var len:int;
			var tLine:Line;
		    len=lines.length;
			for(i=len-1;i>=0;i--)
			{
				tLine=lines[i];
				if(tLine&&tLine.isCleared)
				{
					lines.splice(i,1);
				}
			}
		}
		public function render():void
		{
			

			weight=0;
			

			doReleave();
		
			tRenderCount++;
			
			updateInfo();
			if(tRenderCount%3)
			{
				removeCleared();
			}
			if(tRenderCount%6)
			{
//				updateInfoPos();
				upddateInfoPosNew();
			}
		}
		
		
		private function updateInfo():void
		{
			
			if(isMonster)
			{
				state.text=GameInfors.monsterName+"\nWeight:"+weight+" \nPower:"+(maxLineCount-lines.length)+"/"+maxLineCount;
			}else
			{
				state.text=GameInfors.soldierName+"\nWeight:"+weight+" \nPower:"+(maxLineCount-lines.length)+"/"+maxLineCount;
			}
			
			
		}
		
		public var maxLineCount:int=40;
		
		public var MainBodyCount:int=5;
		
		public var oPoint:Point;
		public function addPoint(sx:Number,sy:Number,ex:Number,ey:Number,linesize:Number=14):Boolean
		{
			if(lines.length>maxLineCount) return false;
			if(!GameInfors.isPointIn(sx,sy)) return false;
			if(!GameInfors.isPointIn(ex,ey)) return false;
			
			var line:Line;

			var lineSize:Number;
			lineSize=linesize;  
			if(lines.length==1)
			{
//				this.addChild(state);
				oPoint=new Point(sx,sy);
			}
			
			if(lines.length<MainBodyCount)
			{
				lineSize=50;
//				updateInfoPos();
			}
			
			line=new Line(sx,sy,ex,ey,lineSize);
			line.color=this.color;
			lines.push(line);
			shapeLayer.addChild(line);
			return true;
		}
		
		public function addPointByArr(arr:Array):void
		{
			var i:int;
			var len:int;
			var tArr:Array;
			len=arr.length;
			for(i=0;i<len;i++)
			{
				
				tArr=arr.shift();
				addPoint(tArr[0],tArr[1],tArr[2],tArr[3]);
			}
		}
		public function canHurt():Boolean
		{
			return true;
		}
		public function create(x:Number,y:Number):void
		{
			
			addPointByArr(PointTools.createPoints(new Point(x,y),40,5,2));
		}
		private function upddateInfoPosNew():void
		{
			if(lines.length<1) return;
			var tx:Number;
			var ty:Number;
			var i:int;
			var len:int;
			var tLine:Line;
			var tSLine:Line;
			tSLine=lines[0];
			len=lines.length;
			for(i=1;i<len;i++)
			{
				tLine=lines[i];
				if(tLine.linesize>tSLine.linesize)
				{
					tSLine=tLine;
				}
			}
			tx=(tSLine.sX+tSLine.eX)*0.5;
			ty=(tSLine.sY+tSLine.eY)*0.5;
			if(oPoint)
			{
				oPoint.x=tx;
				oPoint.y=ty;
			}

//			trace("maxLineSize:"+tSLine.linesize);
			GameInfors.updatePos(state,tx,ty);
//			state.x=tx;
//			state.y=ty;
		}
		private function updateInfoPos():void
		{
			
			if(lines.length<1) return;
			var tx:Number;
			var ty:Number;
			
			var ex:Number;
			var ey:Number;
			
			var i:int;
			var len:int;
			
			tx=999999;
			ex=-999999;
			ty=999999;
			ey=-99999;
			var tLine:Line;
			len=lines.length;
			if(len>MainBodyCount+1) len=6+1;
			for(i=0;i<len;i++)
			{
				tLine=lines[i];
				tx=getMin(tLine.eX,getMin(tx,tLine.sX));
				ty=getMin(tLine.eY,getMin(ty,tLine.sY));
				
				ex=getMax(tLine.eX,getMax(ex,tLine.sX));
				
				ey=getMax(tLine.eY,getMax(ey,tLine.sY));
			}
			tx=(tx+ex)*0.5;
			ty=(ty+ey)*0.5;
//			state.x=tx-state.width*0.5;
//			state.y=ty-0.5*state.height;
			GameInfors.updatePos(state,tx,ty);
		}
		
		private function getMin(a:Number,b:Number):Number
		{
			if(a<b) return a;
			return b;
		}
		private function getMax(a:Number,b:Number):Number
		{
			if(a>b) return a;
			return b;
		}
		public function hurtOther(oBody:Body):void
		{
			var i:int;
			var len:int;
			var tLine:Line;
			var oLines:Array;
			oLines=oBody.lines;
			len=oLines.length;
			for(i=0;i<len;i++)
			{
				tLine=oLines[i];
//				if(tLine&&(this.hitTestPoint(tLine.sX,tLine.sY,true)||this.hitTestPoint(tLine.eX,tLine.eY,true)))
				if(tLine&&(tLine.linesize)>5&&HitTest.complexHitTestObject(this,tLine))
				{
					tLine.linesize-=1;
					tLine.dir=-1;
					if(tLine.linesize>10)
					backHurt(tLine);
				}
			}
		}
		
		public function backHurt(oLine:Line):void
		{
			
			var i:int;
			var len:int;
			var tLine:Line;
			len=lines.length;
			for(i=0;i<len;i++)
			{
				tLine=lines[i];
				//				if(tLine&&(this.hitTestPoint(tLine.sX,tLine.sY,true)||this.hitTestPoint(tLine.eX,tLine.eY,true)))
				if(tLine&&HitTest.complexHitTestObject(tLine,oLine))
				{
					tLine.linesize-=0.5;
				}
			}
		}
		public function clear():void
		{
			var i:int;
			var len:int;
			var tLine:Line;
			len=lines.length;
			for(i=0;i<len;i++)
			{
				tLine=lines[i];
				if(tLine)
				{
				   tLine.clear();
				}
			}
			lines=[];
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			GameInfors.remove(state);
			
		}
		
		
		public static function enhanceBody(value:int):void
		{
			var i:int;
			var len:int;
			var tBody:Body;
			len=bodyList.length;
			for(i=len-1;i>=0;i--)
			{
				tBody=bodyList[i];
				if(tBody)
				{

					if(!tBody.isMonster)
					{
						var tValue;
						tValue=tBody.maxLineCount+value;
						if(tValue>180) tValue=180;
						tBody.maxLineCount=tValue;
					}
				}
			}
		}
		
		public static var bodyList:Array=[];
		
		public static var tTime:int=0;
		public static function updateBodys():void
		{
			var i:int;
			var len:int;
			var tBody:Body;
			len=bodyList.length;
			for(i=len-1;i>=0;i--)
			{
				tBody=bodyList[i];
				if(tBody&&tBody.lines.length<1)
				{
					bodyList.splice(i,1);
					tBody.clear();
					if(tBody.isMonster)
					{
						monsterKilled();
					}
				}else
				{
					tBody.render();
				}
			}
			tTime++;
			if(tTime%5)
			detectHit();
		}
		public static var monsterKilledFun:Function;
		private static function monsterKilled():void
		{
			if(monsterKilledFun)
			{
				monsterKilledFun();
			}
		}
		public static function detectHit():void
		{
			var i:int;
			var len:int;
			var j:int;
			var aBody:Body;
			var bBody:Body;
			len=bodyList.length;
			for(i=0;i<len;i++)
			{
				aBody=bodyList[i];
				if(aBody&&aBody.canHurt())
				for(j=i+1;j<len;j++)
				{
					bBody=bodyList[j];
					if(bBody&&bBody.canHurt()&&aBody!=bBody)
					{
//						if(aBody.hitTestObject(bBody))
						if(HitTest.complexHitTestObject(aBody,bBody))
						{
//							trace("hited");
							if(aBody.weight>bBody.weight)
							{
//								bBody.color=aBody.color;
								aBody.hurtOther(bBody);
							}else
							{
//								aBody.color=bBody.color;
								bBody.hurtOther(aBody);
							}
						}
					}
				}
			}
		}
		public static function getANewBody():Body
		{
			var rst:Body;
			rst=new Body();
			bodyList.push(rst);
			rst.color=0xFF0000+0x00FF00*Math.random();
			return rst;
		}
		
		public static function createAMonster():Monster
		{
			var rst:Monster;
			rst=new Monster();
			bodyList.push(rst);
			
			return rst;
		}
	}
}