package ui;

import haxe.Timer;
import flixel.tweens.FlxEase;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import entities.Player;
import flixel.util.FlxAxes;
import flixel.FlxG;
import entities.GameData;
import flixel.FlxSprite;
import flixel.FlxSubState;

class PlayOverlay extends FlxSubState {
    public var data:GameData;

    var startup:FlxSprite;
    var p1Score:FlxText;
    var p1Ammo:Array<FlxSprite> = new Array<FlxSprite>();
    var p2Score:FlxText;
    var p2Ammo:Array<FlxSprite> = new Array<FlxSprite>();

    var pointAward:FlxText;

    var currentRoundText:FlxText;


	var varietyButton:FlxButton;
	var ammoButton:FlxButton;
	var windmillButton:FlxButton;
	var rapidModeButton:FlxButton;

    var gameStarted:Bool = false;

    var callback:Void->Void;

    public function new(callback:Void->Void) {
        super();

        this.callback = callback;
    }

    function CreateBulletSprite(x:Int, y:Int):FlxSprite {
        var bulletSprite = new FlxSprite();
        bulletSprite.loadGraphic(AssetPaths.slimeball__png, true, 80, 80);
		bulletSprite.scale.scale((15 * 2.0) / bulletSprite.width);
        bulletSprite.x = x;
        bulletSprite.y = y;
        
        if (!GameData.currentRound.unlimitedAmmo) {
            add(bulletSprite);
        }
        
        return bulletSprite;
    }

    function varietyMode(){
        GameData.gameMode = "random";
        FlxG.resetGame();
    }

    function ammoMode(){
        GameData.gameMode = "ammo";
        FlxG.resetGame();
    }

    function windmillMode(){
        GameData.gameMode = "windmill";
        FlxG.resetGame();
    }

    function rapidMode(){
        GameData.gameMode = "rapid";
        FlxG.resetGame();
    }

    override function create() {
        super.create();

        varietyButton = new FlxButton(FlxG.width/2 - 160, 22, "Random", varietyMode);
		add(varietyButton);
        ammoButton = new FlxButton(FlxG.width/2 - 80, 22, "Ammo", ammoMode);
		add(ammoButton);
        windmillButton = new FlxButton(FlxG.width/2, 22, "Windmill", windmillMode);
		add(windmillButton);
        rapidModeButton = new FlxButton(FlxG.width/2 + 80, 22, "Rapid", rapidMode);
		add(rapidModeButton);

        p1Score = new FlxText();
        p1Score.size = 45;
        p1Score.text = "" + GameData.p1Points;
        p1Score.x = 30;
        p1Score.y = 25;
        add(p1Score);


        p2Score = new FlxText();
        p2Score.size = 45;
        p2Score.text = "" + GameData.p2Points;
        p2Score.x = FlxG.width - 60;
        p2Score.y = 25;
        add(p2Score);

        reload();

        currentRoundText = new FlxText();
        currentRoundText.size = 30;
        currentRoundText.text = GameData.currentRound.displayText;
        currentRoundText.x = FlxG.width/2 - currentRoundText.width/2;
        currentRoundText.y = 45;
        add(currentRoundText);

        startup = new FlxSprite();
		startup.loadGraphic(AssetPaths.readysetgo__png, true, 869, 278);
		startup.animation.add("countdown", [0, 1, 2, 0], 1);
        startup.animation.play("countdown");
        startup.screenCenter(FlxAxes.XY);


        // Do this effect up front as the first frame doesn't seem to trigger it correctly
        FmodManager.PlaySoundOneShot(FmodSFX.AnnouncerReady);
        startup.animation.callback = (name:String, frameNum:Int, frameIndex:Int) -> {
            trace('name: ${name}, frame number: ${frameNum}, frame index: ${frameIndex}');
            // if (name == "countdown" && frameNum == 0) {
            //     FmodManager.PlaySoundOneShot(FmodSFX.AnnouncerReady);
            // }
            if (name == "countdown" && frameNum == 1) {
                FmodManager.PlaySoundOneShot(FmodSFX.AnnouncerSet);
            }
            if (name == "countdown" && frameNum == 2) {
                FmodManager.PlaySoundOneShot(FmodSFX.AnnouncerGo);
            }
            if (name == "countdown" && frameNum == 3) {
                gameStarted = true;
                callback();
                startup.kill();
            }
        };

        add(startup);

        pointAward = new FlxText("+1");
        pointAward.visible = false;
        add(pointAward);
    }

    public function subtractAmmoFromPlayer(player:Player){
        if (player.playerNum == 0){
            var ammoSprite = p1Ammo.pop();
            if (ammoSprite != null){
                ammoSprite.destroy();
            }
        } else if (player.playerNum == 1) {
            var ammoSprite = p2Ammo.pop();
            if (ammoSprite != null){
                ammoSprite.destroy();
            }
        }
    }

    public function reload() {
        for (i in 0...GameData.maxAmmo) {
            var spriteSpacingX = 25;
            var spriteDistanceFromTop = 20;
            p1Ammo.push(CreateBulletSprite(30 + spriteSpacingX * (i+1), spriteDistanceFromTop));
            p2Ammo.push(CreateBulletSprite((FlxG.width - 130) - (spriteSpacingX * i+1), spriteDistanceFromTop));
        }
    }

    public function declareWinner(player:Player) {
        // TODO: Use the real victory overlay
        // var winner = new FlxSprite();
        // winner.scrollFactor.set(0,0);
		// winner.loadGraphic(AssetPaths.readysetgo__png, true, 200, 200);
        // winner.animation.add("win", [2], 1, false);
        // winner.animation.play("win");
        // winner.screenCenter(FlxAxes.XY);
        // add(winner);

        // TODO: SFX Player "Num" WINS!

        pointAward.screenCenter();
        currentRoundText.size = 30;
        pointAward.visible = true;

        var target = FlxPoint.get();
        if (player.playerNum == 0) {
            target.copyFrom(p1Score.getPosition());
        } else {
            target.copyFrom(p2Score.getPosition());
        }

        pointAward.size = 64;
        FlxTween.tween(pointAward, {
            x: target.x,
            y: target.y,
            size: 30,
        }, 1, { ease: FlxEase.sineOut, onComplete: (t) -> {
            FmodManager.PlaySoundOneShot(FmodSFX.AnnouncerGo);
            pointAward.visible = false;
            p1Score.text = "" + GameData.p1Points;
            p2Score.text = "" + GameData.p2Points;

            Timer.delay(() -> {
                // TODO: Check if we have ultimate victory here to go to the final victory screen
                FlxG.resetState();
            }, 1500);
        }});
    }

    public function tieGame() {
        var tie = new FlxSprite();
        tie.scrollFactor.set(0,0);
		tie.loadGraphic(AssetPaths.readysetgo__png, true, 200, 200);
        tie.animation.add("tie", [1], 1, false);
        tie.animation.play("tie");
        tie.screenCenter(FlxAxes.XY);
        add(tie);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        _parentState.update(elapsed);
    }
}