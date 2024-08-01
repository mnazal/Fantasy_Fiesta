import 'dart:convert';
import 'dart:math';

import 'package:ffantasy_app/constants/quotes.dart';
import 'package:ffantasy_app/private/api/api.dart';
import 'package:ffantasy_app/widgets/home/home_quote.dart';
import 'package:ffantasy_app/widgets/home/news_card.dart';
import 'package:ffantasy_app/widgets/utils/match_card.dart';
import 'package:flutter/material.dart';
import 'package:ffantasy_app/private/api/match.dart';
import 'package:http/http.dart' as http;

class HomePageIteams extends StatefulWidget {
  const HomePageIteams({super.key});

  @override
  State<HomePageIteams> createState() => _HomePageIteamsState();
}

class _HomePageIteamsState extends State<HomePageIteams> {
  bool _showAllMatches = false;
  @override
  Widget build(BuildContext context) {
    Random random = Random();
    final randomID = random.nextInt(footballQuotes.length);
    final footballer = footballQuotes[randomID];

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

    return SingleChildScrollView(
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
                    final displayedMatches = _showAllMatches
                        ? matches.take(4).toList()
                        : matches.take(2).toList();
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: displayedMatches.length,
                      itemBuilder: (context, index) {
                        final match = displayedMatches[index];
                        return MatchCard(
                          match: match,
                          type: 0,
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
                children: const [
                  NewsCard(
                    newsHeading:
                        'Argentina Wins the 2022 World Cup, Defeating France',
                    image: 'assets/avatars/ARG.jpg',
                  ),
                  NewsCard(
                      newsHeading:
                          'Real Madrid wins the Champions League for the 15th time',
                      image: 'assets/avatars/zz.png'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
