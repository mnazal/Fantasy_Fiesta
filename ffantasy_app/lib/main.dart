import 'package:ffantasy_app/bloc/bottomnavbar_bloc/bottom_nav_bar_bloc.dart';
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
    return MaterialApp(
      title: 'Fantasy Fiesta',
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 34, 1, 90),
            titleTextStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255)),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => NavigationBloc(),
        child: HomePage(),
      ),
    );
  }
}
