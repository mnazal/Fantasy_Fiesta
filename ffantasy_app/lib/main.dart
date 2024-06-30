import 'package:ffantasy_app/bloc/change_color/change_color_bloc.dart';
import 'package:ffantasy_app/screens/create_team_page.dart';
import 'package:ffantasy_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangeColorBloc(),
      child: MaterialApp(
        title: 'Fantasy Fiesta',
        theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255)),
        home: const CreateTeam(
          homeTeamName: 'ESP',
          awayTeamName: 'ITA',
        ),
      ),
    );
  }
}
