package rooms
{
	import dorkbots.dorkbots_iso.room.IIsoRoomData;
	import dorkbots.dorkbots_iso.room.IsoRoomData;
	
	// this is one way of sharing common attributes with all room data objects for your game.
	public class ProjectAbstractRoomData extends IsoRoomData implements IIsoRoomData
	{
		final public function ProjectAbstractRoomData()
		{
			super();
			
			heroClass = Hero_MC;
			enemyClass = Enemy_MC;
			tileArtClass = TerrainTile_MC;
			tilePickupClass = PickupTile_MC;
		}
		
		override protected function setupTileArtWithHeight():void
		{
			_tileArtWithHeight = new Vector.<uint>();
			_tileArtWithHeight.push(1);
		}
	}
}