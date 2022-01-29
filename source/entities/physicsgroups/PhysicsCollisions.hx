package entities.physicsgroups;

import flixel.FlxSprite;
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

		bullets.grp.listen(terrain.grp, {
			enter: (bullet, terrain, c) -> {
				var bullet = cast(bullet.get_object(), Bullet);
				bullet.hit(cast(terrain.get_object(), FlxSprite), c);
			}
		});

		bullets.grp.listen(this.players.grp, {
			separate: false,
			exit: (bullet, player) -> {
				// bullets are only lethal once they are out of your flesh cannon
				cast(bullet.get_object(), Bullet).isLethal = true;
			},
			enter: (bullet, player, c) -> {
				var playerHit:Player = cast(player.get_object(), PlayerBodySprite).parent;
				var bulletHit:Bullet = cast(bullet.get_object());
				if (bulletHit.isLethal) {
					playerHit.shot(bulletHit);
				}
			}
		});

		// terrant bullets
		bullets.grp.listen(bullets.grp);
	}
}
