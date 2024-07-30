class Match {
  final String matchNumber;
  final String matchID;
  final String homeTeamID;
  final String homeTeam;
  final String awayTeamID;
  final String awayTeam;
  final String time;
  final String location;

  Match(
      {required this.matchNumber,
      required this.matchID,
      required this.homeTeamID,
      required this.homeTeam,
      required this.awayTeamID,
      required this.awayTeam,
      required this.time,
      required this.location});

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      matchNumber: json['match_number'].toString(),
      matchID: json['matchId'].toString(),
      homeTeam: json['homeTeam'].toString(),
      homeTeamID: json['homeTeamId'].toString(),
      awayTeam: json['awayTeam'].toString(),
      awayTeamID: json['awayTeamId'].toString(),
      time: json['time'].toString(),
      location: json['location'].toString(),
    );
  }
}
