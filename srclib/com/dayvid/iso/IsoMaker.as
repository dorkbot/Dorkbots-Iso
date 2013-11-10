package com.dayvid.iso
{
	import com.csharks.juwalbose.IsoHelper;
	import com.dayvid.util.RemoveDisplayObjects;
	import com.newarteest.path_finder.PathFinder;
	import com.senocular.utils.KeyObject;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import dorkbots.dorkbots_broadcasters.BroadcastingObject;

	public class IsoMaker extends BroadcastingObject implements IIsoMaker
	{		
		private var heroCartPos:Point = new Point();
		private var heroNode:Point = new Point();
		
		//the canvas
		private var _canvas:Bitmap;
		private var rect:Rectangle;
		
		private var cornerPoint:Point = new Point();
		
		private var borderOffsetX:Number;
		private var borderOffsetY:Number;
		 
		//Senocular KeyObject Class
		private var key:KeyObject;
		
		//to handle direction movement
		private var dX:Number = 0;
		private var dY:Number = 0;
		private var idle:Boolean = true;
		private var heroFacing:String;
		private var currentHeroFacing:String;
		
		// click-pathfinding control
		private var path:Array = new Array();
		private var destination:Point = new Point();
		private var stepsTillTurn:uint = 5;
		private var stepsTaken:uint;
		
		private var roomsManager:IIsoRoomsManager;
		private var roomData:IIsoRoomData;
		
		private var container_mc:DisplayObjectContainer;
		
		private var triggerReset:Boolean = true;
		
		public function IsoMaker(aContainer_mc:DisplayObjectContainer, aRoomsManager:IIsoRoomsManager)
		{
			/*
			TO DO
			
			Create a map class that can be toggled on and off - clean up
			it only needs heroCartPos
			as its own createLevel, us only walkable level data	
			
			
			Block trigers by putting the room numbers into an array.
			this class double checks this array before swapping rooms.
			
			
			add pathfinding controll
			
			*/
			container_mc = aContainer_mc;
			roomsManager = aRoomsManager;
			
			if (container_mc.stage)
			{
				containerAddedToStage();
			}
			else
			{
				container_mc.addEventListener(Event.ADDED_TO_STAGE, containerAddedToStage);
			}
		}
		
		override public function dispose():void
		{
			_canvas = null;
			key.deconstruct();
			path.length = 0;
			roomsManager.dispose();
			roomData = null;
			container_mc.removeEventListener(MouseEvent.CLICK, handleMouseClick);
			container_mc = null;
			
			super.dispose();
		}
		
		private function containerAddedToStage(event:Event = null):void
		{
			container_mc.removeEventListener(Event.ADDED_TO_STAGE, containerAddedToStage);
			key = new KeyObject(container_mc.stage);
			container_mc.addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		public final function get canvas():Bitmap
		{
			return _canvas;
		}

		public final function createLevel():void
		{
			path.length = 0;
			
			cornerPoint.x = cornerPoint.y = 0;
				
			roomData = roomsManager.getRoom(roomsManager.roomCurrentNum);
			roomData.init();
			
			borderOffsetX = roomData.borderOffsetX;
			borderOffsetY = roomData.borderOffsetY;
			
			_canvas = new Bitmap( new BitmapData( roomData.viewWidth, roomData.viewHeight ) );
			rect = _canvas.bitmapData.rect;
			RemoveDisplayObjects.removeDisplayObjects(container_mc);
			container_mc.addChild(_canvas);
			
			currentHeroFacing = "";
			
			if (!roomsManager.roomHasChanged)
			{
				heroFacing = currentHeroFacing = roomData.heroFacing;
			}
			
			roomData.hero.clip.gotoAndStop(heroFacing);
			
			// Look for hero
			var buildHero:Boolean = false;
			var tileType:uint;
			for (var i:uint = 0; i < roomData.roomEntities.length; i++)
			{
				for (var j:uint = 0; j < roomData.roomEntities[0].length; j++)
				{					
					if (!roomsManager.roomHasChanged)
					{
						// first room
						tileType = roomData.roomEntities[i][j];
						if (tileType == 1)
						{
							buildHero = true;
						}
					}
					else
					{
						// rooms have swapped, place hero on trigger
						tileType = roomData.roomTriggers[i][j];
						if (tileType == roomsManager.roomLastNum + 1)
						{
							buildHero = true;
						}	
					}
					
					if (buildHero)
					{
						// found hero
						// makes sure hero is positioned in the center of the screen
						var adjustedX:Number = (j * roomData.nodeWidth) - ((j * roomData.nodeWidth) - (roomData.viewWidth * .5)) - roomData.hero.width;
						var adjustedY:Number = (i * roomData.nodeWidth) - ((i * roomData.nodeWidth) - (roomData.viewHeight * .5));
						
						var pos:Point = new Point();
						pos.x = adjustedX;
						pos.y = adjustedY;	
						
						pos = IsoHelper.twoDToIso(pos);
						roomData.hero.x = roomData.borderOffsetX + pos.x;
						roomData.hero.y = roomData.borderOffsetY + pos.y;
						
						heroCartPos.x = j * roomData.nodeWidth;
						heroCartPos.y = i * roomData.nodeWidth;
						
						heroNode.x = j;
						heroNode.y = i;		
						
						// repositions the camera so the hero is in the center of the screen
						cornerPoint.x -= ((j * roomData.nodeWidth) - (roomData.viewWidth * .5)) + roomData.hero.width;
						cornerPoint.y -= ((i * roomData.nodeWidth) - (roomData.viewHeight * .5));	
						
						buildHero = false;
						
						//heroMoved();
					}
					
				}
			}
			
			depthSort();
		}
		
		//sort depth & draw to canvas
		private function depthSort():void
		{
			_canvas.bitmapData.lock();
			_canvas.bitmapData.fillRect(rect, 0xffffff);
			
			var tileType:uint;
			var mat:Matrix = new Matrix();
			var pos:Point = new Point();
			
			for (var i:uint = 0; i < roomData.roomNodeHeight; i++)
			{
				for (var j:uint = 0; j < roomData.roomNodeWidth; j++)
				{
					tileType = roomData.roomTerrain[i][j];
					
					pos.x = j * roomData.nodeWidth + cornerPoint.x;
					pos.y = i * roomData.nodeWidth + cornerPoint.y;
					
					pos = IsoHelper.twoDToIso(pos);
					mat.tx = borderOffsetX + pos.x;
					mat.ty = borderOffsetY + pos.y;
					
					roomData.terrainTile.gotoAndStop( tileType + 1 )
					_canvas.bitmapData.draw( roomData.terrainTile, mat);
					
					if(roomData.roomPickups[i][j] > 0)
					{
						roomData.pickupTile.gotoAndStop(roomData.roomPickups[i][j]);
						_canvas.bitmapData.draw(roomData.pickupTile, mat);
					}
					
					if(heroNode.x == j && heroNode.y == i)
					{
						mat.tx = roomData.hero.x;
						mat.ty = roomData.hero.y;
						_canvas.bitmapData.draw(roomData.hero, mat);
					}					
				}
			}
			
			_canvas.bitmapData.unlock();
		}
		
		//the game loop
		public final function loop():void
		{
			var doDepthSort:Boolean = false;
			// TO DO
			// seperate methods for keyboard and click/touch
			aiWalk();
			keyBoardControl();
			
			if (dY == 0 && dX == 0)
			{
				if (heroFacing != "") roomData.hero.clip.gotoAndStop(heroFacing);
				idle = true;
			}
			else if (idle || currentHeroFacing != heroFacing)
			{
				idle = false;
				currentHeroFacing = heroFacing;
				roomData.hero.clip.gotoAndPlay(heroFacing);
			}
			
			if (! idle && isWalkable())
			{
				heroCartPos.x +=  roomData.speed * dX;
				heroCartPos.y +=  roomData.speed * dY;
				
				cornerPoint.x -=  roomData.speed * dX;
				cornerPoint.y -=  roomData.speed * dY;
				
				doDepthSort = heroMoved();
			}
			
			if (doDepthSort) depthSort();
			
			//tileTxt.text="Hero is on x: "+heroTile.x +" & y: "+heroTile.y;
		}
		
		private function heroMoved():Boolean
		{
			// Map
			/*heroPointer.x = heroCartPos.x;
			heroPointer.y = heroCartPos.y;*/
			
			var newPos:Point = IsoHelper.twoDToIso(heroCartPos);
			heroNode = IsoHelper.getNodeCoordinates(heroCartPos, roomData.nodeWidth);
			
			var pickupType:uint = isPickup( heroNode )
			if( pickupType > 0 )
			{
				pickupItem( heroNode );
				broadcasterManager.broadcastEvent( IsoEvents.PICKUP_COLLECTED, {type:pickupType});
			}	
			
			var triggerNode:uint = roomData.roomTriggers[ heroNode.y ][ heroNode.x ];
			if (triggerNode > 0)
			{
				// FOUND ROOM SWAP TRIGGER
				// now that it's been established that the current hero node (trigerNode) is a trigger, we decrease it so that it is inline with the room numbering. Arrays start at 0.
				triggerNode--;
				if (triggerNode != roomsManager.roomCurrentNum)
				{
					if (triggerReset)
					{
						roomsManager.putRoomInStasis(roomData);
						roomsManager.roomCurrentNum = triggerNode;
						createLevel();
						
						broadcasterManager.broadcastEvent(IsoEvents.ROOM_CHANGE);
						
						triggerReset = false;
						
						return false;
					}
				}
			}
			else
			{
				triggerReset = true;
			}
			
			return true;
		}
		
		// Pickups
		private function isPickup(tilePt:Point):uint
		{
			return roomData.roomPickups[ tilePt.y ][ tilePt.x ];
		}
		
		private function pickupItem(tilePt:Point):void
		{
			roomData.roomPickups[ tilePt.y ][ tilePt.x ] = 0;
		}
		
		// room triggers
		private function isTrigger(tilePt:Point):Boolean
		{
			return( roomData.roomTriggers[ tilePt.y ][ tilePt.x ] > 0 );
		}
		
		//check for collision tile
		private function isWalkable():Boolean
		{
			var newPos:Point = new Point();
			newPos.x = heroCartPos.x + (roomData.speed * dX);
			newPos.y = heroCartPos.y + (roomData.speed * dY);
			
			switch (heroFacing)
			{
				case "north":
					newPos.y -= roomData.heroHalfSize;
					break;
				
				case "south":
					newPos.y += roomData.heroHalfSize;
					break;
				
				case "east":
					newPos.x += roomData.heroHalfSize;
					break;
				
				case "west":
					newPos.x -= roomData.heroHalfSize;
					break;
				
				case "northeast":
					newPos.y -= roomData.heroHalfSize;
					newPos.x += roomData.heroHalfSize;
					break;
				
				case "southeast":
					newPos.y += roomData.heroHalfSize;
					newPos.x += roomData.heroHalfSize;
					break;
				
				case "northwest":
					newPos.y -= roomData.heroHalfSize;
					newPos.x -= roomData.heroHalfSize;
					break;
				
				case "southwest":
					newPos.y += roomData.heroHalfSize;
					newPos.x -= roomData.heroHalfSize;
					break;
			}
			
			newPos = IsoHelper.getNodeCoordinates(newPos, roomData.nodeWidth);
			
			if (newPos.y < roomData.roomNodeHeight && newPos.x < roomData.roomNodeWidth && newPos.y >= 0 && newPos.x >= 0)
			{
				if(roomData.roomWalkable[newPos.y][newPos.x] == 1)
				{
					return false;
				}
				else
				{
					return true;
				}
			}
			else
			{
				return false
			}
		}
		
		/**
		 * Keyboard Control
		 */
		private function keyBoardControl():void
		{
			var keyControlled:Boolean = false;
			var pathFinding:Boolean = false;
			if (path.length > 0) pathFinding = true;
			
			if (key.isDown( Keyboard.UP ))
			{
				dY = -1;
				keyControlled = true;
			}
			else if (key.isDown( Keyboard.DOWN ))
			{
				dY = 1;
				keyControlled = true;
			}
			else
			{
				if (!pathFinding) dY = 0;
			}
			if (key.isDown( Keyboard.RIGHT ))
			{
				dX = 1;
				if (dY == 0)
				{
					heroFacing = "east";
				}
				else if (dY == 1)
				{
					heroFacing = "southeast";
					dX = dY = 0.75;
				}
				else
				{
					heroFacing = "northeast";
					dX = 0.75;
					dY =- 0.75;
				}
				keyControlled = true;
			}
			else if (key.isDown( Keyboard.LEFT ))
			{
				dX = -1;
				if (dY == 0)
				{
					heroFacing = "west";
				}
				else if (dY == 1)
				{
					heroFacing = "southwest";
					dY = 0.75;
					dX =- 0.75;
				}
				else
				{
					heroFacing = "northwest";
					dX = dY =- 0.75;
				}
				keyControlled = true;
			}
			else
			{
				if (!pathFinding) 
				{
					dX = 0;
					if (dY == 0)
					{
						//facing="west";
					}
					else if (dY == 1)
					{
						heroFacing = "south";
					}
					else
					{
						heroFacing = "north";
					}
				}
			}
			
			if (keyControlled)
			{
				//key board control active. Stop pathfinding
				path.length = 0;
			}
		}
		
		/**
		 * Click/Pathfinding control
		 */
		private function aiWalk():void
		{
			//trace("{IsoMaker} aiWalk -> path.length = " + path.length);
			if(path.length == 0)
			{
				//path has ended
				dX = dY = 0;
				//stepsTaken = 0;
				
				return;
			}
			
			if( heroNode.equals(destination) )
			{
				//reached current destination, set new, change direction
				//wait till we are few steps into the tile before we turn
				stepsTaken++;
				if(stepsTaken < stepsTillTurn)
				{
					return;
				}
				
				var run:Boolean = true;
				if (run)
				{
					//place the hero at tile middle before turn
					var pos:Point = new Point();
					pos.x = heroNode.x * roomData.nodeWidth + (roomData.nodeWidth / 2) + cornerPoint.x;
					pos.y = heroNode.y * roomData.nodeWidth + (roomData.nodeWidth / 2) + cornerPoint.y;
					
					pos = IsoHelper.twoDToIso(pos);
					
					roomData.hero.x = borderOffsetX + pos.x;
					roomData.hero.y = borderOffsetY + pos.y;
					
					heroCartPos.x = heroNode.x * roomData.nodeWidth + roomData.nodeWidth / 2;
					heroCartPos.y = heroNode.y * roomData.nodeWidth + roomData.nodeWidth / 2;
					
					/*heroPointer.x = heroCartPos.x;
					heroPointer.y = heroCartPos.y;
					depthSort();*/
				}
				
				
				//new point, turn, find dX,dY
				stepsTaken = 0;
				destination = path.pop();
				if(heroNode.x < destination.x)
				{
					dX = 1;
				}
				else if(heroNode.x > destination.x)
				{
					dX = -1;
				}
				else 
				{
					dX = 0;
				}
				if(heroNode.y < destination.y)
				{
					dY = 1;
				}
				else if(heroNode.y > destination.y)
				{
					dY = -1;
				}
				else 
				{
					dY = 0;
				}
				if(heroNode.x == destination.x)
				{
					//top or bottom
					dX = 0;
				}
				else if(heroNode.y == destination.y)
				{
					//left or right
					dY = 0;
				}
				
				if (dX == 1)
				{
					if (dY == 0)
					{
						heroFacing = "east";
					}
					else if (dY == 1)
					{
						heroFacing = "southeast";
						dX = dY = 0.5;
					}
					else
					{
						heroFacing = "northeast";
						dX = 0.5;
						dY = -0.5;
					}
				}
				else if (dX == -1)
				{
					if (dY == 0)
					{
						heroFacing = "west";
					}
					else if (dY == 1)
					{
						heroFacing = "southwest";
						dY = 0.5;
						dX = -0.5;
					}
					else
					{
						heroFacing= "northwest";
						dX = dY = -0.5;
					}
				}
				else
				{
					if (dY == 0)
					{
						heroFacing = currentHeroFacing;
					}
					else if (dY == 1)
					{
						heroFacing = "south";
					}
					else
					{
						heroFacing = "north";
					}
				}
			}
		}
		
		private function handleMouseClick(e:MouseEvent):void
		{
			path.splice(0, path.length);
			var clickPt:Point = new Point();
			
			clickPt.x = e.stageX - borderOffsetX;
			clickPt.y = e.stageY - borderOffsetY;
			//trace("{IsoMaker} handleMouseClick -> clickPt = " + clickPt);
			
			clickPt = IsoHelper.isoTo2D(clickPt);
			//trace("{IsoMaker} handleMouseClick -> isoTo2D clickPt = " + clickPt);
			
			clickPt.x -= roomData.nodeWidth / 2 + cornerPoint.x;
			clickPt.y += roomData.nodeWidth / 2 - cornerPoint.y;
			
			//trace("{IsoMaker} handleMouseClick -> half node width clickPt = " + clickPt);
			
			
			clickPt = IsoHelper.getNodeCoordinates( clickPt, roomData.nodeWidth );
			//trace("{IsoMaker} handleMouseClick -> clickPt in Node Coordinates = " + clickPt);
			if(clickPt.x < 0 || clickPt.y < 0 || clickPt.x > roomData.roomWalkable.length - 1 || clickPt.x > roomData.roomWalkable[0].length - 1)
			{
				//trace("{IsoMaker} handleMouseClick -> clicked outside of the room");
				return;
			}
			if(roomData.roomWalkable[clickPt.y][clickPt.x] > 0)
			{
				//trace("{IsoMaker} handleMouseClick -> clicked on a non walkable node");
				return;
			}
			//trace("{IsoMaker} handleMouseClick -> heroNode = " + heroNode + ", clickPt = " + clickPt);
			destination = heroNode;
			path = PathFinder.go( heroNode.x, heroNode.y, clickPt.x, clickPt.y, roomData.roomWalkable );
			path.reverse();
			path.push(clickPt);
			path.reverse();
			
			// TO DO
			// display path in Map
		}
	}
}