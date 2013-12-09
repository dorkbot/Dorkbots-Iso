package entities
{
	import dorkbots.dorkbots_iso.entity.Enemy;
	import dorkbots.dorkbots_iso.entity.IEnemy;
	
	public class EnemyDorkbot extends Enemy implements IEnemy
	{
		public function EnemyDorkbot()
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
	}
}