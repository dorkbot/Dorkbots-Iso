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
	import dorkbots.dorkbots_iso.entity.Entity;
	import dorkbots.dorkbots_iso.entity.EntityFactory;
	import dorkbots.dorkbots_iso.entity.IEnemy;
	import dorkbots.dorkbots_iso.entity.IEntity;
	import dorkbots.dorkbots_iso.entity.IEntityFactory;
	import dorkbots.dorkbots_iso.entity.IHero;
	import dorkbots.dorkbots_iso.room.IIsoRoomData;
	import dorkbots.dorkbots_iso.room.IIsoRoomsManager;
	import dorkbots.dorkbots_util.RemoveDisplayObjects;

	public class IsoMaker extends BroadcastingObject implements IIsoMaker
	{
		public static const ROOM_CHANGE:String = "room change";
		public static const PICKUP_COLLECTED:String = "pickup collected";
		public static const HERO_SHARING_NODE_WITH_ENEMY:String = "hero sharing node with enemy";
		
		//the canvas
		private var _canvas:Bitmap;
		private var rect:Rectangle;
		
		private var viewPortCornerPoint:Point = new Point();
		
		private var borderOffsetX:Number;
		private var borderOffsetY:Number;
		 
		//Senocular KeyObject Class
		private var key:KeyObject;
		
		private var underKeyBoardControl:Boolean = false;
		
		private var roomsManager:IIsoRoomsManager;
		private var roomData:IIsoRoomData;
		private var entityFactory:IEntityFactory;
		
		private var container_mc:DisplayObjectContainer;
		
		private var triggerReset:Boolean = true;
		
		private var _hero:IHero;
		private var _enemyTargetNode:Point;
		private var _enemiesSeekHero:Boolean = true;
		
		public function IsoMaker(aContainer_mc:DisplayObjectContainer, aRoomsManager:IIsoRoomsManager, aEntityFactory:IEntityFactory = null)
		{
			/*
			TO DO
			
			Create a map class that can be toggled on and off - clean up
			it only needs heroCartPos
			has its own createLevel, us only walkable level data	
			
			
			Block trigers by putting the room numbers into an array.
			this class double checks this array before swapping rooms.
			For progression, locking and un-locking rooms.
			
			first change roomData Array, make it use entities.
			Don't destroy or null this array.
			Entity Stasis
			Method for getting back the entity art when in stasis/after stasis.
			from Entity factory
			Do this, entities will need to preserve their health.
			add attack button/command
			enemie use attack?
			broadcast event when attack and attacking - entity
			build UI including button, button is for touch, also use cursor control
			
			
			*/
			container_mc = aContainer_mc;
			roomsManager = aRoomsManager;
			entityFactory = aEntityFactory;
			
			if (!entityFactory) entityFactory = new EntityFactory();
			
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
			container_mc.addEventListener(MouseEvent.CLICK, handleClick);
		}
		
		override public function dispose():void
		{
			_canvas = null;
			key.deconstruct();
			roomsManager.dispose();
			roomData = null;
			container_mc.removeEventListener(MouseEvent.CLICK, handleClick);
			container_mc = null;
			entityFactory.dispose();
			entityFactory = null;
			
			super.dispose();
		}
		
		public final function get enemiesSeekHero():Boolean
		{
			return _enemiesSeekHero;
		}
		
		public final function set enemiesSeekHero(value:Boolean):void
		{
			_enemiesSeekHero = value;
		}
		
		public final function get enemyTargetNode():Point
		{
			return _enemyTargetNode;
		}
		
		public final function set enemyTargetNode(value:Point):void
		{
			_enemyTargetNode = value;
		}
		
		public final function get hero():IHero
		{
			return _hero;
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
			// TO DO
			// fixing the floor issue
			// create floor once - create bitmap data
			// draw to canvas first
			// use the view port position and offset for its matrix
			// need to pass an array of wall tile art, these are tiles that have height.
			// draw wall tiles everyloop so the entities can appear behind them.
				
			// roomData has an array - tileArtWithHeight
			// add art that could be infront of an entity, cover it.
			// all other tile art is created once, during create room, this is back ground art.
			// this optimizes performance and display, it will prevent the floor tiles from sometimes covering up entities feet.
			
			roomData = roomsManager.getRoom(roomsManager.roomCurrentNum);
			roomData.init();
			
			if (!_hero)
			{
				_hero = entityFactory.createHero();
			}
			
			_hero.init(roomData.hero, roomData.speed, roomData.heroHalfSize, roomData, 1);
			
			borderOffsetX = roomData.borderOffsetX;
			borderOffsetY = roomData.borderOffsetY;
			
			_canvas = new Bitmap( new BitmapData( roomData.viewWidth, roomData.viewHeight ) );
			rect = _canvas.bitmapData.rect;
			RemoveDisplayObjects.removeAllDisplayObjects(container_mc);
			container_mc.addChild(_canvas);
			
			_hero.facingCurrent = "";
			
			if (!roomsManager.roomHasChanged)
			{
				_hero.facingNext = _hero.facingCurrent = roomData.heroFacing;
			}
			_hero.entity_mc.clip.gotoAndStop(_hero.facingNext);
			
			// TO DO
			// don't create a new one, check if there is already enemies in stasis
			roomData.enemies = new Vector.<IEnemy>();
			
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
						enemy = entityFactory.createEnemy(tileType);
						enemy.addEventListener( Entity.PATH_ARRIVED_NEXT_NODE, enemyArrivedAtNextPathNode);
						
						// TO DO
						// reanimate enemies if they are in stasis
						roomData.enemies.push( enemy.init( roomData.createEnemy(tileType), roomData.speed, roomData.enemyHalfSize, roomData, tileType ) );

						placeEntity(enemy, j, i, tileType);
					}
					
					if (buildHero)
					{
						// found hero
						// makes sure hero is positioned in the center of the screen
						placeEntity(_hero, j, i, tileType);
						
						postionViewPortCornerPoint();
						
						var pos:Point = _hero.cartPos.clone();
						pos.x += viewPortCornerPoint.x;
						pos.y += viewPortCornerPoint.y;
						pos = IsoHelper.twoDToIso(pos);
						_hero.entity_mc.x = borderOffsetX + pos.x;
						_hero.entity_mc.y = borderOffsetY + pos.y;
						
						buildHero = false;
						
						//break toploop;
					}				
				}
			}
			
			updateEnemiesWalkable();
			if (_enemiesSeekHero) _enemyTargetNode = _hero.node;
			if (_enemyTargetNode)
			{
				for (i = 0; i < roomData.enemies.length; i++)
				{
					roomData.enemies[i].findPathToNode(_enemyTargetNode);
				}
			}
			
			//trace("enemies = " + enemies.length);
			drawToCanvas();
		}
		
		private function postionViewPortCornerPoint():void
		{
			viewPortCornerPoint.x = viewPortCornerPoint.y = 0;
			viewPortCornerPoint.x -= (_hero.cartPos.x - (roomData.viewWidth / 2)) + _hero.entity_mc.width;
			viewPortCornerPoint.y -= _hero.cartPos.y - (roomData.viewHeight / 2);
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
		private function drawToCanvas():void
		{
			_canvas.bitmapData.lock();
			_canvas.bitmapData.fillRect(rect, 0xffffff);
			
			var tileType:uint;
			var mat:Matrix = new Matrix();
			var pos:Point = new Point();
			var enemy:IEnemy;
			var enemiesAddedToNode:uint = 0;
			var addHero:Boolean = false;
			var entitiesToAddToNode:Array = new Array();
			//var objectsToAdd:Array = new Array();
			var k:int = 0;
			
			for (var i:uint = 0; i < roomData.roomNodeGridHeight; i++)
			{
				for (var j:uint = 0; j < roomData.roomNodeGridWidth; j++)
				{
					entitiesToAddToNode.length = 0;
					addHero = false;
					
					tileType = roomData.roomTileArt[i][j];
					
					pos.x = j * roomData.nodeWidth + viewPortCornerPoint.x;
					pos.y = i * roomData.nodeWidth + viewPortCornerPoint.y;
					
					pos = IsoHelper.twoDToIso(pos);
					mat.tx = borderOffsetX + pos.x;
					mat.ty = borderOffsetY + pos.y;
					
					roomData.tileArt.gotoAndStop( tileType + 1 );
					_canvas.bitmapData.draw( roomData.tileArt, mat);
					
					if(roomData.roomPickups[i][j] > 0)
					{
						roomData.tilePickup.gotoAndStop(roomData.roomPickups[i][j]);
						_canvas.bitmapData.draw(roomData.tilePickup, mat);
					}
					
					if(_hero.node.x == j && _hero.node.y == i)
					{
						addHero = true;
						mat.tx = _hero.entity_mc.x;
						if (_hero.entity_mc.y > mat.ty) trace("hero's y = " + _hero.entity_mc.y + ", mat.ty = " + mat.ty);
						mat.ty = _hero.entity_mc.y;
						//trace("hero.entity_mc.x = " + hero.entity_mc.x + ", hero.entity_mc.y = " + hero.entity_mc.y);
						
						entitiesToAddToNode.push( {matrixTY: mat.ty, matrix: mat.clone(), entity: _hero} );
					}
					
					// TO DO
					// when adding the grid system, wont need this loop.
					// add enemies to canvas
					
					// TO DO
					// build an array only for enemies, number represents position, -1 is no enemie.
					// remove this search for loop
					enemiesAddedToNode = 0;
					for (k = 0; k < roomData.enemies.length; k++) 
					{
						enemy = roomData.enemies[k];
						if(enemy.node.x == j && enemy.node.y == i)
						{
							pos.x = enemy.cartPos.x + viewPortCornerPoint.x;
							pos.y = enemy.cartPos.y + viewPortCornerPoint.y;
							pos = IsoHelper.twoDToIso(pos);
							mat.tx = borderOffsetX + pos.x;
							mat.ty = borderOffsetY + pos.y - (enemiesAddedToNode * 2);
							//_canvas.bitmapData.draw(enemy.entity_mc, mat);
							
							entitiesToAddToNode.push( {matrixTY: mat.ty, matrix: mat.clone(), entity: enemy} );
							
							enemiesAddedToNode++;
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
			// TO DO
			// set walkable for each entity, Enities don't use roomData. walkable is created at the start of the loop.
			// each type may need its own walkable, but not indiviual entities. Hero and Enemies.
			// remove the walkable list from the pathFinder. 
			// create a walkable for it, 0 is walkable, simple.
			
			// first create entity walkable area.
			// then refactor entity code to use it. temp set it to roomData walkable.
			// then IsoMaker starts to build the arrays every loop. Use the entities...
			//But
			// what if an only one or a few entities can update, somethings become walkable?
			// current list method is probably best, allows for dynamic walkable setting.
			//
			// write up a comment explaining logic and benift of current list approach.
			// don't have to traverse loops and set. List is better, it's inserted into Path finding search.
			
			
			
			// Enemies killing
			// build all from entities array
			var movement:Boolean = false;
			
			// Move and update hero
			_hero.loop();
			
			keyBoardControl();
			
			_hero.move();
			
			if (_hero.moved)
			{				
				if (heroMoved())
				{
					movement = true;
					
					viewPortCornerPoint.x -=  _hero.movedAmountPoint.x;
					viewPortCornerPoint.y -=  _hero.movedAmountPoint.y;
				}
			}
			
			if (_enemiesSeekHero) _enemyTargetNode = hero.node;
			
			// move enemies
			updateEnemiesWalkable();
			
			var i:int;
			var enemy:IEnemy;
			
			// update enemies
			for (i = 0; i < roomData.enemies.length; i++) 
			{
				enemy = roomData.enemies[i];
				roomData.enemiesWalkable[enemy.node.y][enemy.node.x] = 0;
				enemy.loop();
				enemy.move();
				if (enemy.distroyed)
				{
					// dispose of enemy
					movement = true;
					roomData.enemies.splice( roomData.enemies.indexOf( enemy ) , 1 );
					roomData.roomEntities[enemy.node.y][enemy.node.x] = 0;
					enemy.dispose();
				}
				else
				{
					roomData.enemiesWalkable[enemy.node.y][enemy.node.x] = enemy.type;
					
					// if enemy has stopped hunting, set a new path for the hero
					if (!enemy.finalDestination && !enemy.node.equals(_enemyTargetNode) )
					{
						if (_enemyTargetNode) enemy.findPathToNode(_enemyTargetNode);
					}
					
					if (enemy.moved)
					{
						//trace("enemy move");
						movement = true;
					}
					
					if (enemy.node.equals(_hero.node))
					{
						broadcastEvent( HERO_SHARING_NODE_WITH_ENEMY, {enemy: enemy} );
					}
				}
			}
			
			if (movement)
			{
				drawToCanvas();
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
			
			var newPos:Point = IsoHelper.twoDToIso(_hero.cartPos);
			
			var pickupType:uint = isPickup( _hero.node );
			if( pickupType > 0 )
			{
				pickupItem( _hero.node );
				broadcastEvent( PICKUP_COLLECTED, {type:pickupType});
			}	
			
			var triggerNode:uint = roomData.roomTriggers[ _hero.node.y ][ _hero.node.x ];
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
			
			broadcastEvent(ROOM_CHANGE, {roomNumber: roomNumber});
			
			triggerReset = false;
		}
		
		
		/**
		 * ENEMIES STUFF
		 */
		private function enemyArrivedAtNextPathNode(event:IBroadcastedEvent):void
		{
			var enemy:IEnemy = IEnemy(event.owner);
			if (enemy.finalDestination)
			{
				if(!enemy.finalDestination.equals(_enemyTargetNode)) 
				{
					enemy.findPathToNode(_enemyTargetNode);
				}
			}
			else
			{
				if ( !enemy.node.equals(_enemyTargetNode) ) enemy.findPathToNode(_enemyTargetNode);
			}
		}
		
		public final function enemyDestroy(enemy:IEnemy):void
		{
			enemy.distroyed = true;
		}
		
		// TO DO
		// use this or not?
		// don't destroy enemies when leaving a room
		// put enemies in stasis
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
			for (i = 0; i < roomData.enemies.length; i++) 
			{
				enemy = roomData.enemies[i];
				enemy.removeEventListener( Entity.PATH_ARRIVED_NEXT_NODE, enemyArrivedAtNextPathNode);
				roomData.roomEntities[enemy.node.y][enemy.node.x] = enemy.type;
				enemy.dispose();
			}
			roomData.enemies.length = 0;
		}
		
		// TO DO
		// use this or not?
		private function updateEnemiesWalkable():void
		{
			var newWalkable:Array = roomData.enemiesWalkable;
			
			var i:int;
			var enemy:IEnemy;
			
			for (i = 0; i < roomData.roomNodeGridHeight; i++)
			{
				newWalkable[i] = roomData.roomWalkable[i].slice();
			}
			
			for (i = 0; i < roomData.enemies.length; i++) 
			{
				enemy = roomData.enemies[i];
				newWalkable[enemy.node.y][enemy.node.x] = 1;
			}
		}
		
		
		/**
		 * HERO STUFF
		 */
		
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
			var keyBoardControl:Boolean = false;
			var pathFinding:Boolean = false;
			if (_hero.path.length > 0) pathFinding = true;
			
			if (key.isDown( Keyboard.UP ))
			{
				_hero.dY = -1;
				keyBoardControl = true;
			}
			else if (key.isDown( Keyboard.DOWN ))
			{
				_hero.dY = 1;
				keyBoardControl = true;
			}
			else
			{
				if (!pathFinding) _hero.dY = 0;
			}
			
			if (key.isDown( Keyboard.RIGHT ))
			{
				_hero.dX = 1;
				if (_hero.dY == 0)
				{
					_hero.facingNext = "east";
				}
				else if (_hero.dY == 1)
				{
					_hero.facingNext = "southeast";
					_hero.dX = _hero.dY = 0.5;
				}
				else
				{
					_hero.facingNext = "northeast";
					_hero.dX = 0.5;
					_hero.dY =- 0.5;
				}
				keyBoardControl = true;
			}
			else if (key.isDown( Keyboard.LEFT ))
			{
				_hero.dX = -1;
				if (_hero.dY == 0)
				{
					_hero.facingNext = "west";
				}
				else if (_hero.dY == 1)
				{
					_hero.facingNext = "southwest";
					_hero.dY = 0.5;
					_hero.dX =- 0.5;
				}
				else
				{
					_hero.facingNext = "northwest";
					_hero.dX = _hero.dY =- 0.5;
				}
				keyBoardControl = true;
			}
			else
			{
				if (!pathFinding) 
				{
					_hero.dX = 0;
					if (_hero.dY == 0)
					{
						//facing="west";
					}
					else if (_hero.dY == 1)
					{
						_hero.facingNext = "south";
					}
					else
					{
						_hero.facingNext = "north";
					}
				}
			}
			
			if (keyBoardControl)
			{
				//key board control active. Stop pathfinding
				_hero.path.length = 0;
				//hero.moved = true;
				underKeyBoardControl = true;
			}
		}
		
		/**
		 * Click Control
		 */
		private function handleClick(e:MouseEvent):void
		{
			var clickPt:Point = new Point();
			
			clickPt.x = e.stageX - borderOffsetX;
			clickPt.y = e.stageY - borderOffsetY;
			//trace("{IsoMaker} handleMouseClick -> clickPt = " + clickPt);
			
			clickPt = IsoHelper.isoTo2D(clickPt);
			//trace("{IsoMaker} handleMouseClick -> isoTo2D clickPt = " + clickPt);
			
			clickPt.x -= roomData.nodeWidth / 2 + viewPortCornerPoint.x;
			clickPt.y += roomData.nodeWidth / 2 - viewPortCornerPoint.y;
			
			//trace("{IsoMaker} handleMouseClick -> half node width clickPt = " + clickPt);
			
			clickPt = IsoHelper.getNodeCoordinates( clickPt, roomData.nodeWidth );
			//trace("{IsoMaker} handleMouseClick -> clickPt in Node Coordinates = " + clickPt);
			if(clickPt.x < 0 || clickPt.y < 0 || clickPt.x > roomData.roomWalkable.length - 1 || clickPt.x > roomData.roomWalkable[0].length - 1)
			{
				//trace("{IsoMaker} handleMouseClick -> clicked outside of the room");
				return;
			}
			if (!hero.isWalkable(roomData.roomWalkable[clickPt.y][clickPt.x]))
			{
				//trace("{IsoMaker} handleMouseClick -> clicked on a non walkable node");
				return;
			}
			
			// if hero was under keyboard control, then first place it in the center of its current node. otherwise the visual position is broken
			if (underKeyBoardControl)
			{
				_hero.dX = _hero.dY = 0;
				_hero.putEntityInMiddleOfNode();
				_hero.move();
				postionViewPortCornerPoint();
				
				underKeyBoardControl = false;
			}
			
			//trace("{IsoMaker} handleMouseClick -> hero Node = " + hero.node + ", clickPt = " + clickPt);
			_hero.findPathToNode(clickPt, false);
			
			// TO DO
			// display path in Map
		}
	}
}