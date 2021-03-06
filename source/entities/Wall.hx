package entities;

import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Wall extends FlxTypedSpriteGroup<WallBlock> {
	private static final HEIGHT:Int = 15;
	private static final HOLES:Int = 3;
	private static final BIAS:Float = 5.0;

	public function new(x:Float, y:Float) {
		super(x, y);
	}

	// bias is a strength to move holes in the wall up`ward. The higher the number, the higher the holes will be
	public function buildWallBlocks():Wall {
		var height:Int = HEIGHT;
		var holes:Int = HOLES;
		var bias:Float = BIAS;
		trace('constructing wall with height ${height} and ${holes} holes');
		if (height > 0) {
			var _holes = new Array<Int>();

			for (i in 0...holes) {
				var upwardBias = Std.int(FlxG.random.float() * bias);
				_holes.push(FlxG.random.int(0, height - 1) + upwardBias);
			}
			_holes.sort((a:Int, b:Int) -> {
				// sort these so the smallest elements are at the end so we can pop() them off nicely
				return b - a;
			});
			trace('sorted holes: ${_holes}');
			var i:Int = 0;
			var segmentCounter = 0;
			while (i < height) {
				var startY = FlxG.height - i * WallBlock.WALL_HEIGHT;
				var segmentHeight = _holes.pop() - i;
				i = i + segmentHeight + 1;

				if (segmentHeight <= 0) {
					continue;
				}

				trace('making wall segment at ${startY} with height ${segmentHeight}');

				// update our next i to be height + 1 for our next wall segment

				var gfx = new WallBlock(x - WallBlock.WALL_HEIGHT * .5, startY - segmentHeight * WallBlock.WALL_HEIGHT, segmentHeight, segmentCounter);
				add(gfx);

				// Track how many blocks we've made
				segmentCounter += segmentHeight;
			}
		}
		return this;
	}
}
