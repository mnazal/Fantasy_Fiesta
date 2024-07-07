import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ffantasy_app/data/players.dart';
import 'package:flutter/material.dart';

part 'squad_event_event.dart';
part 'squad_event_state.dart';

int cost = 0;
int homePlayers = 0;
int awayPlayers = 0;
int gk = 0, df = 0, mf = 0, fw = 0;
List<int> playerPositions = [0, 0, 0, 0];
int flag = 0;

class SquadEventBloc extends Bloc<SquadEventEvent, SquadEventState> {
  SquadEventBloc() : super(SquadInitialState()) {
    on<AddPlayerEvent>((event, emit) {
      if (state is SquadAddedState) {
        final List<int> updatedSquad =
            List.from((state as SquadAddedState).squad);

        if (updatedSquad.contains(event.playerid)) {
          updatedSquad.remove(event.playerid);
          playerPositions[event.position]--;
          if (event.ishome) {
            homePlayers--;
          } else {
            awayPlayers--;
          }

          //cost -= playerPrice;
        } else {
          if (updatedSquad.length < 11) {
            flag = 0;
            if (event.position == 0) {
              if (playerPositions[0] < 1) {
                flag = 1;
              }
            } else if (event.position == 1) {
              if (playerPositions[1] < 5) {
                flag = 1;
              }
            } else if (event.position == 2) {
              if (playerPositions[2] < 5) {
                flag = 1;
              }
            } else if (event.position == 3) {
              playerPositions[3] < 3 ? flag = 1 : flag = 0;
            }
            if (flag == 1) {
              if (event.ishome && homePlayers < 7) {
                homePlayers++;
                updatedSquad.add(event.playerid);
                playerPositions[event.position]++;
              } else if (awayPlayers < 7 && event.ishome == false) {
                awayPlayers++;
                updatedSquad.add(event.playerid);
                playerPositions[event.position]++;
              }
            } else {
              ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(
                content: Text('Player Limit from a position Exceeded.'),
                duration: Duration(seconds: 2),
              ));
            }
          } else {
            ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(
              content: Text('Maximum number of players 11 reached.'),
              duration: Duration(seconds: 2),
            ));
          }
          //cost += playerPrice;
        }
        cost = 0;

        for (int playerid in updatedSquad) {
          for (var element in players) {
            if (int.parse(element['id']) == (playerid)) {
              var currentplayerprice = element['price'];
              if (currentplayerprice is int) {
                cost += element['price'] as int;
              }
            }
          }
        }

        emit(SquadAddedState(
            updatedSquad, cost, homePlayers, awayPlayers, playerPositions));
      }
    });

    // Initialize with an empty list
    // ignore: invalid_use_of_visible_for_testing_member
    emit(SquadAddedState(const [], 0, 0, 0, const []));
  }
}
