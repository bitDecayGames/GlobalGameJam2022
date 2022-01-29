package entities;

import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Wall extends FlxTypedSpriteGroup<WallBlock> {
	public function new(x:Float, y:Float) {
		super(x, y);
	}

	public function buildWallBlocks(height:Int, holes:Int):Wall {
		trace('constructing wall with height ${height} and ${holes} holes');
		if (height > 0) {
			var _holes = new Array<Int>();

			for (i in 0...holes) {
				_holes.push(FlxG.random.int(0, height - 1));
			}
			_holes.sort( (a:Int, b:Int) -> {
				// sort these so the smallest elements are at the end so we can pop() them off nicely
				return b - a;
			});
			trace('sorted holes: ${_holes}');
			var i:Int = 0;
			while (i < height) {
				var startY = FlxG.height - i * WallBlock.WALL_HEIGHT;
				var segmentHeight = _holes.pop() - i;
				i = i + segmentHeight + 1;

				if (segmentHeight <= 0) {
					continue;
				}

				trace('making wall segment at ${startY} with height ${segmentHeight}');

				// update our next i to be height + 1 for our next wall segment

				var gfx = new WallBlock(x, startY - segmentHeight * WallBlock.WALL_HEIGHT, segmentHeight);
				add(gfx);
			}
		}
		return this;
	}
}
