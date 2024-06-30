import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'squad_list_event.dart';
part 'squad_list_state.dart';

class SquadListBloc extends Bloc<SquadListEvent, SquadListState> {
  SquadListBloc() : super(SquadListInitial()) {
    on<SquadListEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
