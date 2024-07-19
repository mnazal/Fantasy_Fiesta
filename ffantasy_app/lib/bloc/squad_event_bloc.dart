import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'squad_event_event.dart';
part 'squad_event_state.dart';

int homePlayers = 0;
int awayPlayers = 0;
int flag = 0;

int sumPlayers(List<List<int>> squad) {
  int sum = 0;
  for (List<int> positionList in squad) {
    sum += positionList.length;
  }
  return sum;
}

class SquadEventBloc extends Bloc<SquadEventEvent, SquadEventState> {
  SquadEventBloc() : super(SquadInitialState()) {
    on<AddPlayerEvent>((event, emit) {
      print('AddPlayerEvent received');
      if (state is SquadAddedState) {
        final List<List<int>> updatedSquad =
            List.from((state as SquadAddedState).squad);
        int squadCost = (state as SquadAddedState).cost;

        if (updatedSquad[event.position].contains(event.playerid)) {
          updatedSquad[event.position].remove(event.playerid);
          if (event.ishome) {
            homePlayers--;
          } else {
            awayPlayers--;
          }
          squadCost -= event.playerCost;
          print(
              'Player removed. Home players: $homePlayers, Away players: $awayPlayers');
        } else {
          if (sumPlayers(updatedSquad) < 11) {
            flag = 0;
            int numberofPlayersinPosition = updatedSquad[event.position].length;
            if (event.position == 0) {
              if (numberofPlayersinPosition < 1) {
                flag = 1;
              } else {
                showMessage("Goalkeepers", 1, event.context);
              }
            } else if (event.position == 1) {
              if (numberofPlayersinPosition < 5) {
                flag = 1;
              } else {
                showMessage("Defenders", 5, event.context);
              }
            } else if (event.position == 2) {
              if (numberofPlayersinPosition < 5) {
                flag = 1;
              } else {
                showMessage("Midfielders", 5, event.context);
              }
            } else if (event.position == 3) {
              numberofPlayersinPosition < 3
                  ? flag = 1
                  : showMessage("Forwards", 3, event.context);
            }
            if (flag == 1) {
              if (event.ishome && homePlayers < 7) {
                homePlayers++;
                updatedSquad[event.position].add(event.playerid);
              } else if (awayPlayers < 7 && !event.ishome) {
                awayPlayers++;
                updatedSquad[event.position].add(event.playerid);
              }
              squadCost += event.playerCost;
              print(
                  'Player added. Home players: $homePlayers, Away players: $awayPlayers');
            }
          } else {
            ScaffoldMessenger.of(event.context).showSnackBar(const SnackBar(
              content: Text('Maximum number of players 11 reached.'),
              duration: Duration(seconds: 2),
            ));
          }
        }

        emit(
            SquadAddedState(updatedSquad, squadCost, homePlayers, awayPlayers));
      }
    });

    // Initialize with an empty list of lists
    emit(SquadAddedState(
      List.generate(4, (_) => []),
      0,
      0,
      0,
    ));
  }
}

void showMessage(String position, int limit, BuildContext messengercontext) {
  ScaffoldMessenger.of(messengercontext).showSnackBar(SnackBar(
    content: Text('Select only $limit from $position'),
    duration: const Duration(seconds: 2),
  ));
}
