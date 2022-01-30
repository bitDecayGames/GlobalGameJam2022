package entities;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import echo.FlxEcho;

class BulletMagazineManager {
	public static final instance = new BulletMagazineManager();

	private var magazines:Array<BulletMagazine>;

	public function new() {
		reset();
	}

	public function add(magazine:BulletMagazine) {
		magazines.push(magazine);
	}

	public function attemptReload():Bool {
		var count:Int = 0;
		for (i in 0...magazines.length) {
			count = magazines[i].count();
			if (count > 0 || count < 0) {
				return false;
			}
		}
		for (i in 0...magazines.length) {
			magazines[i].reload();
		}
		return true;
	}

	public function reset() {
		magazines = [];
	}
}
