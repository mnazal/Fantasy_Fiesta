// squad_event_bloc.dart
import 'package:ffantasy_app/private/api/player.dart';

import 'package:ffantasy_app/private/api/player.dart';

abstract class SquadLoadEvent {}

class LoadSquadEvent extends SquadLoadEvent {
  final int homeTeamID;
  final int awayTeamID;
  final String homeTeamName;
  final String awayTeamName;

  LoadSquadEvent(
      {required this.homeTeamID,
      required this.awayTeamID,
      required this.homeTeamName,
      required this.awayTeamName});
}

// squadload_state.dart

// Base class for squad load states
abstract class SquadLoadState {
  const SquadLoadState();

  @override
  List<Object> get props => [];
}

// Initial state before any action is taken
class SquadInitial extends SquadLoadState {}

// State when squad data is being loaded
class SquadLoading extends SquadLoadState {}

// State when squad data has been successfully loaded
class SquadLoaded extends SquadLoadState {
  final List<Player> squad;

  const SquadLoaded(this.squad);

  @override
  List<Object> get props => [squad];
}

// State when an error occurs while loading squad data
class SquadError extends SquadLoadState {
  final String message;

  const SquadError(this.message);

  @override
  List<Object> get props => [message];
}
