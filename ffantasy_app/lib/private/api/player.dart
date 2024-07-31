class Player {
  final String playerID;
  final String playerName;
  final String position;
  final String age;
  double marketValue;
  String playerImage;
  final String teamName;

  Player({
    required this.playerID,
    required this.playerName,
    required this.position,
    required this.age,
    required this.marketValue,
    required this.playerImage,
    required this.teamName,
  });

  factory Player.fromJson(Map<String, dynamic> json, String teamName) {
    return Player(
        playerID: json['playerid'].toString(),
        playerName: json['playerName'].toString(),
        position: json['position'].toString(),
        age: json['age'].toString(),
        marketValue: (json['marketValue']) ?? 0.0,
        playerImage: json['playerImage'] ?? "",
        teamName: teamName);
  }

  Player updatePlayerDetails({
    required double marketValue,
    required String playerImage,
  }) {
    return Player(
      playerID: playerID,
      playerName: playerName,
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

class Players {
  final String playerID;
  final String playerName;
  final String position;
  final String age;
  double marketValue;
  String playerImage;
  final String teamName;

  Players({
    required this.playerID,
    required this.playerName,
    required this.position,
    required this.age,
    required this.marketValue,
    required this.playerImage,
    required this.teamName,
  });

  factory Players.fromJson(Map<String, dynamic> json, String teamName) {
    return Players(
        playerID: json['playerid'].toString(),
        playerName: json['playerName'].toString(),
        position: json['position'].toString(),
        age: json['age'].toString(),
        marketValue: (json['marketValue']).toDouble() ?? 0.0,
        playerImage: json['playerImage'] ?? "",
        teamName: teamName);
  }

  Players updatePlayerDetails({
    required double marketValue,
    required String playerImage,
  }) {
    return Players(
      playerID: playerID,
      playerName: playerName,
      position: position,
      age: age,
      marketValue: marketValue,
      playerImage: playerImage,
      teamName: teamName,
    );
  }

  @override
  String toString() {
    return 'Players { '
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
