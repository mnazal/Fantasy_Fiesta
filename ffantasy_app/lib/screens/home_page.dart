import 'dart:math';
import 'package:ffantasy_app/private/api/api.dart';
import 'package:ffantasy_app/widgets/home/news_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ffantasy_app/widgets/utils/match_card.dart';
import 'package:ffantasy_app/widgets/navbar.dart';
import 'package:ffantasy_app/widgets/home/home_quote.dart';
import 'package:ffantasy_app/constants/quotes.dart';
import 'package:ffantasy_app/private/api/match.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _showAllMatches = false; // Track whether to show all matches or not

  Future<List<Match>> fetchMatches() async {
    final Uri uri = Uri.parse(matchListUri);
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Match.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load matches');
      }
    } catch (e) {
      print('Error fetching matches: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    final randomID = random.nextInt(footballQuotes.length);
    final footballer = footballQuotes[randomID];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 5,
        leading: const Icon(
          Icons.notifications,
          color: Colors.black,
        ),
        title: const Text(
          'fútbol',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 23,
            letterSpacing: 0.7,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2.5),
                ),
                child: Image.asset(
                  'assets/avatars/cr.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: FantasyNavBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const HomeQuote(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "\tUpcoming Matches",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showAllMatches = !_showAllMatches;
                        });
                      },
                      child: Text(_showAllMatches ? "Show Less" : "Show More"),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                FutureBuilder<List<Match>>(
                  future: fetchMatches(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No matches found'));
                    } else {
                      final matches = snapshot.data!;
                      final displayedMatches =
                          _showAllMatches ? matches : matches.take(2).toList();
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: displayedMatches.length,
                        itemBuilder: (context, index) {
                          final match = displayedMatches[index];
                          return MatchCard(
                            awayTeam: match.awayTeam,
                            homeTeam: match.homeTeam,
                            time: match.time,
                            matchID: match.matchID,
                            awayTeamID: match.awayTeamID,
                            homeTeamID: match.homeTeamID,
                          );
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: 5),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "\tLatest News",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const NewsCard(),
                    const NewsCard(),
                    const NewsCard(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
