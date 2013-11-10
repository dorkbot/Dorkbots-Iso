﻿//A* pathfinding class for ActionScript 3.0//by Joe Hocking www.newarteest.com//adapted from http://www.policyalmanac.org/games/aStarTutorial.htm//use through PathFinder.go, not constructor//restructure to keep persistent level data in constructor and a public function to find path from provided start to finish?//can be optimized/adjusted further, details below//incidentally, level as 2D array (0 walkable, 1 obstacle)package com.newarteest.path_finder
{	import flash.utils.Dictionary;	import flash.geom.Point;		public class PathFinder {		private var finX;		private var finY;		private var level:Array;		private var openList:Dictionary;		private var closedList:Dictionary;		public var path:Array;			//returns an array of points in the path; if it's imposssible to find a path, return empty 		public static function go(xIni, yIni, xFin, yFin, lvlData):Array {			var finder:PathFinder = new PathFinder(xIni, yIni, xFin, yFin, lvlData);			return finder.path;		}			//Constructor		public function PathFinder(xIni, yIni, xFin, yFin, lvlData) {			finX = xFin;			finY = yFin;			level = lvlData;			openList = new Dictionary(true);			closedList = new Dictionary(true);			path = new Array();						//first node is the starting point			var node:PathNode = new PathNode(xIni, yIni, 0, 0, null);			openList[xIni + " " + yIni] = node;						this.SearchLevel();		}			//the pathfinding algorithm		private function SearchLevel():void {			var curNode:PathNode;			var lowF = 100000;			var finished:Boolean = false;						//first determine node with lowest F			for each (var node in openList) {				var curF = node.g + node.h;								//currently this is just a brute force loop through every item in the list				//can be sped up using a sorted list or binary heap, described http://www.policyalmanac.org/games/binaryHeaps.htm				//example http://www.gotoandplay.it/_articles/2005/04/mazeChaser.php				if (lowF > curF) {					lowF = curF;					curNode = node;				}			}						//no path exists!			if (curNode == null) {return;}						//move selected node from open to closed list			delete openList[curNode.x + " " + curNode.y];			closedList[curNode.x + " " + curNode.y] = curNode;						//check target			if (curNode.x == finX && curNode.y == finY) {				var endNode:PathNode = curNode;				finished = true;			}						//check each of the 8 adjacent squares			for (var i = -1; i < 2; i++) {				for (var j = -1; j < 2; j++) {					var col = curNode.x + i;					var row = curNode.y + j;										//make sure on the grid and not current node					if ((col >= 0 && col < level[0].length) && (row >= 0 && row < level.length) && (i != 0 || j != 0)) {												//if walkable, not on closed list, and not already on open list - add to open list						//adjust to no cutting corners, described http://www.policyalmanac.org/games/aStarTutorial.htm "Continuing the Search"						//example http://www.gotoandplay.it/_articles/2005/04/mazeChaser.php						//check G to open nodes, also described http://www.policyalmanac.org/games/aStarTutorial.htm "Continuing the Search"						if (level[row][col] == 0 && closedList[col + " " + row] == null && openList[col + " " + row] == null) {														//determine g							var g = 10;							if (i != 0 && j != 0) {								g = 14;							}														//calculate h							var h = (Math.abs(col - finX)) + (Math.abs(row - finY)) * 10;														//create node							var found:PathNode = new PathNode(col, row, g, h, curNode);							openList[col + " " + row] = found;						}					}				}			}						//recurse if target not reached			if (finished == false) {				this.SearchLevel();			} else {				this.RetracePath(endNode);			}	}			//construct an array of points by retracing searched nodes		private function RetracePath(node):void {			var step:Point = new Point(node.x, node.y);			path.push(step);						if (node.g > 0) {				this.RetracePath(node.parentNode);			}		}		//end of class	}}