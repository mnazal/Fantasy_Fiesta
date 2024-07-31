import 'dart:convert';
import 'dart:math';
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
  int homeScore = 0;
  int awayScore = 0;
  String status = "NS";
  List<String> sleeves = [
    "assets/sleeves/black.png",
    "assets/sleeves/arg.png",
  ];

  Future<List<Players>> fetchFantasyUserSquad() async {
    final url = Uri.parse(fantasySquadUri);
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "userName": userName,
      "matchID": int.parse(widget.match.matchID),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData1 = json.decode(response.body);

        return jsonData1
            .map((json) => Players.fromJson(json, json['teamName'].toString()))
            .toList();
      } else {
        //print('Failed to fetch data. Status Code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      //print('Error occurred: $e');
      return [];
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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 180,
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 34, 1, 90)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          status,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          awayScore.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
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
                child: FutureBuilder<List<Players>>(
                  future: fetchFantasyUserSquad(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No players found.'));
                    } else {
                      List<List<Players>> fantasySquad =
                          positionizeSquad(snapshot.data!);
                      return Column(
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
                                            "0",
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
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
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
