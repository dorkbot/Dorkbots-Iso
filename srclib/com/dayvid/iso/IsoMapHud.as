package com.dayvid.iso
{
	import com.csharks.juwalbose.IsoHelper;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	public class IsoMapHud implements IIsoMapHud
	{
		public function IsoMapHud()
		{
		}
		
		public final function createLevel(levelData:Array):void
		{
			var tileType:uint;
			for (var i:uint = 0; i < levelData.length; i++)
			{
				for (var j:uint = 0; j < levelData[0].length; j++)
				{
					tileType = levelData[i][j];
					placeTile(tileType, i, j);
					if (tileType == 2)
					{
						levelData[i][j] = 0;
					}
				}
			}
			
			overlayContainer.addChild(heroPointer);
			overlayContainer.alpha = 0.5;
			overlayContainer.scaleX = overlayContainer.scaleY = 0.2;
			overlayContainer.y = 310;
			overlayContainer.x = 10;
			
			depthSort();
		}
		
		//place the tile based on coordinates
		private function placeTile(id:uint,i:uint,j:uint):void
		{
			var pos:Point=new Point();
			if (id == 2)
			{
				
				id = 0;
				pos.x = j * tileWidth;
				pos.y = i * tileWidth;
				pos = IsoHelper.twoDToIso(pos);
				hero.x = borderOffsetX + pos.x;
				hero.y = borderOffsetY + pos.y;
				
				heroCartPos.x = j * tileWidth;
				heroCartPos.y = i * tileWidth;
				heroTile.x=j;
				heroTile.y=i;
				
				// Map
				heroPointer=new herodot();
				heroPointer.x=heroCartPos.x;
				heroPointer.y=heroCartPos.y;
				
			}
			
			// TO DO
			// Create a map class that can be toggled on and off - clean up
			// it only needs heroCartPos
			// as its own createLevel, us only walkable level data
			
			// Map
			var tile:MovieClip=new cartTile();
			tile.gotoAndStop(id+1);
			tile.x = j * tileWidth;
			tile.y = i * tileWidth;
			overlayContainer.addChild(tile);
		}
		
		//the game loop
		private function loop():void
		{
			// TO DO
			// seperate methods for keyboard and click/touch
			if (key.isDown( Keyboard.UP ))
			{
				dY = -1;
			}
			else if (key.isDown( Keyboard.DOWN ))
			{
				dY = 1;
			}
			else
			{
				dY = 0;
			}
			if (key.isDown( Keyboard.RIGHT ))
			{
				dX = 1;
				if (dY == 0)
				{
					facing = "east";
				}
				else if (dY == 1)
				{
					facing = "southeast";
					dX = dY = 0.5;
				}
				else
				{
					facing = "northeast";
					dX = 0.5;
					dY =- 0.5;
				}
			}
			else if (key.isDown( Keyboard.LEFT ))
			{
				dX = -1;
				if (dY == 0)
				{
					facing = "west";
				}
				else if (dY == 1)
				{
					facing = "southwest";
					dY = 0.5;
					dX =- 0.5;
				}
				else
				{
					facing = "northwest";
					dX = dY =- 0.5;
				}
			}
			else
			{
				dX = 0;
				if (dY == 0)
				{
					//facing="west";
				}
				else if (dY == 1)
				{
					facing = "south";
				}
				else
				{
					facing = "north";
				}
			}
			if (dY == 0 && dX == 0)
			{
				hero.clip.gotoAndStop(facing);
				idle = true;
			}
			else if (idle || currentFacing != facing)
			{
				idle = false;
				currentFacing = facing;
				hero.clip.gotoAndPlay(facing);
			}
			if (! idle && isWalkable())
			{
				heroCartPos.x +=  speed * dX;
				heroCartPos.y +=  speed * dY;
				
				cornerPoint.x -=  speed * dX;
				cornerPoint.y -=  speed * dY;
				
				// Map
				heroPointer.x = heroCartPos.x;
				heroPointer.y = heroCartPos.y;
				
				var newPos:Point = IsoHelper.twoDToIso(heroCartPos);
				heroTile = IsoHelper.getNodeCoordinates(heroCartPos, tileWidth);
				depthSort();
				//trace(heroTile);
			}
			//tileTxt.text="Hero is on x: "+heroTile.x +" & y: "+heroTile.y;
		}
	}
}