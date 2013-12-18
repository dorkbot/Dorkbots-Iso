/*
* Author: Dayvid jones
* http://www.dayvid.com
* Copyright (c) Disco Blimp 2013
* http://www.discoblimp.com
* Version: 1.0.3
* 
* Licence Agreement
*
* You may distribute and modify this class freely, provided that you leave this header intact,
* and add appropriate headers to indicate your changes. Credit is appreciated in applications
* that use this code, but is not required.
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/
package dorkbots.dorkbots_util {	import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;		public class RemoveDisplayObjects 	{		public function RemoveDisplayObjects():void 		{					}				public static function removeAllDisplayObjects(aDisObject:DisplayObjectContainer):void 		{			if (aDisObject != null) 			{				while (aDisObject.numChildren > 0) 				{					aDisObject.removeChildAt(0);				}			}		}				public static function removeDisplayObject(aDisplayObject:DisplayObjectContainer, aChild:DisplayObject):void 		{			if (aDisplayObject != null && aChild != null) 			{				var aDisplayObjectNumChildren:uint = aDisplayObject.numChildren;				var i:uint = 0;				for (i; i < aDisplayObjectNumChildren; i++) 				{					if (aDisplayObject.getChildAt(i) == aChild) 					{						aDisplayObject.removeChild(aChild);						break;					}				}			}		}				public static function removeDisplayObjectsInArray(aObject:*):void 		{			try			{				var aObjectLength:uint = aObject.length;			}			catch (error:Error)			{				throw new Error("The parameter is not an array. This method's parameter can only be an Array or a Indexed Array (Vector)");			}						if (aObjectLength > 0)			{				var i:uint = 0;				for (i; i < aObjectLength; i++) 				{					try					{						var this_mc:DisplayObject = aObject[i];					}					catch (error:Error)					{						throw new Error("The object in the array is not a DisplayObject!!!!! Only pass arrays that contain display objects.");					}										if (this_mc.parent != null) 					{						this_mc.parent.removeChild(this_mc);					}				}			}		}	}}