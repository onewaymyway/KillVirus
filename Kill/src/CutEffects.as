package  
{

	
	import com.ww.effects.Body;
	import com.ww.effects.Line;
	import com.ww.effects.Monster;
	import com.ww.effects.PointTools;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import pubs.DebugToolScreen;
	import pubs.GameInfors;
	
//	[SWF(width=800,height=600,backgroundColor=0xffffff,frameRate=24)]
	/**
	 * ...
	 * @author ww
	 */
	public class CutEffects extends Sprite 
	{
		private var _cacheX:int;
		private var _cacheY:int;
		private var _isDown:Boolean;
		private var _scene:Sprite;
		private var _textLayer:Sprite;
		
		private var _restCount:int=100;
		
		private var text:TextField;
		public function CutEffects() 
		{
			_scene = new Sprite();
			this.addChild(_scene);
			
			
			_textLayer = new Sprite();
			this.addChild(_textLayer);
			
			_textLayer.mouseChildren=false;
			_textLayer.mouseEnabled=false;
			
			GameInfors.textLayer=_textLayer;
			
			text=GameInfors.getANewTxt();
//			text.y=GameInfors.height-100;
//			_textLayer.addChild(text);
			
			
			_scene.filters = [new GlowFilter(0x00CCFF, 1, 10, 10, 2, 1, false, false)];
			
			Body.monsterKilledFun=this.monsterKilledFun;
			
		}
		
		public function addEvent():void
		{
			GameInfors.getInstance().gameStage.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			GameInfors.getInstance().gameStage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		public function removeEvent():void
		{
			GameInfors.getInstance().gameStage.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			GameInfors.getInstance().gameStage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			this.removeEventListener(Event.ENTER_FRAME, enterFrame);
		}
		private var monsterKilled:int=0;
		private var monster:Monster;
		
		public var maxBodyCount:int=2;
		public var leftBodyCount:int=2;
		public function createGame():void
		{
			createAMonster();
			setTimeout(createAMonster,10*1000);
		}
		public function beginGame():void
		{
			removeEvent();
			addEvent();
		}
		public function stopGame():void
		{
			removeEvent();
		}
		
		public var tMonsterCount:int=0;
		private function createAMonster():void
		{
			monster=Body.createAMonster();
			var mPos:Array;
			mPos=PointTools.getARandomPoint(GameInfors.width*0.5,GameInfors.height*0.5,50);
			
			monster.create(mPos[0],mPos[1]);
			_scene.addChild(monster);
			tMonsterCount++;
			DebugToolScreen.addStr(GameInfors.monsterName+"Created");
			DebugToolScreen.addStr("DoubleClickToCreateNew"+GameInfors.soldierName);
			DebugToolScreen.addStr("Drag"+GameInfors.soldierName+"To"+GameInfors.monsterName+"ToAttack");
		}
		private var tBody:Body;
		
		
		private function monsterKilledFun():void
		{ 
			tMonsterCount--;
			monsterKilled++;
			leftBodyCount++;
			Monster.MonsterMainBody++;
//			Body.enhanceBody(2);
			_restCount+=100;
			DebugToolScreen.addStr(GameInfors.monsterName+"Killed");
			DebugToolScreen.addStr("You get a new "+GameInfors.soldierName);
//			DebugToolScreen.addStr("SolderEnhanced power+"+2); 
			setTimeout(createAMonster,5*1000);
//			createAMonster();
			updateTxt();
			
		}
		
		private var preTime:Number;
		
		private function getTime():Number
		{
			return (new Date()).time;
		}
		
		public var attackCount:int;
		private function downHandler(e:MouseEvent):void
		{
			_cacheX = mouseX;
			_cacheY = mouseY;
			var timeNow:Number;
			timeNow=getTime();
			var isDoubleClick:Boolean;
			isDoubleClick=(timeNow-preTime<200);
			preTime=timeNow;
			
			
			if(e.target is Body)
			{
				tBody=e.target as Body;
				
				if(tBody.isMonster) return;
				
				if(tBody)
				{
					_scene.addChild(tBody);
					attackCount=15;
					_isDown = true;
				}else
				{
					_isDown=false;
				}
			}else
			{
				if(!isDoubleClick) return;
				if(solderCanCreate<1) return;
				
				tBody=Body.getANewBody();
				tBody.create(_cacheX,_cacheY);
//				maxBodyCount--;
				leftBodyCount--;
				_scene.addChild(tBody);
				return;
			}

			
			

		}
		private function upHandler(e:MouseEvent):void
		{
			
			
			if(_isDown&&(attackCount>0))
			{
				var tPos:Array;
				tPos=PointTools.getARandomPoint(_cacheX,_cacheY,10);
				if(tBody.addPoint(_cacheX, _cacheY, tPos[0],tPos[1]))
				{
					_restCount--;
				}
				
			}
			_isDown = false;
		}
		private function enterFrame(e:Event):void
		{
			if(addCount<=0)
			{
				_restCount++;
				addCount=2;
			}else
			{ 
				addCount--;
			}
			
			update();
			Body.updateBodys();
			updateTxt();
		}
		private var addCount:int;
		private function update():void
		{
			

			
			if(_restCount<1) _isDown=false;
			if (!_isDown) return;
			
			attackCount--;
			if(tBody)
			{
				if((attackCount>0)&&GameInfors.getLen(_cacheX, _cacheY, mouseX, mouseY)>15)
				{
//					_restCount--;

					if(tBody.addPoint(_cacheX, _cacheY, mouseX, mouseY))
					{
						
					}else
					{
						_isDown=false;
					};
					
					_cacheX = mouseX;
					_cacheY = mouseY;
				}
			}
//			var line:Line = new Line(_cacheX, _cacheY, mouseX, mouseY);
//			_scene.addChild(line);

		
		}
		
		public var solderCanCreate:int;
		private function updateTxt():void
		{
			var tSoulderCount:int;
			tSoulderCount=Body.bodyList.length-tMonsterCount;
			solderCanCreate=maxBodyCount-tSoulderCount;
			text.text=GameInfors.monsterName+"Killed："+monsterKilled
				+"\n"+GameInfors.soldierName+"Left："+(leftBodyCount)
				+"\n"+GameInfors.soldierName+":"+tSoulderCount+"/"+maxBodyCount
				+"\nCreate"+GameInfors.soldierName+":DoubleTap"
				+"\nAttack:Drag"+GameInfors.soldierName
				+" \nPowerLeft："+_restCount;
		}
	}
	
}
