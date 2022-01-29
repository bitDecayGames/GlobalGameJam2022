package entities.physicsgroups;

using echo.FlxEcho;

class PhysicsCollisions {
	private static final BULLET_LETHAL_AGE:Float = 0.7;

	public var bullets:BulletsPhysicsGroup;
	public var terrain:TerrainPhysicsGroup;
	public var players:PlayerPhysicsGroup;

	public function new() {
		bullets = new BulletsPhysicsGroup();
		terrain = new TerrainPhysicsGroup();
		players = new PlayerPhysicsGroup();
	}

	public function init(players:Array<Player>, wall:Wall, floor:Floor) {
		for (player in players) {
			this.players.addPlayer(player);
		}
		terrain.addWall(wall);
		terrain.addFloor(floor);

		bullets.grp.listen(terrain.grp);

		// if bullet has not been alive for X seconds, don't collide with player
		// (so you don't shoot your own foot off)
		bullets.grp.listen(this.players.grp, {
			condition: (bullet, player, _) -> {
				return cast(bullet.get_object(), Bullet).age > BULLET_LETHAL_AGE;
			},
		});
	}
}
