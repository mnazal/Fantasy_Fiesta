import 'dart:convert';
import 'package:ffantasy_app/data/players.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ffantasy_app/private/api/api.dart';
import 'package:ffantasy_app/private/api/player.dart';
import 'package:ffantasy_app/private/api/match.dart';

class SquadPreview extends StatefulWidget {
  final String homeImage, awayImage;
  final Match match;
  const SquadPreview({
    super.key,
    required this.match,
    required this.homeImage,
    required this.awayImage,
  });

  @override
  State<SquadPreview> createState() => _SquadPreviewState();
}

class _SquadPreviewState extends State<SquadPreview> {
  String userName = 'nazal';
  List<String> sleeves = [
    "assets/sleeves/black.png",
    "assets/sleeves/arg.png",
  ];

  Future<Map<String, dynamic>> fetchFantasyUserSquad() async {
    final url = Uri.parse(fantasySquadUri);
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "userName": userName,
      "matchID": int.parse(widget.match.matchID),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);

        if (decodedJson != null) {
          final List<dynamic> jsonData1 = decodedJson['players'] ?? [];
          final int totalPoints = decodedJson['totalPoints'] ?? 0;
          final matchStatus = decodedJson['status'] ?? '';
          final List<dynamic> goalscorersData =
              decodedJson['goalScorers'] ?? [];

          List<Map<String, dynamic>> goalscorers =
              goalscorersData.cast<Map<String, dynamic>>();
          Map<String, dynamic> scores = decodedJson['scores'] ?? {};

          List<Players> players = jsonData1
              .map(
                  (json) => Players.fromJson(json, json['teamName'].toString()))
              .toList();

          Map<String, dynamic> returnData = {
            'players': players,
            'totalPoints': totalPoints,
            'status': matchStatus,
            'goalScorers': goalscorers,
            'scores': scores,
          };
          return returnData;
        } else {
          print('Error: Empty response body.');
          return {};
        }
      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Error occurred: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 34, 1, 90),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          'My Team',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchFantasyUserSquad(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No players found.'));
          } else {
            final fetchedData = snapshot.data!;
            List<List<Players>> fantasySquad =
                positionizeSquad(snapshot.data!['players']);

            final int fantasyPoints = fetchedData['totalPoints'];
            final int homeScore =
                fetchedData['scores'][widget.match.homeTeamID.toString] ?? 0;
            final int awayScore =
                fetchedData['scores'][widget.match.awayTeamID.toString] ?? 0;
            final String status = fetchedData['status'];

            final List<Map<String, dynamic>> goalscored =
                fetchedData['goalScorers'];

            return SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 34, 1, 90)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(children: [
                                Image.network(
                                  widget.homeImage,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      placeholderImage2,
                                      width: 45,
                                      height: 45,
                                    );
                                  },
                                  width: 45,
                                  height: 45,
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    widget.match.homeTeam,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 12),
                                  ),
                                ),
                              ]),
                              Text(
                                homeScore.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                status,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                awayScore.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              Column(children: [
                                Image.network(
                                  widget.awayImage,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      placeholderImage2,
                                      width: 45,
                                      height: 45,
                                    );
                                  },
                                  width: 45,
                                  height: 45,
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    widget.match.awayTeam,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 12),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 0,
                            ),
                            height: 80,
                            width: 85,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  fantasyPoints.toString(),
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 45, 2, 119)),
                                ),
                                Container(
                                  margin: EdgeInsets.all(0),
                                  width: double.infinity,
                                  color: universalColor,
                                  child: Text(
                                    'Total Points',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Color.fromARGB(255, 241, 241, 241)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/avatars/field.png'),
                            fit: BoxFit.fitHeight),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (int i = 0; i < squadPositions.length; i++)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                for (int j = 0; j < fantasySquad[i].length; j++)
                                  Container(
                                    width: 70,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          alignment: Alignment.topCenter,
                                          image: AssetImage(
                                            fantasySquad[i][j].teamName ==
                                                    widget.match.homeTeam
                                                ? sleeves[0]
                                                : sleeves[1],
                                          )),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2),
                                          margin: EdgeInsets.all(0),
                                          width: 80,
                                          color: Colors.white,
                                          child: Text(
                                            fantasySquad[i][j].playerName,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                height: 1.1,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          margin: EdgeInsets.all(0),
                                          width: 80,
                                          height: 14,
                                          color: const Color.fromARGB(
                                              255, 236, 236, 236),
                                          child: Text(
                                            fantasySquad[i][j]
                                                .fantasyPoints
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                              ],
                            )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

List<List<Players>> positionizeSquad(List<Players> players) {
  List<List<Players>> positionizedSquad =
      List.generate(squadPositions.length, (_) => []);
  for (Players player in players) {
    positionizedSquad[squadPositions.indexOf(player.position)].add(player);
  }
  return positionizedSquad;
}

List<String> squadPositions = ['G', 'D', 'M', 'F'];
