package entities;

import flixel.util.FlxTimer;
import entities.physicsgroups.BulletsPhysicsGroup;
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

	public function attemptReload(bulletGroup:BulletsPhysicsGroup):Bool {
		if (bulletGroup.bulletsAlive()) {
			return false;
		}

		var count:Int = 0;
		for (i in 0...magazines.length) {
			count = magazines[i].count();
			if (count > 0 || count < 0) {
				return false;
			}
		}
		
		FmodManager.PlaySoundOneShot(FmodSFX.PlayerReload);
		for (i in 0...magazines.length) {
			magazines[i].reload();
		}
		return true;
	}

	public function reset() {
		magazines = [];
	}
}
