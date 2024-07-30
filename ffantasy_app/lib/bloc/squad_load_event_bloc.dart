// squad_event_bloc.dart
import 'dart:convert';

import 'package:ffantasy_app/bloc/squadload_event_bloc.dart';
import 'package:ffantasy_app/private/api/api.dart';
import 'package:ffantasy_app/private/api/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class SquadLoadEventBloc extends Bloc<SquadLoadEvent, SquadLoadState> {
  SquadLoadEventBloc() : super(SquadInitial()) {
    on<LoadSquadEvent>(_onLoadSquadEvent);
  }

  Future<void> _onLoadSquadEvent(
      LoadSquadEvent event, Emitter<SquadLoadState> emit) async {
    try {
      final squad = await fetchSquad(
        event.homeTeamID,
        event.awayTeamID,
        event.homeTeamName,
        event.awayTeamName,
      );
      emit(SquadLoaded(squad));
    } catch (e) {
      emit(SquadError(e.toString()));
    }
  }
}

Future<List<Player>> fetchSquad(int squadID1, int squadID2, String homeTeamName,
    String awayTeamName) async {
  // Build the URIs for the two squads
  final Uri uri1 = Uri.parse('$squadListUri$squadID1');
  final Uri uri2 = Uri.parse('$squadListUri$squadID2');

  try {
    // Fetch data for the first squad
    final response1 = await http.get(uri1);
    if (response1.statusCode != 200) {
      throw Exception('Failed to load squad for ID $squadID1');
    }

    final List<dynamic> jsonData1 = json.decode(response1.body);
    List<Player> squad1 =
        jsonData1.map((json) => Player.fromJson(json, homeTeamName)).toList();

    // Fetch data for the second squad
    final response2 = await http.get(uri2);
    if (response2.statusCode != 200) {
      throw Exception('Failed to load squad for ID $squadID2');
    }
    final List<dynamic> jsonData2 = json.decode(response2.body);
    List<Player> squad2 =
        jsonData2.map((json) => Player.fromJson(json, awayTeamName)).toList();

    // Combine the two squads
    List<Player> combinedSquad = squad1 + squad2;

    return combinedSquad;
  } catch (e) {
    print('Error fetching squads: $e');
    return [];
  }
}
