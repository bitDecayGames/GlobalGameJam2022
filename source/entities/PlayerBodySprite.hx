package entities;

import flixel.FlxSprite;

class PlayerBodySprite extends FlxSprite {
	public var parent:Player;

	public function new(p:Player) {
		super();
		parent = p;
	}
}
