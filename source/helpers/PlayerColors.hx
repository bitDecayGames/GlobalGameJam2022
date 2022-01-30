package helpers;

import flixel.FlxG;
import flixel.util.FlxColor;

class PlayerColors {
	public static final original:Map<Int, FlxColor> = [];
	public static final green:Map<Int, FlxColor> = [
		150 => 0xff13855e, // base
		184 => 0xff259d54, // base edge
		226 => 0xff31c753, // liquid
		240 => 0xffcafd97, // surface
		243 => 0xffd8fbb6, // highlight 1
		249 => 0xffe9fbc5, // highlight 2
	];
	public static final cyan:Map<Int, FlxColor> = [
		150 => 0xff15809a, // base
		184 => 0xff16a9bb, // base edge
		226 => 0xff2afcfa, // liquid
		240 => 0xffa6ebde, // surface
		243 => 0xffd4f7f0, // highlight 1
		249 => 0xffeefdfa, // highlight 2
	];
	public static final purple:Map<Int, FlxColor> = [
		150 => 0xff5818a2, // base
		184 => 0xff5821b3, // base edge
		226 => 0xff5022d0, // liquid
		240 => 0xff5c43e0, // surface
		243 => 0xff8469b8, // highlight 1
		249 => 0xff9781c0, // highlight 2
	];
	public static final yellow:Map<Int, FlxColor> = [
		150 => 0xffbc8618, // base
		184 => 0xffecb212, // base edge
		226 => 0xfffeda6c, // liquid
		240 => 0xfffeed92, // surface
		243 => 0xfffaf3b5, // highlight 1
		249 => 0xfff9f6c4, // highlight 2
	];

	public static final all:Array<Map<Int, FlxColor>> = [original, green, cyan, purple, yellow];

	public static function shuffle() {
		FlxG.random.shuffle(all);
	}
}
