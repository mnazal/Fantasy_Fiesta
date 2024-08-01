import 'dart:convert';
import 'package:ffantasy_app/data/players.dart';
import 'package:ffantasy_app/private/api/api.dart';
import 'package:ffantasy_app/private/api/match.dart';
import 'package:ffantasy_app/widgets/utils/match_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyTeam extends StatefulWidget {
  const MyTeam({super.key});

  @override
  State<MyTeam> createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  String userName = "nazal";

  Future<Map<String, dynamic>> fetchUserMatches() async {
    final Uri uri = Uri.parse("$usermatchUri$userName");

    final Uri uri2 = Uri.parse('$userDetailsUri$userName');
    try {
      final response = await http.get(uri);
      final response2 = await http.get(uri2);

      int pointsObtained = json.decode(response2.body)['totalPoints'];
      int matchesPlayed = json.decode(response2.body)['matchesPlayed'];

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        final List<Match> matches = jsonData
            .map((json) {
              try {
                final match = Match.fromJson(json);
                return match;
              } catch (e) {
                print('Error parsing Match JSON: $e');
                return null;
              }
            })
            .whereType<Match>()
            .toList();

        final Map<String, dynamic> returnData = {
          "matches": matches,
          "pointsObtained": pointsObtained,
          "matchesPlayed": matchesPlayed
        };
        return returnData;
      } else {
        throw Exception('Failed to load matches');
      }
    } catch (e) {
      print('Error fetching matches: $e');
      return {};
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserMatches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final userData = snapshot.data!;
            final matches = userData['matches'] as List<Match>;

            return Column(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 179, 173, 198),
                        ),
                        child: Image.network(
                          placeholderImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "John Doe",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Level 1",
                            style: TextStyle(
                              color: universalColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\t • \t",
                            style: TextStyle(
                              color: universalColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Elite Fantasy Enthusiast",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 57,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 231, 231, 231),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Points",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            Text(
                              userData['pointsObtained'].toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 45, 2, 119)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 58,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 231, 231, 231),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Games Played",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            Text(
                              userData['matchesPlayed'].toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 45, 2, 119)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 20, bottom: 10),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "\tUpcoming Matches",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: matches.length,
                      itemBuilder: (context, index) {
                        final match = matches[index];
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: MatchCard(match: match, type: 1),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
