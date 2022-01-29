package entities.physicsgroups;

import flixel.group.FlxGroup;

using echo.FlxEcho;

class PlayerPhysicsGroup {
	public var grp = new FlxGroup();

	public function new() {}

	public function addPlayer(p:Player) {
		p.body.add_to_group(grp);
	}
}
