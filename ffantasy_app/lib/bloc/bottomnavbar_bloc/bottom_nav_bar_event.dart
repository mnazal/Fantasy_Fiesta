part of 'bottom_nav_bar_bloc.dart';

// Define the events
abstract class NavigationEvent {}

class NavigateToHome extends NavigationEvent {}

class NavigateToMyTeam extends NavigationEvent {}
