package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import dorkbots.dorkbots_broadcasters.IBroadcastedEvent;
	import dorkbots.dorkbots_iso.IIsoMaker;
	import dorkbots.dorkbots_iso.IsoMaker;
	import dorkbots.dorkbots_iso.entity.Entity;
	import dorkbots.dorkbots_iso.room.IIsoRoomsManager;
	import dorkbots.dorkbots_iso.room.IsoRoomsManager;
	
	import rooms.Room1Data;
	import rooms.Room2Data;
	import rooms.Room3Data;
	import rooms.Room4Data;
	
	[SWF(width='800', height='600', backgroundColor='#FFFFFF', frameRate='30')]
	public class Main extends Sprite
	{	
		private var isoMaker:IIsoMaker;
		
		public function Main()
		{
			var roomsManager:IIsoRoomsManager = new IsoRoomsManager();
			roomsManager.addRoom( Room1Data );
			roomsManager.addRoom( Room2Data );
			roomsManager.addRoom( Room3Data );
			roomsManager.addRoom( Room4Data );
			
			var isoContainer:Sprite = new Sprite();
			addChild(isoContainer);
			
			isoMaker = new IsoMaker( isoContainer, roomsManager );
			isoMaker.addEventListener( IsoMaker.ROOM_CHANGE, roomChange );
			isoMaker.addEventListener( IsoMaker.PICKUP_COLLECTED, pickupCollected );
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
		
		// you can use this for adding damage or adding health (in the future, no health or damage yet). Also can create a safe zone from enemies.
		// use the setupWalkableList() method in the entity class, polymorph it. Look at the Hero class.
		private function heroWalkingOnNodeTypeOther(event:IBroadcastedEvent):void
		{
			trace("{Main} heroWalkingOnNodeTypeOther -> type = " + event.object.nodeType);
		}
	}
}