package
{
	import dorkbots.dorkbots_iso.IIsoMaker;
	import dorkbots.dorkbots_iso.IIsoRoomsManager;
	import dorkbots.dorkbots_iso.IsoEvents;
	import dorkbots.dorkbots_iso.IsoMaker;
	import dorkbots.dorkbots_iso.IsoRoomsManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import dorkbots.dorkbots_broadcasters.IBroadcastedEvent;
	
	import rooms.Room0Data;
	import rooms.Room1Data;
	import rooms.Room2Data;
	import rooms.Room3Data;
	
	[SWF(width='800', height='600', backgroundColor='#FFFFFF', frameRate='30')]
	public class Main extends Sprite
	{	
		private var isoMaker:IIsoMaker;
		
		public function Main()
		{
			var roomsManager:IIsoRoomsManager = new IsoRoomsManager();
			roomsManager.addRoom( Room0Data );
			roomsManager.addRoom( Room1Data );
			roomsManager.addRoom( Room2Data );
			roomsManager.addRoom( Room3Data );
			
			var isoContainer:Sprite = new Sprite();
			addChild(isoContainer);
			
			isoMaker = new IsoMaker( isoContainer, roomsManager );
			isoMaker.addEventListener( IsoEvents.ROOM_CHANGE, roomChange );
			isoMaker.addEventListener( IsoEvents.PICKUP_COLLECTED, pickupCollected );
			isoMaker.createLevel();
			
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function loop(event:Event):void
		{
			isoMaker.loop();
		}
		
		private function roomChange(event:IBroadcastedEvent):void
		{
			trace("{Main} roomChange");
		}
		
		private function pickupCollected(event:IBroadcastedEvent):void
		{
			trace("{Main} pickupCollected -> type = " + event.object.type);
			
			
		}
	}
}