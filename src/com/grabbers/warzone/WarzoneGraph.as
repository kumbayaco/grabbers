package com.grabbers.warzone
{
	import com.grabbers.log.Logger;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.display.DisplayObjectContainer;
	
	public class WarzoneGraph extends DisplayObjectContainer
	{
		protected var _nodes:Dictionary;
		
		public function WarzoneGraph() {
			super();
		}
		
		public function init(pathNodes:Dictionary):Boolean {
			_nodes = pathNodes;
			return true;
		}
				
		public function searchPath(from:uint, to:uint):Vector.<PathNode> {
//			trace(from + " ====> " + to);
			if (_nodes == null)
				return null;
			
			if (_nodes[to] == null) {
				Logger.error("unrecognized destination");
				return null;
			}
			
			if (_nodes[from] == null) {
				Logger.error("unrecognized source");
				return null;
			}
			
			var open:Vector.<GraphNode> = new Vector.<GraphNode>();
			var close:Vector.<GraphNode> = new Vector.<GraphNode>();
			var closex:Vector.<PathNode> = new Vector.<PathNode>();
			
			var nodeFrom:PathNode = _nodes[from] as PathNode;
			var nodeTo:PathNode = _nodes[to] as PathNode;
			
			var h:Number = calcHerustic(nodeFrom, nodeTo);
			var g:Number = 0;
			open.push(new GraphNode(null, nodeFrom, h, g));
			
			var lastNode:GraphNode = null;
			while (open.length > 0 && lastNode == null) {
				open.sort(function(n1:GraphNode, n2:GraphNode):Number {return n1.g + n1.h - n2.g - n2.h;});
				var fr:GraphNode = open.shift();
//				trace("@" + fr.node.id + "[" + (fr.g + fr.h) + "]");
				var cost:Number = fr.h + fr.g;
				var gStep:Number = 0;
				var arr:Array;
				
//				var openstr:String = "open:";
//				for each (var op:GraphNode in open) {
//					 openstr += op.node.id + ",";
//				}
//			
//				var closestr:String = "close:";
//				for each (var cl:GraphNode in close) 
//					closestr += cl.node.id + ",";
//					
//				trace(openstr);
//				trace(closestr);
				
				for each (var neigbor:uint in fr.node.neighbors) {
					var cur:PathNode = _nodes[neigbor] as PathNode;
					if (cur == nodeTo) {						
						lastNode = fr;
						break;
					}
					
					gStep = calcCost(fr.node, cur);
					h = calcHerustic(cur, nodeTo);						
					g = fr.g + gStep;
					
//					trace(" ->" + cur.id + "[" + (g + h) + "]");
					
					var gCur:GraphNode = findNode(cur, open);
					if (gCur != null) {
						if (h + g < cost) {
							gCur.parent = fr;
							fr.h = h + gStep;
						}
					} else if (closex.indexOf(cur) >= 0) {
						continue;
					} else {
						open.push(new GraphNode(fr, cur, h, g));
					}
				}
				
				closex.push(fr.node);
				close.push(fr);
			}
			
			if (lastNode == null) {
				Logger.error("path not found");
				return null;
			}
			
			var path:Vector.<PathNode> = new Vector.<PathNode>();
			path.push(nodeTo);
			var tNode:GraphNode = lastNode;
			while (tNode != null) {
				path.push(tNode.node);
				tNode = tNode.parent;
			}
			
			path = path.reverse();
//			var pathstr:String = "path: ";
//			for each (var o:PathNode in path)
//				pathstr += (o.id + ",");
//			trace(pathstr);
			return path;
		}
		
		protected function calcHerustic(ptFr:PathNode, ptTo:PathNode):Number {
			var val:Number = Math.sqrt(Math.pow(ptTo.x - ptFr.x, 2) + Math.pow(ptTo.y - ptFr.y, 2));
			return Math.round(val);
		}
		
		protected function calcCost(ptFr:PathNode, ptTo:PathNode):uint {
			var val:Number = Math.sqrt(Math.pow(ptTo.x - ptFr.x, 2) + Math.pow(ptTo.y - ptFr.y, 2));
			return Math.round(val);
		}
		
		protected function dictIsEmpty(dict:Dictionary):Boolean {
			if (dict == null)
				return true;
			for (var key:Object in dict)
				return false;
			return true;
		}
		
		protected function popNode(dict:Dictionary):GraphNode {
			if (dict == null)
				return null;
			for (var key:Object in dict) {
				var arr:Array = dict[key] as Array;
				var node:GraphNode = arr.shift() as GraphNode;
				if (arr.length == 0)
					delete dict[key];
				return node;
			}
			return null;
		}
		
		protected function findNode(node:PathNode, v:Vector.<GraphNode>):GraphNode {
			if (v == null || node == null)
				return null;
			
			for each (var gNode:GraphNode in v) {
				if (gNode.node == node)
					return gNode;
			}
			
			return null;
		}
	}
}
import com.grabbers.warzone.PathNode;

class GraphNode {
	public var h:Number = 0;
	public var g:Number = 0;
	public var node:PathNode;
	public var parent:GraphNode;
	public function GraphNode(p:GraphNode, n:PathNode, h:Number, g:Number):void {
		parent = p;
		this.h = h;
		this.g = g;
		node = n;
	}
}