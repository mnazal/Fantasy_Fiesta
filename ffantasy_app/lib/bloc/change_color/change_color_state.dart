part of 'change_color_bloc.dart';

@immutable
sealed class ChangeColorState {
    
}

final class ChangeColorInitial extends ChangeColorState {
  final List<int> squad;
  final int initialColor;
  final int totalCost;
  final List<bool> tappedItems;

  ChangeColorInitial({
    required this.squad,
    required this.totalCost,
    required this.initialColor,
  }) : tappedItems = List.generate(10, (index) => false);
}

// ignore: must_be_immutable
final class SelectedPlayer extends ChangeColorState {
  final bool isSelected;
  List<int> squad;
  int totalCost;
  //final List<bool> tappedItems;

  SelectedPlayer({
    required this.isSelected,
    required this.squad,
    required this.totalCost,
    //required this.tappedItems
  });
}
