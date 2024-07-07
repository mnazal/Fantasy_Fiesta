import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'position_event.dart';
part 'position_state.dart';

class PositionBloc extends Bloc<PositionEvent, PositionState> {
  PositionBloc() : super(PositionInitial()) {
    on<SelectedPositionEvent>((event, emit) {
      int positioned = 0;
      if (state is PositionSelected) {
        positioned = event.position;
      }
      emit(PositionSelected(position: positioned));
    });
  }
}
