import 'package:ffantasy_app/bloc/change_color/change_color_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerCard extends StatelessWidget {
  final String teamName;
  final int credits;
  final int totalPoints;
  final String playerImage;
  final String playerName;
  final int playerid;

  const PlayerCard({
    super.key,
    required this.playerName,
    required this.playerImage,
    required this.totalPoints,
    required this.credits,
    required this.teamName,
    required this.playerid,
  });

  @override
  Widget build(BuildContext context) {
    Color containerColor = Colors.white;
    Color amber = Color.fromARGB(174, 255, 212, 147);
    return BlocBuilder<ChangeColorBloc, ChangeColorState>(
      builder: (context, state) {
        bool isSelected = false;
        if (state is ChangeColorState) {
          isSelected = true;
        }
        return GestureDetector(
          onTap: () {
            context.read<ChangeColorBloc>().add(SelectedPlayerEvent(
                index: 1, cost: credits, playerId: playerid));
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.1),
              color: isSelected ? amber : containerColor,
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
                        onPressed: () {
                          context.read<ChangeColorBloc>().add(
                              SelectedPlayerEvent(
                                  index: 1, cost: credits, playerId: playerid));
                        },
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
