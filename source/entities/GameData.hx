package entities;

class GameData {
    public static var maxAmmo = 5;

    public static var p1Points:Int = 0;
    public static var p2Points:Int = 0;

    function resetScores() {
        p1Points = 0;
        p2Points = 0;
    }
}