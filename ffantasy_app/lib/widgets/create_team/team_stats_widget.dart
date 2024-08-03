import 'package:ffantasy_app/bloc/squad_bloc/squad_event_bloc.dart';
import 'package:ffantasy_app/data/constants.dart';
import 'package:ffantasy_app/private/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamStats extends StatefulWidget {
  final String homeImage, awayImage, homeTeam, awayTeam;

  const TeamStats(
      {super.key,
      required this.homeImage,
      required this.awayImage,
      required this.homeTeam,
      required this.awayTeam});
  @override
  State<TeamStats> createState() => _TeamStatsState();
}

class _TeamStatsState extends State<TeamStats> {
  int playernumber = 0;

  int homeNumber = 0;

  int awayNumber = 0;

  double creditsLeft = 0;

  final _totalPlayers = 11;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SquadEventBloc, SquadEventState>(
      listener: (context, state) {
        if (state is SquadAddedState) {
          creditsLeft =
              double.parse((costLimit - state.cost).toStringAsFixed(1));

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
                    Column(children: [
                      Image.network(
                        widget.homeImage,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            placeholderImage2,
                            width: 45,
                            height: 45,
                          );
                        },
                        width: 45,
                        height: 45,
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          widget.homeTeam,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 12),
                        ),
                      ),
                    ]),
                    Text(
                      homeNumber.toString(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      awayNumber.toString(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Column(children: [
                      Image.network(
                        widget.awayImage,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            placeholderImage2,
                            width: 45,
                            height: 45,
                          );
                        },
                        width: 45,
                        height: 45,
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          widget.awayTeam,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 12),
                        ),
                      ),
                    ]),
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
