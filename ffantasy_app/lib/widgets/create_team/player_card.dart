import 'package:ffantasy_app/bloc/squad_event_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerCard extends StatelessWidget {
  final String teamName;
  final int credits;
  final int totalPoints;
  final String playerImage;
  final String playerName;
  final int playerid;
  final bool home;
  final int position;

  const PlayerCard({
    super.key,
    required this.playerName,
    required this.playerImage,
    required this.totalPoints,
    required this.credits,
    required this.teamName,
    required this.playerid,
    required this.home,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    Color white = Colors.white;
    Color containerColor = white;
    return BlocBuilder<SquadEventBloc, SquadEventState>(
      builder: (context, state) {
        if (state is SquadAddedState) {
          if (state.squad.contains(playerid)) {
            containerColor = Colors.amber;
            isSelected = true;
          } else {
            containerColor = Colors.white;
            isSelected = false;
          }
        }
        return GestureDetector(
          onTap: () {
            context
                .read<SquadEventBloc>()
                .add(AddPlayerEvent(playerid, context, home, position));
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.1),
              color: containerColor,
            ),
            height: 75,
            padding: EdgeInsets.only(left: 10, top: 3, bottom: 3, right: 19),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.help),
                  onPressed: () {},
                  iconSize: 20,
                ),
                Flexible(
                  flex: 6,
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      Image.asset(
                        playerImage,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              playerName,
                              style: TextStyle(
                                color: Color.fromARGB(255, 34, 1, 90),
                                fontWeight: FontWeight.w600,
                                fontSize: 14.5,
                              ),
                            ),
                            Text(
                              teamName,
                              style: TextStyle(
                                color: Color.fromARGB(155, 34, 1, 90),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      totalPoints.toString(),
                      style: TextStyle(
                        color: Color.fromARGB(255, 34, 1, 90),
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      Text(
                        credits.toString(),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color.fromARGB(255, 34, 1, 90),
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
