part of 'position_bloc.dart';

@immutable
sealed class PositionState {}

final class PositionInitial extends PositionState {
  final int position = 0;
}

final class PositionSelected extends PositionState {
  final int position;

  PositionSelected({required this.position});
}
