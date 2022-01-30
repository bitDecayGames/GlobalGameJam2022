package helpers;

import flixel.FlxG;
import flixel.util.FlxColor;

class PC {
	public var player:Map<Int, FlxColor>;
	public var ball:Map<Int, FlxColor>;
	public var slime:Map<Int, FlxColor>;

	public function new(player:Map<Int, FlxColor>, ball:Map<Int, FlxColor>, slime:Map<Int, FlxColor>) {
		this.player = player;
		this.ball = ball;
		this.slime = slime;
	}
}

class PlayerColors {
	public static final original:PC = new PC([], [68 => 0xffca30d0, 37 => 0xffe73dbc, 163 => 0xfff072b1], [81 => 0xffca30d0, 149 => 0xffe73dbc]);
	public static final green:PC = new PC([
		150 => 0xff13855e, // base
		184 => 0xff259d54, // base edge
		226 => 0xff31c753, // liquid
		240 => 0xffcafd97, // surface
		243 => 0xffd8fbb6, // highlight 1
		249 => 0xffe9fbc5, // highlight 2
	], [68 => 0xff259d54, 37 => 0xff31c753, 163 => 0xffd8fbb6],
		[81 => 0xff31c753, 149 => 0xff259d54]);
	public static final cyan:PC = new PC([
		150 => 0xff15809a, // base
		184 => 0xff16a9bb, // base edge
		226 => 0xff2afcfa, // liquid
		240 => 0xffa6ebde, // surface
		243 => 0xffd4f7f0, // highlight 1
		249 => 0xffeefdfa, // highlight 2
	], [68 => 0xff16a9bb, 37 => 0xff2afcfa, 163 => 0xffa6ebde],
		[81 => 0xff2afcfa, 149 => 0xff16a9bb]);
	public static final purple:PC = new PC([
		150 => 0xff5818a2, // base
		184 => 0xff5821b3, // base edge
		226 => 0xff5022d0, // liquid
		240 => 0xff5c43e0, // surface
		243 => 0xff8469b8, // highlight 1
		249 => 0xff9781c0, // highlight 2
	], [68 => 0xff5821b3, 37 => 0xff5022d0, 163 => 0xff5c43e0],
		[81 => 0xff5022d0, 149 => 0xff5821b3]);
	public static final yellow:PC = new PC([
		150 => 0xffbc8618, // base
		184 => 0xffecb212, // base edge
		226 => 0xfffeda6c, // liquid
		240 => 0xfffeed92, // surface
		243 => 0xfffaf3b5, // highlight 1
		249 => 0xfff9f6c4, // highlight 2
	], [68 => 0xffecb212, 37 => 0xfffeda6c, 163 => 0xfffeed92],
		[81 => 0xfffeda6c, 149 => 0xffecb212]);

	public static final all:Array<PC> = [original, green, cyan, purple, yellow];

	public static function shuffle() {
		FlxG.random.shuffle(all);
	}
}
