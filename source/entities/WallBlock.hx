package entities;

import flixel.FlxG;
import haxe.Timer;
import echo.FlxEcho;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class WallBlock extends FlxSprite {
	public static final WALL_SPRITE_SIZE = 120;
	public static final WALL_HEIGHT:Int = 120;
	public static final WALL_SCALE:Float = 1.0;

	var stamper:FlxSprite;
	var stampQueued = false;
	var segmentsHigh:Int;
	var segmentDelay:Int;

	var initialY:Float;

	public function new(x:Float, y:Float, height:Int, constructionDelay:Int) {
		trace('making block at (${x}, ${y}) of height ${height}');
		super();

		initialY = y;

		segmentsHigh = height;
		// +1 for nice cadence
		segmentDelay = constructionDelay + 1;

		var rawSpriteHeight = height * WALL_SPRITE_SIZE;
		var physicsHeight = height * WALL_HEIGHT;

		// build our wall as a single sprite so that stamping effect looks nice
		makeGraphic(WALL_SPRITE_SIZE, rawSpriteHeight, FlxColor.TRANSPARENT, true);
		scale.set(WALL_SCALE, WALL_SCALE);

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
					var boxPlaceId = FmodManager.PlaySoundWithReference(FmodSFX.BoxPlace);
					var percentageOnScreen = (initialY + (i * WALL_HEIGHT)) / FlxG.height;
					var modifier = 1 - percentageOnScreen;
					FmodManager.SetEventParameterOnSound(boxPlaceId, "Pitch", modifier);
					this.stamp(stamper, 0, Std.int(i * WALL_SPRITE_SIZE));
				}, (segmentDelay + segmentsHigh - i) * 150);
			}
		}
	}
}
