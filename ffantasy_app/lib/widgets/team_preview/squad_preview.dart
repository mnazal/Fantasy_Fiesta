import 'dart:math';

import 'package:ffantasy_app/bloc/squad_bloc/squad_event_bloc.dart';
import 'package:ffantasy_app/data/players.dart';
import 'package:ffantasy_app/private/api/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<String> sleeves = [
  "assets/sleeves/black.png",
  "assets/sleeves/arg.png",
];

// ignore: must_be_immutable
class SquadPreview extends StatelessWidget {
  const SquadPreview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<List<Player>> squad = [];
    return BlocBuilder<SquadEventBloc, SquadEventState>(
        builder: (context, state) {
      if (state is SquadAddedState) {
        squad = state.squad;
      }
      return GestureDetector(
        onVerticalDragEnd: (_) {
          Navigator.pop(context); // End drag, close the bottom sheet
        },
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: Column(
            children: [
              Container(
                height: 500,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  image: DecorationImage(
                    image: AssetImage('assets/avatars/field.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < 4; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (Player player in squad[i])
                              Container(
                                width: 70,
                                height: 80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          sleeves[Random().nextInt(2)])),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2),
                                      margin: EdgeInsets.all(0),
                                      width: 80,
                                      height: 15,
                                      color: Colors.white,
                                      child: Text(
                                        "hi",
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      margin: EdgeInsets.all(0),
                                      width: 80,
                                      height: 14,
                                      color: const Color.fromARGB(
                                          255, 236, 236, 236),
                                      child: Text(
                                        "Hello",
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 80,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(155, 225, 225, 225),
                ),
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FractionallySizedBox(
                      heightFactor: 0.85,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 255, 0, 0)),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                            side: BorderSide(width: 0.1),
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          )),
                          surfaceTintColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Back',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FractionallySizedBox(
                      heightFactor: 0.85,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 34, 1, 90)),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                            side: BorderSide(width: 0.1),
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          )),
                          surfaceTintColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Confirm Team',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Icon(Icons.save, color: Colors.white),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
