package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import dorkbots.dorkbots_broadcasters.IBroadcastedEvent;
	import dorkbots.dorkbots_iso.IIsoMaker;
	import dorkbots.dorkbots_iso.IsoMaker;
	import dorkbots.dorkbots_iso.entity.Entity;
	import dorkbots.dorkbots_iso.room.IIsoRoomsManager;
	import dorkbots.dorkbots_iso.room.IsoRoomsManager;
	
	import entities.EntityDorkbotsFactory;
	
	import rooms.Room1Data;
	import rooms.Room2Data;
	import rooms.Room3Data;
	import rooms.Room4Data;
	
	[SWF(width='800', height='600', backgroundColor='#FFFFFF', frameRate='30')]
	public class Main extends Sprite
	{	
		private var isoMaker:IIsoMaker;
		private var roomsManager:IIsoRoomsManager;
		
		public function Main()
		{
			roomsManager = new IsoRoomsManager();
			roomsManager.addRoom( Room1Data );
			roomsManager.addRoom( Room2Data );
			roomsManager.addRoom( Room3Data );
			roomsManager.addRoom( Room4Data );
			
			var isoContainer:Sprite = new Sprite();
			addChild(isoContainer);
			
			isoMaker = new IsoMaker( isoContainer, roomsManager, new EntityDorkbotsFactory());
			isoMaker.addEventListener( IsoMaker.ROOM_CHANGE, roomChange );
			isoMaker.addEventListener( IsoMaker.PICKUP_COLLECTED, pickupCollected );
			isoMaker.addEventListener( IsoMaker.HERO_SHARING_NODE_WITH_ENEMY, heroSharingNodeWithEnemy );
			isoMaker.start();
			
			isoMaker.hero.addEventListener( Entity.WALKING_ON_NODE_TYPE_OTHER, heroWalkingOnNodeTypeOther );
			
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(event:Event):void
		{
			isoMaker.loop();
		}
		
		private function roomChange(event:IBroadcastedEvent):void
		{
			trace("{Main} roomChange -> roomNumber = " + event.object.roomNumber);
		}
		
		private function pickupCollected(event:IBroadcastedEvent):void
		{
			trace("{Main} pickupCollected -> type = " + event.object.type);
		}
		
		private function heroSharingNodeWithEnemy(event:IBroadcastedEvent):void
		{
			trace("{Main} heroSharingNodeWithEnemy -> enemy = " + event.object.enemy);
		}
		
		// you can use this for adding damage or adding health (in the future, no health or damage yet). Also can create a safe zone from enemies.
		// use the setupWalkableList() method in the entity class, polymorph it. Look at the Hero class.
		private function heroWalkingOnNodeTypeOther(event:IBroadcastedEvent):void
		{
			var nodeType:uint = event.object.nodeType;
			//trace("{Main} heroWalkingOnNodeTypeOther -> type = " + nodeType);
			if (nodeType == 2 || nodeType == 3)
			{
				var enemyBase:Point;
				
				// label for the first loop, used for break
				toploop: 
				for (var i:int = 0; i < roomsManager.roomCurrent.roomNodeGridHeight; i++) 
				{
					for (var j:int = 0; j < roomsManager.roomCurrent.roomNodeGridWidth; j++) 
					{
						if (roomsManager.roomCurrent.roomWalkable[i][j] == 4)
						{
							enemyBase = new Point(j, i);
							break toploop;
						}
					}
					
				}
				
				if (enemyBase) 
				{
					isoMaker.hero.addEventListener( Entity.NEW_NODE, heroNewNode );
					isoMaker.enemiesSeekHero = false;
					isoMaker.enemyTargetNode = enemyBase;
				}
			}
		}
		
		private function heroNewNode(event:IBroadcastedEvent):void
		{
			var node:Point = event.object.node;
			//trace("{Main} heroNewNode -> node = " + event.object.node);
			var nodeWalkableType:uint = roomsManager.roomCurrent.roomWalkable[node.y][node.x];
			//trace("{Main} heroNewNode -> nodeWalkableType = " + nodeWalkableType);
			if (nodeWalkableType == 0)
			{
				//trace("{Main} heroNewNode -> reset enemies to seek hero");
				isoMaker.hero.removeEventListener( Entity.NEW_NODE, heroNewNode );
				isoMaker.enemiesSeekHero = true;
			}
		}
	}
}