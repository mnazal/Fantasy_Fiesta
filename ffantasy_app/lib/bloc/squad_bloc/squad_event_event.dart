part of 'squad_event_bloc.dart';

@immutable
sealed class SquadEventEvent {}

class AddPlayerEvent extends SquadEventEvent {
  final BuildContext context;
  final bool ishome;
  final Player player;

  AddPlayerEvent(this.context, this.ishome, this.player);
}

class RemovePlayerEvent extends SquadEventEvent {
  final Player player;

  RemovePlayerEvent(this.player);
}

class SubmitMatchAndSquadEvent extends SquadEventEvent {
  final Match match;
  final List<List<Player>> squad;

  SubmitMatchAndSquadEvent(this.match, this.squad);
}
