﻿//A* pathfinding class for ActionScript 3.0//by Joe Hocking www.newarteest.com//adapted from http://www.policyalmanac.org/games/aStarTutorial.htm//use through PathFinder.go, not constructor//restructure to keep persistent level data in constructor and a public function to find path from provided start to finish?//can be optimized/adjusted further, details below//incidentally, level as 2D array (0 walkable, 1 obstacle)/*Contributed to by Dayvid Jones - www.dayvid.com*/package com.newarteest.path_finder
{	import flash.geom.Point;	import flash.utils.Dictionary;		public class PathFinder {		private var finX:Number;		private var finY:Number;		private var level:Array;		// added by Dayvid		private var walkableList:Vector.<uint>;		private var openList:Dictionary;		private var closedList:Dictionary;		public var path:Array;			//returns an array of points in the path; if it's imposssible to find a path, return empty 		public static function go(xIni:uint, yIni:uint, xFin:Number, yFin:Number, lvlData:Array, aWalkableList:Vector.<uint> = null):Array {			var finder:PathFinder = new PathFinder(xIni, yIni, xFin, yFin, lvlData, aWalkableList);			return finder.path;		}			//Constructor		public function PathFinder(xIni:uint, yIni:uint, xFin:Number, yFin:Number, lvlData:Array, aWalkableList:Vector.<uint> = null) {			finX = xFin;			finY = yFin;			level = lvlData;						// added by Dayvid			walkableList = aWalkableList;						openList = new Dictionary(true);			closedList = new Dictionary(true);			path = new Array();						//first node is the starting point			var node:PathNode = new PathNode(xIni, yIni, 0, 0, null);			openList[xIni + " " + yIni] = node;						this.SearchLevel();		}			//the pathfinding algorithm		private function SearchLevel():void {			var curNode:PathNode;			var lowF:Number = 100000;			var finished:Boolean = false;						//first determine node with lowest F			for each (var node:PathNode in openList) {				var curF:Number = node.g + node.h;								//currently this is just a brute force loop through every item in the list				//can be sped up using a sorted list or binary heap, described http://www.policyalmanac.org/games/binaryHeaps.htm				//example http://www.gotoandplay.it/_articles/2005/04/mazeChaser.php				if (lowF > curF) {					lowF = curF;					curNode = node;				}			}						//no path exists!			if (curNode == null) {return;}						//move selected node from open to closed list			delete openList[curNode.x + " " + curNode.y];			closedList[curNode.x + " " + curNode.y] = curNode;						var endNode:PathNode;			//check target			if (curNode.x == finX && curNode.y == finY) {				endNode = curNode;				finished = true;			}						// added by Dayvid			var walkable:Boolean = false;						//check each of the 8 adjacent squares			for (var i:int = -1; i < 2; i++) {				for (var j:int = -1; j < 2; j++) {					var col:Number = curNode.x + i;					var row:Number = curNode.y + j;										//make sure on the grid and not current node					if ((col >= 0 && col < level[0].length) && (row >= 0 && row < level.length) && (i != 0 || j != 0)) {												//if walkable, not on closed list, and not already on open list - add to open list						//adjust to no cutting corners, described http://www.policyalmanac.org/games/aStarTutorial.htm "Continuing the Search"						//example http://www.gotoandplay.it/_articles/2005/04/mazeChaser.php						//check G to open nodes, also described http://www.policyalmanac.org/games/aStarTutorial.htm "Continuing the Search"						walkable = isWalkable( level[row][col] );						if (walkable && closedList[col + " " + row] == null && openList[col + " " + row] == null) {														//determine g							var g:Number = 10;							if (i != 0 && j != 0) {								g = 14;							}														//calculate h							var h:Number = (Math.abs(col - finX)) + (Math.abs(row - finY)) * 10;														//create node							var found:PathNode = new PathNode(col, row, g, h, curNode);							openList[col + " " + row] = found;						}												// added by dayvid						// if the end node is not walkable, then stop the path at the node just before it.						else if (!walkable && row == finY && col == finX)						{							endNode = curNode;							finished = true;						}					}				}			}						//recurse if target not reached			if (finished == false) {				this.SearchLevel();			} else {				this.RetracePath(endNode);			}		}				// added by Dayvid		private function isWalkable(num:uint):Boolean		{			if (num == 0) return true;						if (walkableList) if (walkableList.indexOf(num) > -1) return true;						return false;		}				//construct an array of points by retracing searched nodes		private function RetracePath(node):void {			var step:Point = new Point(node.x, node.y);			path.push(step);						if (node.g > 0) {				this.RetracePath(node.parentNode);			}		}		//end of class	}}