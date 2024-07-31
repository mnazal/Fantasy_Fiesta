// ignore_for_file: unused_import

import 'dart:convert';
import 'package:ffantasy_app/private/api/api.dart';
import 'package:ffantasy_app/private/api/player.dart';

import 'package:ffantasy_app/private/api/match.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> submitSquad(BuildContext context, List<List<Player>> squad,
    String teamName, String username, Match match) async {
  final List<Map<String, dynamic>> flatSquad = squad
      .expand((x) => x)
      .map((player) => {
            'playerID': player.playerID,
            'playerName': player.playerName,
            'playerAge': player.age,
            'position': player.position,
            'teamName': player.teamName,
            'marketValue': player.marketValue,
            'playerImage': player.playerImage,
          })
      .toList();
  final response = await http.post(
    Uri.parse(submitSquadUri),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'teamName': teamName,
      'user': username,
      'match': match.toJson(),
      'squad': flatSquad,
    }),
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Squad submitted successfully!'),
      duration: Duration(seconds: 2),
    ));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Failed to submit squad.'),
      duration: Duration(seconds: 2),
    ));
  }
}
