import 'package:ffantasy_app/bloc/position_bloc.dart';
import 'package:ffantasy_app/bloc/squad_event_bloc.dart';
import 'package:ffantasy_app/screens/create_team_page.dart';
import 'package:ffantasy_app/screens/home_page.dart';
import 'package:ffantasy_app/screens/squad_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantasy Fiesta',
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: const Color.fromARGB(255, 34, 1, 90),
            titleTextStyle:
                TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255)),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SquadEventBloc(),
          ),
          BlocProvider(
            create: (context) => PositionBloc(),
          ),
        ],
        child: const CreateTeam(
          homeTeamName: 'ESP',
          awayTeamName: 'ITA',
        ),
      ),
    );
  }
}
