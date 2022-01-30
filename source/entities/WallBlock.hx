package entities;

import haxe.Timer;
import echo.FlxEcho;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class WallBlock extends FlxSprite {
	public static final WALL_SPRITE_SIZE = 120;
	public static final WALL_HEIGHT:Int = 40;
	var stamper:FlxSprite;
	var stampQueued = false;
	var segmentsHigh:Int;
	var segmentDelay:Int;

	public function new(x:Float, y:Float, height:Int, constructionDelay:Int) {
		trace('making block at (${x}, ${y}) of height ${height}');
		super();
		segmentsHigh = height;
		// +1 for nice cadence
		segmentDelay = constructionDelay + 1;

		var rawSpriteHeight = height * WALL_SPRITE_SIZE;
		var physicsHeight = height * WALL_HEIGHT;

		// build our wall as a single sprite so that stamping effect looks nice
		makeGraphic(WALL_SPRITE_SIZE, rawSpriteHeight, FlxColor.TRANSPARENT, true);
		scale.set(.333, .333);

		FlxEcho.add_body(this, {
			x: x + WALL_HEIGHT / 2,
			y: y + physicsHeight / 2,
			shape: {
				type: RECT,
				width: WALL_HEIGHT,
				height: physicsHeight
			},
			mass: 0,
		});
	}

	override public function update(delta:Float) {
		super.update(delta);

		if (!stampQueued) {
			stampQueued = true;
			stamper = new FlxSprite(WALL_SPRITE_SIZE, WALL_SPRITE_SIZE, AssetPaths.walls__png);

			for (i in 0...segmentsHigh) {
				Timer.delay(() -> {
					// TODO: SFX Build wall block
					this.stamp(stamper, 0, Std.int(i * WALL_SPRITE_SIZE));
				}, (segmentDelay + segmentsHigh - i) * 200);
			}
		}
	}
}
