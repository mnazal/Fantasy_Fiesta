class Player {
  final int playerNumber;
  final String playerID;
  final String playerName;
  final String jerseyNumber;
  final String position;
  final String age;
  // final String marketValue;
  // final String playerImage;
  final String teamName;

  Player({
    required this.playerNumber,
    required this.playerID,
    required this.playerName,
    required this.jerseyNumber,
    required this.position,
    required this.age,
    // required this.marketValue,
    // required this.playerImage,
    required this.teamName,
  });

  factory Player.fromJson(Map<String, dynamic> json, String teamName) {
    return Player(
        playerNumber: json['player_number'],
        playerID: json['playerid'].toString(),
        playerName: json['playerName'].toString(),
        jerseyNumber: json['jerseyNumber'].toString(),
        position: json['position'].toString(),
        age: json['age'].toString(),
        // marketValue: json['marketValue'].toString(),
        // playerImage: json['playerImage'].toString(),
        teamName: teamName);
  }

  String toString() {
    return 'Player { '
        'playerID: $playerID, '
        'playerName: $playerName, '
        // 'playerImage: $playerImage, '
        // 'marketValue: $marketValue, '
        'teamName: $teamName, '
        'position: $position '
        '}';
  }
}
