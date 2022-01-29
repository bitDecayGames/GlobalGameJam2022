package entities.physicsgroups;

import flixel.group.FlxGroup;

using echo.FlxEcho;

class TerrainPhysicsGroup {
	public var grp = new FlxGroup();

	public function new() {}

	public function addWall(w:Wall) {
		for (member in w.members) {
			member.add_to_group(grp);
		}
	}

	public function addFloor(f:Floor) {
		f.add_to_group(grp);
	}
}
