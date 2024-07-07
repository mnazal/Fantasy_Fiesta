import 'package:bloc/bloc.dart';
import 'package:ffantasy_app/data/players.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'squad_event_event.dart';
part 'squad_event_state.dart';

class SquadEventBloc extends Bloc<SquadEventEvent, SquadEventState> {
  SquadEventBloc() : super(SquadInitialState()) {
    int cost = 0;
    int currentPlayerCost = 0;
    on<AddPlayerEvent>((event, emit) {
      if (state is SquadAddedState) {
        final List<int> updatedSquad =
            List.from((state as SquadAddedState).squad);
        for (int playerid in updatedSquad) {
          players.forEach((element) {
            if (element['id'] == (playerid).toString()) {
              cost += int.parse((element['price']).toString());
              if (element['id'] == event.playerid) {
                currentPlayerCost = int.parse((element['price']).toString());
              }
            }
          });
        }
        if (updatedSquad.contains(event.playerid)) {
          updatedSquad.remove(event.playerid);

          cost -= currentPlayerCost;
        } else {
          if (updatedSquad.length < 11) {
            updatedSquad.add(event.playerid);
            cost += currentPlayerCost;
          } else {
            ScaffoldMessenger.of(event.context).showSnackBar(SnackBar(
              content: Text('Maximum number of players 11 reached.'),
              duration: Duration(seconds: 2),
            ));
          }
          //cost += playerPrice;
        }
        cost = 0;
        emit(SquadAddedState(updatedSquad, cost));
      }
    });

    // Initialize with an empty list
    // ignore: invalid_use_of_visible_for_testing_member
    emit(SquadAddedState(const [], 0));
  }
}
