part of 'squad_event_bloc.dart';

@immutable
sealed class SquadEventState {}

final class SquadInitialState extends SquadEventState {}

final class SquadAddedState extends SquadEventState {
  final List<List<Player>> squad;
  final double cost;
  final int home, away;

  SquadAddedState({
    required this.squad,
    required this.cost,
    required this.home,
    required this.away,
  });
}

final class SquadAddFailedState extends SquadEventState {}

class MatchAndSquadSubmissionSuccessState extends SquadEventState {}

class SquadLoadingState extends SquadEventState {}

class MatchAndSquadSubmissionDuplicateState extends SquadEventState {}

class MatchAndSquadSubmissionFailureState extends SquadEventState {}
