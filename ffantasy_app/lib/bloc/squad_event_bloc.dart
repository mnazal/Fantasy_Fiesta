import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ffantasy_app/data/players.dart';
import 'package:flutter/material.dart';

part 'squad_event_event.dart';
part 'squad_event_state.dart';

int cost = 0;
int homePlayers = 0;
int awayPlayers = 0;

class SquadEventBloc extends Bloc<SquadEventEvent, SquadEventState> {
  SquadEventBloc() : super(SquadInitialState()) {
    on<AddPlayerEvent>((event, emit) {
      if (state is SquadAddedState) {
        final List<int> updatedSquad =
            List.from((state as SquadAddedState).squad);

        if (updatedSquad.contains(event.playerid)) {
          updatedSquad.remove(event.playerid);
          if (event.ishome) {
            homePlayers--;
          } else {
            awayPlayers--;
          }

          //cost -= playerPrice;
        } else {
          if (updatedSquad.length < 11) {
            updatedSquad.add(event.playerid);
            if (event.ishome) {
              homePlayers++;
            } else {
              awayPlayers++;
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

        emit(SquadAddedState(updatedSquad, cost, homePlayers, awayPlayers));
      }
    });

    // Initialize with an empty list
    // ignore: invalid_use_of_visible_for_testing_member
    emit(SquadAddedState(const [], 0, 0, 0));
  }
}
