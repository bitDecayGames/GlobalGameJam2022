package entities;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import echo.FlxEcho;

class BulletMagazineManager {
	public static var instance = new BulletMagazineManager();

	private var magazines:Array<BulletMagazine>;

	public function new() {
		magazines = [];
	}

	public function add(magazine:BulletMagazine) {
		magazines.push(magazine);
	}

	public function canReload():Bool {
		for (i in 0...magazines.length) {
			if (magazines[i].count() > 0) {
				return false;
			}
		}
		return true;
	}
}
