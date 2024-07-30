import 'dart:ffi';

import 'package:ffantasy_app/bloc/squad_event_bloc.dart';
import 'package:ffantasy_app/private/api/api.dart';
import 'package:ffantasy_app/private/api/player.dart';
import 'package:ffantasy_app/widgets/team_preview/squad_preview.dart';
import 'package:ffantasy_app/widgets/create_team/player_card.dart';
import 'package:ffantasy_app/widgets/create_team/team_stats_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/players.dart';

class CreateTeam extends StatefulWidget {
  final String homeTeamName;
  final String awayTeamName;
  final String matchID, awayTeamID, homeTeamID, homeImage, awayImage;

  const CreateTeam(
      {super.key,
      required this.homeTeamName,
      required this.awayTeamName,
      required this.matchID,
      required this.awayTeamID,
      required this.homeTeamID,
      required this.homeImage,
      required this.awayImage});

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> with TickerProviderStateMixin {
  TabController? _tabController;
  late AnimationController _bottomSheetAnimationController;
  late Animation<double> _bottomSheetAnimation;
  late Future<List<Player>> _squadfuture;

  @override
  void initState() {
    super.initState();
    _squadfuture =
        fetchSquad(int.parse(widget.homeTeamID), int.parse(widget.awayTeamID));
    _tabController = TabController(length: 4, vsync: this);

    _bottomSheetAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _bottomSheetAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(_bottomSheetAnimationController);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _bottomSheetAnimationController.dispose();
    super.dispose();
  }

  final int _totalPlayers = 11;
  double creditsLeft = 100;
  int numberOfGoalKeepers = 0;
  int numberofDefenders = 0;
  int numberOfMidfielders = 0;
  int numberofForwards = 0;

  Future<List<Player>> fetchSquad(int squadID1, int squadID2) async {
    // Build the URIs for the two squads
    final Uri uri1 = Uri.parse('$squadListUri$squadID1');
    final Uri uri2 = Uri.parse('$squadListUri$squadID2');

    try {
      // Fetch data for the first squad
      final response1 = await http.get(uri1);
      if (response1.statusCode != 200) {
        throw Exception('Failed to load squad for ID $squadID1');
      }

      final List<dynamic> jsonData1 = json.decode(response1.body);
      List<Player> squad1 = jsonData1
          .map((json) => Player.fromJson(json, widget.homeTeamName))
          .toList();

      // Fetch data for the second squad
      final response2 = await http.get(uri2);
      if (response2.statusCode != 200) {
        throw Exception('Failed to load squad for ID $squadID2');
      }
      final List<dynamic> jsonData2 = json.decode(response2.body);
      List<Player> squad2 = jsonData2
          .map((json) => Player.fromJson(json, widget.awayTeamName))
          .toList();

      // Combine the two squads
      List<Player> combinedSquad = squad1 + squad2;

      // List<Player> updatedSquad = combinedSquad
      //     .where((element) =>
      //         element.marketValue != "null" || element.marketValue != "0.0")
      //     .toList();

      return combinedSquad;
    } catch (e) {
      print('Error fetching squads: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    int playernumber = 0;
    int homeNumber = 0;
    int awayNumber = 0;
    bool isWeb = MediaQuery.of(context).size.width >= 1024;

    final List<Map<String, dynamic>> teamPlayers = players.where((player) {
      return player['team'] == widget.homeTeamName ||
          player['team'] == widget.awayTeamName;
    }).toList();

    List<String> positions = ['G', 'D', 'M', 'F'];
    bool isButtonDisabled = true;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SquadEventBloc(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 34, 1, 90),
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: const Text(
            'Create Your Team',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: BlocConsumer<SquadEventBloc, SquadEventState>(
          listener: (context, state) {
            if (state is SquadAddedState) {
              creditsLeft = 100 - state.cost;

              homeNumber = state.home;
              awayNumber = state.away;
              numberOfGoalKeepers = state.squad[0].length;
              numberofDefenders = state.squad[1].length;
              numberOfMidfielders = state.squad[2].length;
              numberofForwards = state.squad[3].length;
              playernumber = homeNumber + awayNumber;
              if (playernumber == 1) {
                setState(() {
                  isButtonDisabled = false;
                });
              }
              if (creditsLeft < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('You have used more than your Available Credits'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                children: [
                  TeamStats(
                    homeImage: widget.homeImage,
                    awayImage: widget.awayImage,
                    homeTeam: widget.homeTeamName,
                    awayTeam: widget.awayTeamName,
                  ),
                  SizedBox(
                    height: 50,
                    child: TabBar(
                      tabs: [
                        for (String position in positions)
                          SizedBox(
                            height: 50,
                            child: Center(
                              child: Text(position),
                            ),
                          ),
                      ],
                      unselectedLabelColor:
                          const Color.fromARGB(255, 34, 1, 90),
                      labelColor: const Color.fromARGB(255, 34, 1, 90),
                      controller: _tabController,
                      indicatorColor: const Color.fromARGB(255, 224, 167, 11),
                      indicatorWeight: 5,
                      indicatorSize: TabBarIndicatorSize.tab,
                      onTap: (tabIndex) {},
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        for (int i = 0; i < positions.length; i++)
                          Column(
                            children: [
                              Container(
                                color: const Color.fromARGB(255, 238, 233, 233),
                                height: 50,
                                child: Center(
                                  child: Text(
                                    numberConstraints[i],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 34, 1, 90),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                color: const Color.fromARGB(255, 34, 1, 90),
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      flex: 6,
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
                                child: FutureBuilder<List<Player>>(
                                    future: _squadfuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return const Center(
                                            child: Text('No matches found'));
                                      } else {
                                        final squad = snapshot.data!;

                                        final positionFilteredSquad = squad
                                            .where((element) =>
                                                element.position ==
                                                positions[i])
                                            .toList();

                                        return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              positionFilteredSquad.length,
                                          itemBuilder: (context, index) {
                                            final player =
                                                positionFilteredSquad[index];

                                            print(player);

                                            return PlayerCard(
                                              playerid:
                                                  int.parse(player.playerID),
                                              playerName: player.playerName,
                                              //layerImage: player.playerImage,
                                              totalPoints: 0,
                                              credits: 0,
                                              teamName: player.teamName,
                                              home: player.teamName ==
                                                      widget.homeTeamName
                                                  ? true
                                                  : false,
                                              position: i,
                                              age: player.age,
                                            );
                                          },
                                        );
                                      }
                                    }),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 13),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(155, 225, 225, 225),
                    ),
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FractionallySizedBox(
                          heightFactor: 0.85,
                          child: ElevatedButton(
                            statesController: MaterialStatesController(),
                            onPressed: () {
                              int checked = squadChecks(
                                  playernumber,
                                  numberOfGoalKeepers,
                                  numberofDefenders,
                                  numberOfMidfielders,
                                  numberofForwards);
                              if (checked == 0) {
                                _bottomSheetAnimationController
                                    .forward()
                                    .then((value) {
                                  showBottomSheet(
                                    elevation: 10,
                                    enableDrag: true,
                                    context: context,
                                    builder: (context) {
                                      return FadeTransition(
                                        opacity: _bottomSheetAnimation,
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0, 1),
                                            end: Offset.zero,
                                          ).animate(
                                              _bottomSheetAnimationController),
                                          child: SizedBox(
                                            child: SquadPreview(),
                                            height: 600,
                                          ),
                                        ),
                                      );
                                    },
                                  ).closed.whenComplete(() {
                                    _bottomSheetAnimationController.reverse();
                                  });
                                });
                              } else if (checked == -1) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content:
                                      Text('You have to select 11 players'),
                                  duration: Duration(seconds: 2),
                                ));
                              } else {
                                showMessage(checked, context);
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 255, 255, 255)),
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                side: BorderSide(width: 0.1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                              )),
                              surfaceTintColor:
                                  MaterialStateProperty.all(Colors.white),
                            ),
                            child: const Text(
                              'Preview Team',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        FractionallySizedBox(
                          heightFactor: 0.85,
                          child: ElevatedButton(
                            onPressed: () {
                              // Add your onPressed code here!
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 11, horizontal: 18)),
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                              )),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 34, 1, 90)),
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
                                  ),
                                ),
                                const SizedBox(width: 30),
                                const Icon(Icons.save, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

int squadChecks(int totalPlayers, int gk, int df, int mf, int fw) {
  if (totalPlayers < 11) {
    return -1;
  } else {
    if (gk < 1) {
      return -2;
    } else if (df < 3) {
      return -3;
    } else if (mf < 3) {
      return -4;
    } else if (fw < 1) {
      return -5;
    }
  }
  return 0;
}

void showMessage(int position, BuildContext messengercontext) {
  int index = (-position - 2);
  String? positionName = positionLimit[index]['name'];
  int posLimit = int.parse(positionLimit[index]['limit']!);
  String message = posLimit == 1 ? 'player' : 'players';

  ScaffoldMessenger.of(messengercontext).showSnackBar(SnackBar(
    content: Text('Select at least $posLimit $message from $positionName'),
    duration: const Duration(seconds: 2),
  ));
}

List<Map<String, String>> positionLimit = [
  {'name': 'Goalkeepers', 'limit': '1'},
  {'name': 'Defenders', 'limit': '3'},
  {'name': 'Midfielders', 'limit': '3'},
  {'name': 'Forwards', 'limit': '1'}
];
