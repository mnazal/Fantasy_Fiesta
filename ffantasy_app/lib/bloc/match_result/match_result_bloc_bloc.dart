import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'match_result_bloc_event.dart';
part 'match_result_bloc_state.dart';

class MatchResultBlocBloc
    extends Bloc<MatchResultBlocEvent, MatchResultBlocState> {
  MatchResultBlocBloc() : super(MatchResultBlocInitial()) {
    on<MatchResultBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
