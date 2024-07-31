import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_nav_bar_event.dart';
part 'bottom_nav_bar_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(HomeScreenState()) {
    on<NavigateToHome>((event, emit) => emit(HomeScreenState()));
    on<NavigateToMyTeam>((event, emit) => emit(MyTeamScreenState()));
  }
}
