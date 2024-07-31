import 'package:flutter/material.dart';

class FantasyNavBar extends StatelessWidget {
  final int selectedIndex;

  const FantasyNavBar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.black54,
      selectedFontSize: 14.0,
      unselectedFontSize: 12.0,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 30,
      currentIndex: selectedIndex,
      onTap: (index) {},
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_soccer),
          label: 'My Team',
        ),
      ],
    );
  }
}
