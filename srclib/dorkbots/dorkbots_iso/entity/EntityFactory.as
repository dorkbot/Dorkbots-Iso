package dorkbots.dorkbots_iso.entity
{
	public class EntityFactory implements IEntityFactory
	{
		public function EntityFactory()
		{
		}
		
		public final function createHero():IHero
		{
			return _createHero();
		}
		
		protected function _createHero():IHero
		{
			return new Hero();
		}
		
		public final function createEnemy(type:uint):IEnemy
		{
			return _createEnemy(type);
		}
		
		protected function _createEnemy(type:uint):IEnemy
		{
			return new Enemy();
		}
		
		public function dispose():void
		{
			
		}
	}
}