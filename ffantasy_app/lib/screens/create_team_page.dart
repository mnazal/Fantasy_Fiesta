import 'package:ffantasy_app/bloc/position_bloc.dart';
import 'package:ffantasy_app/bloc/squad_event_bloc.dart';
import 'package:ffantasy_app/widgets/create_team/player_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/players.dart';

class CreateTeam extends StatefulWidget {
  final String homeTeamName;

  final String awayTeamName;

  const CreateTeam(
      {super.key, required this.homeTeamName, required this.awayTeamName});

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  int _selectedPlayers = 0;
  Color containerColor = Colors.white;
  final int _totalPlayers = 11;
  int containerColorCheck = 1;

  int creditsLeft = 100;

  void _selectPlayer() {
    if (_selectedPlayers < _totalPlayers) {
      setState(() {
        _selectedPlayers += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int playernumber = 0;
    int homeNumber = 0;
    int awayNumber = 0;
    int positioned = 0;
    int gk = 0;
    int df = 0, mf = 0, fw = 0;

    bool selected = false;

    final List<Map<String, dynamic>> teamPlayers = players.where((player) {
      return player['team'] == widget.homeTeamName ||
          player['team'] == widget.awayTeamName;
    }).toList();
    List<Map<String, dynamic>> positionPlayers = teamPlayers;

    List<String> positions = ['GK', 'DEF', 'MID', 'FWD'];

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 34, 1, 90),
          leading: const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          title: const Column(
            children: [
              Text(
                'Create Your Team',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        body: BlocConsumer<SquadEventBloc, SquadEventState>(
          listener: (context, state) {
            if (state is SquadAddedState) {
              creditsLeft = 100 - state.cost;
              playernumber = state.squad.length;
              if (creditsLeft < 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text('You have used more than your Available Credits'),
                  duration: Duration(seconds: 2),
                ));
              }
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: BlocConsumer<PositionBloc, PositionState>(
                listener: (context, state) {
                  if (state is PositionSelected) {
                    positioned = state.position;
                  }
                },
                builder: (context, state) {
                  positionPlayers = teamPlayers.where((player) {
                    return player['position'] == positions[positioned];
                  }).toList();
                  return Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 34, 1, 90)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                            color: Color.fromARGB(
                                                160, 255, 255, 255),
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        homeNumber.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'RM',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                160, 255, 255, 255),
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        awayNumber.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
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
                                          color: creditsLeft < 0
                                              ? Colors.red
                                              : Colors.white,
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
                                    backgroundColor: const Color.fromARGB(
                                        255, 239, 239, 239),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
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
                      ),
                      Container(
                        height: 50,
                        decoration:
                            BoxDecoration(border: Border.all(width: 0.1)),
                        child: ButtonBar(
                          alignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            for (String position in positions)
                              SizedBox(
                                child: TextButton(
                                  child: Text(position),
                                  onPressed: () {
                                    int positioned =
                                        positions.indexOf(position);

                                    context
                                        .read<PositionBloc>()
                                        .add(SelectedPositionEvent(positioned));
                                  },
                                  style: const ButtonStyle(
                                      fixedSize: MaterialStatePropertyAll(
                                          Size.fromHeight(50)),
                                      iconSize: MaterialStatePropertyAll(60),
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              side: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(0))))),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        color: Color.fromARGB(255, 238, 233, 233),
                        height: 50,
                        child: Center(
                          child: Text(
                            numberConstraints[positioned],
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 34, 1, 90),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Color.fromARGB(255, 34, 1, 90),
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 3,
                              fit: FlexFit.tight,
                              child: Text(
                                'Player',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.5,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Text(
                                'Points',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.5,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Text(
                                'Value',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: positionPlayers.length,
                          itemBuilder: ((context, index) {
                            return PlayerCard(
                              playerid: int.parse(positionPlayers[index]['id']),
                              playerName: positionPlayers[index]['name'],
                              playerImage: positionPlayers[index]['image'],
                              totalPoints: positionPlayers[index]
                                  ['totalPoints'],
                              credits: positionPlayers[index]['price'],
                              teamName: positionPlayers[index]['team'],
                              color: selected,
                            );
                          }),
                        ),
                      )
                    ],
                  );
                },
              ),
            );
          },
        ));
  }
}
