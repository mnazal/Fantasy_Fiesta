part of 'squad_event_bloc.dart';

@immutable
sealed class SquadEventState {}

final class SquadInitialState extends SquadEventState {}

final class SquadAddedState extends SquadEventState {
  final List<int> squad;
  final int cost;

  SquadAddedState(this.squad, this.cost);
}

final class SquadAddFailedState extends SquadEventState {}
