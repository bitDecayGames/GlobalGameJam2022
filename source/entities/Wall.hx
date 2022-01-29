package entities;

import flixel.math.FlxRandom;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Wall extends FlxTypedSpriteGroup<WallBlock> {
	public function new(x:Int, y:Int) {
		super(x, y);
	}

	public function buildWallBlocks(height:Int, holes:Int):Wall {
		var _holes = new Array<Int>();
		var rnd = new FlxRandom();
		if (holes > 0) {
			for (i in 0...holes) {
				_holes.push(rnd.int(0, height - 1));
			}
		}
		if (height > 0) {
			for (i in 0...height) {
				var isHole = false;
				if (holes > 0) {
					for (k in _holes) {
						if (i + 1 == k || i - 1 == k || i == k) {
							isHole = true;
							break;
						}
					}
				}
				if (!isHole) {
					var block = new WallBlock();
					block.x = x;
					block.y = y + i * WallBlock.WALL_HEIGHT;
					add(block);
				}
			}
		}
		return this;
	}
}
