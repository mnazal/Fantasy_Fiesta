import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_color_event.dart';
part 'change_color_state.dart';

List<int> _squad = [];
int _cost = 0;

class ChangeColorBloc extends Bloc<ChangeColorEvent, ChangeColorState> {
  ChangeColorBloc()
      : super(ChangeColorInitial(squad: [], totalCost: 0, initialColor: 1)) {
    on<SelectedPlayerEvent>((event, emit) {
      if (_squad.length <= 11 && _cost + event.cost <= 100) {
        bool isSelected = false;
        if (state is SelectedPlayer) {
          isSelected = !(state as SelectedPlayer).isSelected;
          if (isSelected) {
            _squad.add(event.playerId);
            _cost += event.cost;
          } else {
            _squad.remove(event.playerId);
            _cost -= (event.cost);
          }

          emit(SelectedPlayer(
              isSelected: isSelected, squad: _squad, totalCost: _cost));
        } else {
          isSelected = true;
          _squad.add(event.playerId);
          _cost += (event.cost);

          emit(SelectedPlayer(
              isSelected: isSelected, squad: _squad, totalCost: _cost));
        }
      }

      print(_squad);
      print('$_cost in bloc');
    });
  }
}
