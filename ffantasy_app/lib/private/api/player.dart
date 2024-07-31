class Player {
  final int playerNumber;
  final String playerID;
  final String playerName;
  final String jerseyNumber;
  final String position;
  final String age;
  double marketValue;
  String playerImage;
  final String teamName;

  Player({
    required this.playerNumber,
    required this.playerID,
    required this.playerName,
    required this.jerseyNumber,
    required this.position,
    required this.age,
    required this.marketValue,
    required this.playerImage,
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
        marketValue: 0,
        playerImage: '',
        teamName: teamName);
  }

  Player updatePlayerDetails({
    required double marketValue,
    required String playerImage,
  }) {
    return Player(
      playerNumber: playerNumber,
      playerID: playerID,
      playerName: playerName,
      jerseyNumber: jerseyNumber,
      position: position,
      age: age,
      marketValue: marketValue,
      playerImage: playerImage,
      teamName: teamName,
    );
  }

  @override
  String toString() {
    return 'Player { '
        'playerID: $playerID, '
        'playerName: $playerName, '
        // 'playerImage: $playerImage, '
        // 'marketValue: $marketValue, '
        'teamName: $teamName, '
        'position: $position, '
        'marketValue: $marketValue, '
        'playerImage: $playerImage, '
        'age:$age'
        '}';
  }
}
