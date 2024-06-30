part of 'change_color_bloc.dart';

@immutable
sealed class ChangeColorEvent {
  final int index = 0;
}

final class SelectedPlayerEvent extends ChangeColorEvent {
  final int playerId;
  final int cost;
  final int index;

  SelectedPlayerEvent(
      {required this.cost, required this.playerId, required this.index});
}

final class DeSelectedPlayerEvent extends ChangeColorEvent {}
