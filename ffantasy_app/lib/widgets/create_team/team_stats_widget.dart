import 'package:ffantasy_app/bloc/squad_event_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamStats extends StatefulWidget {
  @override
  State<TeamStats> createState() => _TeamStatsState();
}

class _TeamStatsState extends State<TeamStats> {
  int playernumber = 0;

  int homeNumber = 0;

  int awayNumber = 0;

  int creditsLeft = 0;

  int _totalPlayers = 11;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SquadEventBloc, SquadEventState>(
      listener: (context, state) {
        if (state is SquadAddedState) {
          creditsLeft = 100 - state.cost;

          homeNumber = state.home;
          awayNumber = state.away;
          playernumber = homeNumber + awayNumber;
          if (creditsLeft < 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You have used more than your Available Credits'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        return Container(
          height: 180,
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 34, 1, 90)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Players",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          '$playernumber\t / 11',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 20),
                    Image.asset(
                      'assets/barcelona.png',
                      fit: BoxFit.fitHeight,
                      alignment: Alignment.center,
                      height: 50,
                      width: 50,
                    ),
                    Column(
                      children: [
                        const Text(
                          'BAR',
                          style: TextStyle(
                              color: Color.fromARGB(160, 255, 255, 255),
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          homeNumber.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          'RM',
                          style: TextStyle(
                              color: Color.fromARGB(160, 255, 255, 255),
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          awayNumber.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    Image.asset(
                      'assets/madrid.png',
                      fit: BoxFit.fitHeight,
                      alignment: Alignment.center,
                      height: 50,
                      width: 50,
                    ),
                    Column(
                      children: [
                        const Text(
                          "Credits Left",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          "$creditsLeft M",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: creditsLeft < 0 ? Colors.red : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: playernumber / _totalPlayers,
                      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.deepPurple),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Selected Players :  $playernumber / 11',
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
