import 'package:bloc/bloc.dart';
import 'package:ffantasy_app/data/players.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'squad_event_event.dart';
part 'squad_event_state.dart';

int cost = 0;

class SquadEventBloc extends Bloc<SquadEventEvent, SquadEventState> {
  SquadEventBloc() : super(SquadInitialState()) {
    on<AddPlayerEvent>((event, emit) {
      if (state is SquadAddedState) {
        final List<int> updatedSquad =
            List.from((state as SquadAddedState).squad);

        if (updatedSquad.contains(event.playerid)) {
          updatedSquad.remove(event.playerid);

          //cost -= playerPrice;
        } else {
          if (updatedSquad.length < 11) {
            updatedSquad.add(event.playerid);
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

        print(cost);
        print(updatedSquad);
        emit(SquadAddedState(updatedSquad, cost));
      }
    });

    // Initialize with an empty list
    // ignore: invalid_use_of_visible_for_testing_member
    emit(SquadAddedState(const [], 0));
  }
}
