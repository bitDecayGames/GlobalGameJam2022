package entities;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class WallBlock extends FlxSprite {
	public static final WALL_HEIGHT:Int = 40;

	public function new() {
		super();
		makeGraphic(WALL_HEIGHT, WALL_HEIGHT, FlxColor.BROWN);
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
