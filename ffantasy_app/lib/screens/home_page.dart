import 'dart:math';
import 'package:ffantasy_app/constants/quotes.dart';
import 'package:ffantasy_app/data/matchlist.dart';
import 'package:ffantasy_app/widgets/home/home_quote.dart';
import 'package:ffantasy_app/widgets/utils/match_card.dart';
import 'package:ffantasy_app/widgets/navbar.dart';
import 'package:ffantasy_app/widgets/home/news_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Handle navigation based on the selected index
    // For example, navigate to different screens based on the index
  }

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    final randomID = random.nextInt(footballQuotes.length);
    final footballer = footballQuotes[randomID];

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
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
        onItemSelected: _onItemTapped,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                HomeQuote(),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "\tUpcoming Matches",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                for (int index = 0; index < 2; index++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: MatchCard(
                      homeTeam: matchDetailsList[index]['homeTeam']!,
                      awayTeam: matchDetailsList[index]['awayTeam']!,
                    ),
                  ),
                SizedBox(
                  height: 5,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "\tLatest News",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    NewsCard(),
                    NewsCard(),
                    NewsCard(),
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
