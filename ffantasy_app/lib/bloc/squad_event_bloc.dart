import 'package:bloc/bloc.dart';
import 'package:ffantasy_app/data/players.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'squad_event_event.dart';
part 'squad_event_state.dart';

class SquadEventBloc extends Bloc<SquadEventEvent, SquadEventState> {
  SquadEventBloc() : super(SquadInitialState()) {
    int cost = 0;
    on<AddPlayerEvent>((event, emit) {
      if (state is SquadAddedState) {
        final List<int> updatedSquad =
            List.from((state as SquadAddedState).squad);
        for (int playerid in updatedSquad) {
          players.forEach((element) {
            if (element['id'] == (playerid).toString()) {
              cost += int.parse((element['price']).toString());
            }
          });
        }
        if (updatedSquad.contains(event.playerid)) {
          updatedSquad.remove(event.playerid);

          //cost -= playerPrice;
        } else {
          if (updatedSquad.length < 11) {
            updatedSquad.add(event.playerid);
          }
          //cost += playerPrice;
        }
        cost = 0;

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
