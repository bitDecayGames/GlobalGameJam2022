package entities;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class PowerMeterFrame extends FlxSprite {
	public function new(x:Float, y:Float) {
		super(x, y);
		makeGraphic(1, 1, FlxColor.BLUE);
		origin.set(0, 0);
	}
}
