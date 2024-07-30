import 'dart:math';
import 'dart:math';
import 'package:ffantasy_app/constants/quotes.dart';
import 'package:ffantasy_app/data/matchlist.dart';
import 'package:ffantasy_app/widgets/utils/match_card.dart';
import 'package:ffantasy_app/widgets/navbar.dart';
import 'package:ffantasy_app/widgets/home/news_card.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class HomeQuote extends StatelessWidget {
  const HomeQuote({super.key});

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    final randomID = random.nextInt(footballQuotes.length);
    final footballer = footballQuotes[randomID];
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Container(
            height: 160,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.deepPurple),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 3),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'LET\'S GO !',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                            height: 1), // Add some space between the texts
                        Text(
                          footballer["quote"]!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                          softWrap: true,
                        ),
                        Text(
                          '- ' + footballer["name"]!,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 225, 222, 222),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                      width:
                          10), // Add some space between the text and the image
                  Image.asset(
                    footballer['image']!,
                    width: 150,
                    fit: BoxFit.fitWidth,
                    scale: sqrt1_2,
                  ),
                ],
              ),
            )));
  }
}
