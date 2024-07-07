part of 'position_bloc.dart';

@immutable
sealed class PositionEvent {}

final class SelectedPositionEvent extends PositionEvent {
  final int position;

  SelectedPositionEvent(this.position);
}
