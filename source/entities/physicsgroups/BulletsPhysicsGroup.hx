package entities.physicsgroups;

import flixel.group.FlxGroup;

using echo.FlxEcho;

class BulletsPhysicsGroup {
	public var grp = new FlxGroup();

	public function new() {}

	public function addBullet(b:Bullet) {
		b.add_to_group(grp);
	}

	public function bulletsAlive():Bool {
		// TODO: probably should clean dead bullets out of this list/group
		for (b in grp) {
			if (b.alive) {
				return true;
			}
		}
		return false;
	}
}
