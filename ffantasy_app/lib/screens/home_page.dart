import 'package:ffantasy_app/bloc/bottomnavbar_bloc/bottom_nav_bar_bloc.dart';
import 'package:ffantasy_app/screens/pages/home_page.dart';
import 'package:ffantasy_app/screens/pages/my_team_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        int _currentIndex = 0;

        // Determine the current index based on the state
        if (state is HomeScreenState) {
          _currentIndex = 0;
        } else if (state is MyTeamScreenState) {
          _currentIndex = 1;
        }

        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 5,
            leading: const Icon(
              Icons.notifications,
              color: Colors.black,
            ),
            title: const Text(
              'fútbol',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 23,
                letterSpacing: 0.7,
              ),
            ),
            actions: [
              Opacity(
                opacity: _currentIndex == 1 ? 0.0 : 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2.5),
                      ),
                      child: Image.asset(
                        'assets/avatars/cr.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.black54,
            selectedFontSize: 14.0,
            unselectedFontSize: 12.0,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 30,
            currentIndex: _currentIndex,
            onTap: (index) {
              final bloc = context.read<NavigationBloc>();
              if (index == 0) {
                bloc.add(NavigateToHome());
              } else if (index == 1) {
                bloc.add(NavigateToMyTeam());
              }
            },
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
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: const [
              HomePageIteams(),
              MyTeam(),
            ],
          ),
        );
      },
    );
  }
}
