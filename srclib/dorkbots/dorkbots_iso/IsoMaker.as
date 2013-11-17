package dorkbots.dorkbots_iso
{
	import com.csharks.juwalbose.IsoHelper;
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
	import dorkbots.dorkbots_iso.entity.IHero;
	import dorkbots.dorkbots_iso.room.IIsoRoomData;
	import dorkbots.dorkbots_iso.room.IIsoRoomsManager;
	import dorkbots.dorkbots_util.RemoveDisplayObjects;
	import dorkbots.dorkbots_iso.entity.Hero;

	public class IsoMaker extends BroadcastingObject implements IIsoMaker
	{		
		//the canvas
		private var _canvas:Bitmap;
		private var rect:Rectangle;
		
		private var cornerPoint:Point = new Point();
		
		private var borderOffsetX:Number;
		private var borderOffsetY:Number;
		 
		//Senocular KeyObject Class
		private var key:KeyObject;
		
		private var roomsManager:IIsoRoomsManager;
		private var roomData:IIsoRoomData;
		
		private var container_mc:DisplayObjectContainer;
		
		private var triggerReset:Boolean = true;
		
		private var hero:IHero;
		
		public function IsoMaker(aContainer_mc:DisplayObjectContainer, aRoomsManager:IIsoRoomsManager)
		{
			/*
			TO DO
			
			Create a map class that can be toggled on and off - clean up
			it only needs heroCartPos
			has its own createLevel, us only walkable level data	
			
			
			Block trigers by putting the room numbers into an array.
			this class double checks this array before swapping rooms.
			
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
		
		private function containerAddedToStage(event:Event = null):void
		{
			container_mc.removeEventListener(Event.ADDED_TO_STAGE, containerAddedToStage);
			key = new KeyObject(container_mc.stage);
			container_mc.addEventListener(MouseEvent.CLICK, handleMouseClick);
		}
		
		override public function dispose():void
		{
			_canvas = null;
			key.deconstruct();
			roomsManager.dispose();
			roomData = null;
			container_mc.removeEventListener(MouseEvent.CLICK, handleMouseClick);
			container_mc = null;
			
			super.dispose();
		}
		
		public final function get canvas():Bitmap
		{
			return _canvas;
		}

		public final function start():void
		{
			createRoom();
		}
		
		private function createRoom():void
		{			
			cornerPoint.x = cornerPoint.y = 0;
				
			roomData = roomsManager.getRoom(roomsManager.roomCurrentNum);
			roomData.init();
			
			if (!hero)
			{
				hero = new Hero();
			}
			
			hero.init(roomData.hero, roomData.speed, roomData.entityHalfSize, roomData);
			
			borderOffsetX = roomData.borderOffsetX;
			borderOffsetY = roomData.borderOffsetY;
			
			_canvas = new Bitmap( new BitmapData( roomData.viewWidth, roomData.viewHeight ) );
			rect = _canvas.bitmapData.rect;
			RemoveDisplayObjects.removeDisplayObjects(container_mc);
			container_mc.addChild(_canvas);
			
			hero.currentFacing = "";
			
			if (!roomsManager.roomHasChanged)
			{
				hero.facing = hero.currentFacing = roomData.heroFacing;
			}
			hero.entity_mc.clip.gotoAndStop(hero.facing);
			
			// Look for hero
			var buildHero:Boolean = false;
			var tileType:uint;
			
			// label for the first loop, used for break
			toploop: 
			for (var i:uint = 0; i < roomData.roomNodeGridHeight; i++)
			{
				for (var j:uint = 0; j < roomData.roomNodeGridWidth; j++)
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
						// rooms have swapped, place hero on trigger for previous room
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
						var adjustedX:Number = (j * roomData.nodeWidth) - ((j * roomData.nodeWidth) - (roomData.viewWidth * .5)) - hero.entity_mc.width;
						var adjustedY:Number = (i * roomData.nodeWidth) - ((i * roomData.nodeWidth) - (roomData.viewHeight * .5));
						
						var pos:Point = new Point();
						pos.x = adjustedX;
						pos.y = adjustedY;	
						
						pos = IsoHelper.twoDToIso(pos);
						hero.entity_mc.x = roomData.borderOffsetX + pos.x;
						hero.entity_mc.y = roomData.borderOffsetY + pos.y;
						
						hero.cartPos.x = j * roomData.nodeWidth;
						hero.cartPos.y = i * roomData.nodeWidth;
						
						hero.node.x = j;
						hero.node.y = i;	
						
						// repositions the camera so the hero is in the center of the screen
						cornerPoint.x -= ((j * roomData.nodeWidth) - (roomData.viewWidth * .5)) + hero.entity_mc.width;
						cornerPoint.y -= ((i * roomData.nodeWidth) - (roomData.viewHeight * .5));	
						
						buildHero = false;
						
						break toploop;
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
			
			for (var i:uint = 0; i < roomData.roomNodeGridHeight; i++)
			{
				for (var j:uint = 0; j < roomData.roomNodeGridWidth; j++)
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
					
					if(hero.node.x == j && hero.node.y == i)
					{
						mat.tx = hero.entity_mc.x;
						mat.ty = hero.entity_mc.y;
						_canvas.bitmapData.draw(hero.entity_mc, mat);
					}		
				}
			}
			
			_canvas.bitmapData.unlock();
		}
		
		//the game loop
		public final function loop():void
		{			
			hero.loop(cornerPoint);
			
			keyBoardControl();
			
			hero.move();

			if (hero.moved)
			{
				cornerPoint.x -=  hero.movedAmountPoint.x;
				cornerPoint.y -=  hero.movedAmountPoint.y;
				
				if (heroMoved())
				{
					depthSort();
				}
			}
		}
		
		
		/**
		 * heroMoved
		 * 
		 * returns Boolean - false if trigger found.
		 */
		private function heroMoved():Boolean
		{
			// Map
			/*heroPointer.x = heroCartPos.x;
			heroPointer.y = heroCartPos.y;*/
			
			var newPos:Point = IsoHelper.twoDToIso(hero.cartPos);
			
			var pickupType:uint = isPickup( hero.node );
			if( pickupType > 0 )
			{
				pickupItem( hero.node );
				broadcasterManager.broadcastEvent( IsoEvents.PICKUP_COLLECTED, {type:pickupType});
			}	
			
			var triggerNode:uint = roomData.roomTriggers[ hero.node.y ][ hero.node.x ];
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
						createRoom();
						
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
		
		
		/**
		 * Pickups
		 */
		private function isPickup(tilePt:Point):uint
		{
			return roomData.roomPickups[ tilePt.y ][ tilePt.x ];
		}
		
		private function pickupItem(tilePt:Point):void
		{
			roomData.roomPickups[ tilePt.y ][ tilePt.x ] = 0;
		}
		
		
		/**
		 * Room triggers
		 */
		private function isTrigger(tilePt:Point):Boolean
		{
			return( roomData.roomTriggers[ tilePt.y ][ tilePt.x ] > 0 );
		}
		

		/**
		 * Keyboard Control
		 */
		private function keyBoardControl():void
		{
			var keyControlled:Boolean = false;
			var pathFinding:Boolean = false;
			if (hero.path.length > 0) pathFinding = true;
			
			if (key.isDown( Keyboard.UP ))
			{
				hero.dY = -1;
				keyControlled = true;
			}
			else if (key.isDown( Keyboard.DOWN ))
			{
				hero.dY = 1;
				keyControlled = true;
			}
			else
			{
				if (!pathFinding) hero.dY = 0;
			}
			
			if (key.isDown( Keyboard.RIGHT ))
			{
				hero.dX = 1;
				if (hero.dY == 0)
				{
					hero.facing = "east";
				}
				else if (hero.dY == 1)
				{
					hero.facing = "southeast";
					hero.dX = hero.dY = 0.75;
				}
				else
				{
					hero.facing = "northeast";
					hero.dX = 0.75;
					hero.dY =- 0.75;
				}
				keyControlled = true;
			}
			else if (key.isDown( Keyboard.LEFT ))
			{
				hero.dX = -1;
				if (hero.dY == 0)
				{
					hero.facing = "west";
				}
				else if (hero.dY == 1)
				{
					hero.facing = "southwest";
					hero.dY = 0.75;
					hero.dX =- 0.75;
				}
				else
				{
					hero.facing = "northwest";
					hero.dX = hero.dY =- 0.75;
				}
				keyControlled = true;
			}
			else
			{
				if (!pathFinding) 
				{
					hero.dX = 0;
					if (hero.dY == 0)
					{
						//facing="west";
					}
					else if (hero.dY == 1)
					{
						hero.facing = "south";
					}
					else
					{
						hero.facing = "north";
					}
				}
			}
			
			if (keyControlled)
			{
				//key board control active. Stop pathfinding
				hero.path.length = 0;
			}
		}
		
		private function handleMouseClick(e:MouseEvent):void
		{
			hero.path.length = 0;
			
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
			hero.createPath(clickPt);
			
			// TO DO
			// display path in Map
		}
	}
}