package dorkbots.dorkbots_iso
{
	import com.csharks.juwalbose.IsoHelper;
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
	import dorkbots.dorkbots_broadcasters.IBroadcastedEvent;
	import dorkbots.dorkbots_iso.entity.Enemy;
	import dorkbots.dorkbots_iso.entity.Entity;
	import dorkbots.dorkbots_iso.entity.Hero;
	import dorkbots.dorkbots_iso.entity.IEnemy;
	import dorkbots.dorkbots_iso.entity.IEntity;
	import dorkbots.dorkbots_iso.entity.IHero;
	import dorkbots.dorkbots_iso.room.IIsoRoomData;
	import dorkbots.dorkbots_iso.room.IIsoRoomsManager;
	import dorkbots.dorkbots_util.RemoveDisplayObjects;

	public class IsoMaker extends BroadcastingObject implements IIsoMaker
	{		
		//the canvas
		private var _canvas:Bitmap;
		private var rect:Rectangle;
		
		private var viewPortcornerPoint:Point = new Point();
		
		private var borderOffsetX:Number;
		private var borderOffsetY:Number;
		 
		//Senocular KeyObject Class
		private var key:KeyObject;
		
		private var roomsManager:IIsoRoomsManager;
		private var roomData:IIsoRoomData;
		
		private var container_mc:DisplayObjectContainer;
		
		private var triggerReset:Boolean = true;
		
		private var hero:IHero;
		private var enemies:Vector.<IEnemy> = new Vector.<IEnemy>();
		
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
			viewPortcornerPoint.x = viewPortcornerPoint.y = 0;
				
			roomData = roomsManager.getRoom(roomsManager.roomCurrentNum);
			roomData.init();
			
			if (!hero)
			{
				hero = new Hero();
			}
			
			hero.init(roomData.hero, roomData.speed, roomData.heroHalfSize, roomData, 1);
			
			borderOffsetX = roomData.borderOffsetX;
			borderOffsetY = roomData.borderOffsetY;
			
			_canvas = new Bitmap( new BitmapData( roomData.viewWidth, roomData.viewHeight ) );
			rect = _canvas.bitmapData.rect;
			RemoveDisplayObjects.removeDisplayObjects(container_mc);
			container_mc.addChild(_canvas);
			
			hero.facingCurrent = "";
			
			if (!roomsManager.roomHasChanged)
			{
				hero.facingNext = hero.facingCurrent = roomData.heroFacing;
			}
			hero.entity_mc.clip.gotoAndStop(hero.facingNext);
			
			// Look for hero
			var buildHero:Boolean = false;
			var tileType:uint;
			var adjustedX:Number;
			var adjustedY:Number;
			var enemy:IEnemy;
			var i:uint;
			// label for the first loop, used for break
			toploop: 
			for (i = 0; i < roomData.roomNodeGridHeight; i++)
			{
				for (var j:uint = 0; j < roomData.roomNodeGridWidth; j++)
				{		
					tileType = roomData.roomEntities[i][j];
					if (!roomsManager.roomHasChanged)
					{
						// first room
						if (tileType == 1)
						{
							buildHero = true;
						}
					}
					else
					{
						// rooms have swapped, place hero on trigger for previous room
						if (roomData.roomTriggers[i][j] == roomsManager.roomLastNum + 1)
						{
							buildHero = true;
						}	
					}
					//trace("tileType = " + tileType);
					if (tileType > 1)
					{
						//trace("found enemy j = " + j + ", i = " + i);
						enemy = new Enemy();
						enemy.addEventListener( Entity.PATH_ARRIVED_NEXT_NODE, enemyArrivedAtNextPathNode);
						enemies.push( enemy.init( roomData.createEnemy(tileType), roomData.speed, roomData.enemyHalfSize, roomData, tileType ) );

						placeEntity(enemy, j, i, tileType);
					}
					
					if (buildHero)
					{
						// found hero
						// makes sure hero is positioned in the center of the screen
						placeEntity(hero, j, i, tileType);
						
						viewPortcornerPoint.x -= (hero.cartPos.x - (roomData.viewWidth / 2));
						viewPortcornerPoint.y -= hero.cartPos.y - (roomData.viewHeight / 2);
						
						var pos:Point = hero.cartPos.clone();
						pos.x += viewPortcornerPoint.x;
						pos.y += viewPortcornerPoint.y;
						pos = IsoHelper.twoDToIso(pos);
						hero.entity_mc.x = borderOffsetX + pos.x;
						hero.entity_mc.y = borderOffsetY + pos.y;
						
						buildHero = false;
						
						//break toploop;
					}
				}
			}
			
			for (i = 0; i < enemies.length; i++)
			{
				enemies[i].findPathToNode(hero.node);
			}
			
			roomData.enemies = enemies;
			
			//trace("enemies = " + enemies.length);
			depthSort();
		}
		
		private function placeEntity(entity:IEntity, x:uint, y:uint, type):void
		{			
			//find the middle of the node
			entity.cartPos.x = x * roomData.nodeWidth + (roomData.nodeWidth / 2);
			entity.cartPos.y = y * roomData.nodeWidth + (roomData.nodeWidth / 2);
			
			entity.node.x = x;
			entity.node.y = y;
		}
		
		//sort depth & draw to canvas
		private function depthSort():void
		{
			_canvas.bitmapData.lock();
			_canvas.bitmapData.fillRect(rect, 0xffffff);
			
			var tileType:uint;
			var mat:Matrix = new Matrix();
			var pos:Point = new Point();
			var enemy:IEnemy;
			var addHero:Boolean = false;
			var entitiesToAddToNode:Array = new Array();
			var k:int = 0;
			
			for (var i:uint = 0; i < roomData.roomNodeGridHeight; i++)
			{
				for (var j:uint = 0; j < roomData.roomNodeGridWidth; j++)
				{
					entitiesToAddToNode.length = 0;
					addHero = false;
					
					tileType = roomData.roomTerrain[i][j];
					
					pos.x = j * roomData.nodeWidth + viewPortcornerPoint.x;
					pos.y = i * roomData.nodeWidth + viewPortcornerPoint.y;
					
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
						addHero = true;
						mat.tx = hero.entity_mc.x;
						mat.ty = hero.entity_mc.y;
						//trace("hero.entity_mc.x = " + hero.entity_mc.x + ", hero.entity_mc.y = " + hero.entity_mc.y);
						//_canvas.bitmapData.draw(hero.entity_mc, mat);
						
						entitiesToAddToNode.push( {matrixTY: mat.ty, matrix: mat.clone(), entity: hero} );
					}
					
					// add enemies to canvas
					for (k = 0; k < enemies.length; k++) 
					{
						enemy = enemies[k];
						if(enemy.node.x == j && enemy.node.y == i)
						{
							pos.x = enemy.cartPos.x + viewPortcornerPoint.x;
							pos.y = enemy.cartPos.y + viewPortcornerPoint.y;
							pos = IsoHelper.twoDToIso(pos);
							mat.tx = borderOffsetX + pos.x;
							mat.ty = borderOffsetY + pos.y;
							//_canvas.bitmapData.draw(enemy.entity_mc, mat);
							
							entitiesToAddToNode.push( {matrixTY: mat.ty, matrix: mat.clone(), entity: enemy} );
						}
					}
					
					// add entities bassed on their matrix.ty, so that entities with a higher ty will be drawn in front
					if (entitiesToAddToNode.length > 0)
					{
						entitiesToAddToNode.sortOn("matrixTY", Array.NUMERIC);
						for (k = 0; k < entitiesToAddToNode.length; k++) 
						{
							_canvas.bitmapData.draw( IEntity(entitiesToAddToNode[k].entity).entity_mc, entitiesToAddToNode[k].matrix);
						}
						
					}
				}
			}
			
			_canvas.bitmapData.unlock();
		}
		
		//the game loop
		public final function loop():void
		{
			var movement:Boolean = false;
			
			hero.loop();
			
			keyBoardControl();
			
			hero.move();
			
			if (hero.moved)
			{				
				if (heroMoved())
				{
					movement = true;
					
					viewPortcornerPoint.x -=  hero.movedAmountPoint.x;
					viewPortcornerPoint.y -=  hero.movedAmountPoint.y;
				}
			}
			
			var enemy:IEnemy;
			for (var i:int = 0; i < enemies.length; i++) 
			{
				enemy = enemies[i];
				enemy.loop();
				enemy.move();
				
				// if enemy has stopped hunting, set a new path for the hero
				if (!enemy.finalDestination && !enemy.node.equals(hero.node) )
				{
					enemy.findPathToNode(hero.node);
				}
				
				if (enemy.moved)
				{
					//trace("enemy move");
					movement = true;
				}
				
				if (enemy.node.equals(hero.node))
				{
					//trace("hero and enemy share same node!!!");
				}
			}
			
			if (movement)
			{
				depthSort();
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
						swapRoom(triggerNode);
						
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
		
		private function swapRoom(roomNumber:uint):void
		{
			disposeOfEnemies();
			
			roomsManager.putRoomInStasis(roomData);
			roomsManager.roomCurrentNum = roomNumber;
			createRoom();
			
			broadcasterManager.broadcastEvent(IsoEvents.ROOM_CHANGE);
			
			triggerReset = false;
		}
		
		private function enemyArrivedAtNextPathNode(event:IBroadcastedEvent):void
		{
			var enemy:IEnemy = IEnemy(event.owner);
			if (enemy.finalDestination)
			{
				if(!enemy.finalDestination.equals(hero.node)) 
				{
					enemy.findPathToNode(hero.node);
				}
			}
			else
			{
				if ( !enemy.node.equals(hero.node) ) enemy.findPathToNode(hero.node);
			}
		}
		
		// TO DO
		// put enemies in statis
		private function disposeOfEnemies():void
		{
			var i:uint;
			for (i = 0; i < roomData.roomEntities.length; i++) 
			{
				for (var j:int = 0; j < roomData.roomEntities[i].length; j++) 
				{
					roomData.roomEntities[i][j] = 0;
				}
			}
			
			var enemy:IEnemy
			for (i = 0; i < enemies.length; i++) 
			{
				enemy = enemies[i];
				enemy.removeEventListener( Entity.PATH_ARRIVED_NEXT_NODE, enemyArrivedAtNextPathNode);
				roomData.roomEntities[enemy.node.y][enemy.node.x] = enemy.type;
				enemy.dispose();
			}
			enemies.length = 0;
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
					hero.facingNext = "east";
				}
				else if (hero.dY == 1)
				{
					hero.facingNext = "southeast";
					hero.dX = hero.dY = 0.75;
				}
				else
				{
					hero.facingNext = "northeast";
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
					hero.facingNext = "west";
				}
				else if (hero.dY == 1)
				{
					hero.facingNext = "southwest";
					hero.dY = 0.75;
					hero.dX =- 0.75;
				}
				else
				{
					hero.facingNext = "northwest";
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
						hero.facingNext = "south";
					}
					else
					{
						hero.facingNext = "north";
					}
				}
			}
			
			if (keyControlled)
			{
				//key board control active. Stop pathfinding
				hero.path.length = 0;
				//hero.moved = true;
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
			
			clickPt.x -= roomData.nodeWidth / 2 + viewPortcornerPoint.x;
			clickPt.y += roomData.nodeWidth / 2 - viewPortcornerPoint.y;
			
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
			
			//trace("{IsoMaker} handleMouseClick -> hero Node = " + hero.node + ", clickPt = " + clickPt);
			hero.findPathToNode(clickPt);
			
			// TO DO
			// display path in Map
		}
	}
}