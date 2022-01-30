package entities;

import flixel.math.FlxRandom;

class CurrentRound {

    public var displayText:String = "Ammo Mode";
    public var unlimitedAmmo:Bool = false;
    public var spinningArms:Bool = false;

    
    public var randomNumberGenerator:FlxRandom = new FlxRandom();

    public function new (proposedGameMode:String){

        if (proposedGameMode == "variety"){
            var gameModeIndex = randomNumberGenerator.int(0, 2);
            switch (gameModeIndex) {
                case 0:
                    proposedGameMode = "windmill";
                case 1:
                    proposedGameMode = "rapid";
                case 2:
                    proposedGameMode = "ammo";
            }
        }

        if (proposedGameMode == "windmill"){
            displayText = "Windmill Mode";
            unlimitedAmmo = true;
            spinningArms = true;
        } else if (proposedGameMode == "rapid") {
            displayText = "Rapid Fire Mode";
            unlimitedAmmo = true;
        } else if (proposedGameMode == "ammo"){
            displayText = "Ammo Mode";
        }
    }
}