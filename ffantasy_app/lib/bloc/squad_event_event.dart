part of 'squad_event_bloc.dart';

@immutable
sealed class SquadEventEvent {}

class AddPlayerEvent extends SquadEventEvent {
  final int playerid;
  final BuildContext context;
  final bool ishome;

  AddPlayerEvent(this.playerid, this.context, this.ishome);
}

class RemovePlayerEvent extends SquadEventEvent {
  final int playerid;

  RemovePlayerEvent(this.playerid);
}
