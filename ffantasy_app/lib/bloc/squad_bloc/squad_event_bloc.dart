import 'dart:convert';

import 'package:ffantasy_app/data/players.dart';
import 'package:ffantasy_app/private/api/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:ffantasy_app/private/api/api.dart';

import 'package:ffantasy_app/private/api/match.dart';
import 'package:http/http.dart' as http;
part 'squad_event_event.dart';
part 'squad_event_state.dart';

int flag = 0;

int sumPlayers(List<List<Player>> squad) {
  int sum = 0;
  for (List<Player> positionList in squad) {
    sum += positionList.length;
  }
  return sum;
}

class SquadEventBloc extends Bloc<SquadEventEvent, SquadEventState> {
  SquadEventBloc() : super(SquadInitialState()) {
    on<AddPlayerEvent>((event, emit) {
      if (state is SquadAddedState) {
        final List<List<Player>> updatedSquad =
            List.from((state as SquadAddedState).squad);
        double squadCost = (state as SquadAddedState).cost;
        int homePlayers = (state as SquadAddedState).home;
        int awayPlayers = (state as SquadAddedState).away;

        // Find the position list to update
        List<Player> positionList =
            updatedSquad[positions.indexOf(event.player.position)];

        // Check if the player is already in the squad
        if (positionList.contains(event.player)) {
          // Remove the player from the squad
          if (squadCost - event.player.marketValue >= 0) {
            positionList.remove(event.player);
            if (event.ishome) {
              homePlayers--;
              squadCost -= event.player.marketValue;
            } else {
              awayPlayers--;
              squadCost -= event.player.marketValue;
            }
          }
        } else {
          // Ensure that the squad has less than the maximum allowed players
          if (sumPlayers(updatedSquad) < 11) {
            flag = 0;
            int numberofPlayersinPosition = positionList.length;
            int playerPosition = positions.indexOf(event.player.position);

            if (playerPosition == 0) {
              if (numberofPlayersinPosition < 1) {
                flag = 1;
              } else {
                showMessage("Goalkeepers", 1, event.context, 0);
              }
            } else if (playerPosition == 1) {
              if (numberofPlayersinPosition < 5) {
                flag = 1;
              } else {
                showMessage("Defenders", 5, event.context, 0);
              }
            } else if (playerPosition == 2) {
              if (numberofPlayersinPosition < 5) {
                flag = 1;
              } else {
                showMessage("Midfielders", 5, event.context, 0);
              }
            } else if (playerPosition == 3) {
              numberofPlayersinPosition < 3
                  ? flag = 1
                  : showMessage("Forwards", 3, event.context, 0);
            }

            if (flag == 1) {
              if (squadCost + event.player.marketValue <= 150) {
                if (event.ishome) {
                  if (homePlayers < 7) {
                    homePlayers++;
                    positionList.add(event.player);
                    squadCost += event.player.marketValue;
                  } else {
                    showMessage("", 0, event.context, 1);
                  }
                } else if (!event.ishome) {
                  if (awayPlayers < 7) {
                    awayPlayers++;
                    positionList.add(event.player);

                    squadCost += event.player.marketValue;
                  } else {
                    showMessage("", 0, event.context, 1);
                  }
                }
              }
            }
          } else {
            ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(
              content: Text('Maximum number of players 11 reached.'),
              duration: Duration(seconds: 2),
            ));
          }
        }

        emit(SquadAddedState(
            squad: updatedSquad,
            cost: squadCost,
            home: homePlayers,
            away: awayPlayers));
      }
    });

    on<SubmitMatchAndSquadEvent>((event, emit) async {
      emit(SquadLoadingState());
      submitSquad(List<List<Player>> squad, String teamName, String username,
          Match match) async {
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

        return response;
      }

      final response =
          await submitSquad(event.squad, 'Nazal\'s XI', 'nazal', event.match);
      if (response.statusCode == 200) {
        emit(MatchAndSquadSubmissionSuccessState());
      } else if (response.statusCode == 205) {
        emit(MatchAndSquadSubmissionDuplicateState());
      } else {
        emit(MatchAndSquadSubmissionFailureState());
      }
    });

    // Initialize with an empty list of lists
    emit(SquadAddedState(
      squad: List.generate(4, (_) => []),
      cost: 0,
      home: 0,
      away: 0,
    ));
  }
}

void showMessage(
    String position, int limit, BuildContext messengercontext, int type) {
  if (type == 0) {
    ScaffoldMessenger.of(messengercontext).showSnackBar(SnackBar(
      content: Text('Select only $limit from $position'),
      duration: const Duration(seconds: 2),
    ));
  } else {
    ScaffoldMessenger.of(messengercontext).showSnackBar(SnackBar(
      content: Text('Select only 7 players from a team'),
      duration: const Duration(seconds: 2),
    ));
  }
}
