package dorkbots.dorkbots_iso.entity
{
	public class Enemy extends Entity implements IEnemy
	{
		public function Enemy()
		{
			super();
		}
		
		// Don't need to add 0. This tells the pathfinder to count other numbers as walkable besides 0.
		// use this when you want the Enemy to walk on nodes that activate other behaviors, such as lava causing damage.
		// override this method in your projects Enemy Class to remove or add walkable node types.
		override protected function setupWalkableList():void
		{
			walkableList = new Vector.<uint>();
			walkableList.push(4);
		}
		
		override protected function getWalkable():Array
		{
			return roomData.enemiesWalkable;
		}
	}
}