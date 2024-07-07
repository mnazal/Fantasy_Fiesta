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
  final bool color;

  const PlayerCard({
    super.key,
    required this.playerName,
    required this.playerImage,
    required this.totalPoints,
    required this.credits,
    required this.teamName,
    required this.playerid,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    Color white = Colors.white;
    Color amber = Color.fromARGB(120, 237, 188, 114);
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
                .add(AddPlayerEvent(playerid, context));
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.1),
              color: containerColor,
            ),
            height: 62,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 3,
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
                          children: [
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
                  width: 16,
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      Text(
                        credits.toString(),
                        style: TextStyle(
                          color: Color.fromARGB(255, 34, 1, 90),
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(0),
                        icon: isSelected
                            ? Icon(Icons.remove_circle)
                            : Icon(Icons.add_circle),
                        onPressed: () {},
                        iconSize: 20,
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
