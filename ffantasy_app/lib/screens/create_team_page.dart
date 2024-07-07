import 'package:ffantasy_app/bloc/position_bloc.dart';
import 'package:ffantasy_app/bloc/squad_event_bloc.dart';
import 'package:ffantasy_app/widgets/create_team/player_card.dart';
import 'package:ffantasy_app/widgets/create_team/team_stats_widget.dart';
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

class _CreateTeamState extends State<CreateTeam> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  Color containerColor = Colors.white;
  final int _totalPlayers = 11;
  int containerColorCheck = 1;

  int creditsLeft = 100;

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
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocConsumer<SquadEventBloc, SquadEventState>(
        listener: (context, state) {
          if (state is SquadAddedState) {
            creditsLeft = 100 - state.cost;
            playernumber = state.squad.length;
            homeNumber = state.home;
            awayNumber = state.away;
            if (creditsLeft < 0) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('You have used more than your Available Credits'),
                duration: Duration(seconds: 2),
              ));
            }
          }
        },
        builder: (context, state) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                children: [
                  TeamStats(
                    playernumber: playernumber,
                    homeNumber: homeNumber,
                    awayNumber: awayNumber,
                    creditsLeft: creditsLeft,
                    totalPlayers: _totalPlayers,
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
                      onTap: (tabIndex) {
                        context
                            .read<PositionBloc>()
                            .add(SelectedPositionEvent(tabIndex));
                      },
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
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Row(
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
                                  itemCount: teamPlayers
                                      .where((player) =>
                                          player['position'] == positions[i])
                                      .toList()
                                      .length,
                                  itemBuilder: (context, index) {
                                    var filteredPlayers = teamPlayers
                                        .where((player) =>
                                            player['position'] == positions[i])
                                        .toList();

                                    return PlayerCard(
                                      playerid: int.parse(
                                          filteredPlayers[index]['id']),
                                      playerName: filteredPlayers[index]
                                          ['name'],
                                      playerImage: filteredPlayers[index]
                                          ['image'],
                                      totalPoints: filteredPlayers[index]
                                          ['totalPoints'],
                                      credits: filteredPlayers[index]['price'],
                                      teamName: filteredPlayers[index]['team'],
                                      home: filteredPlayers[index]['team'] ==
                                              widget.homeTeamName
                                          ? true
                                          : false,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(155, 225, 225, 225)),
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Add your onPressed code here!
                            },
                            style: const ButtonStyle(
                                padding: MaterialStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        vertical: 13, horizontal: 18)),
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 255, 255, 255)),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        side: BorderSide(width: 0.1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)))),
                                surfaceTintColor: MaterialStatePropertyAll(
                                    Colors.white)), // Deep blue color

                            child: const Text(
                              'Preview Team',
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Add your onPressed code here!
                            },
                            style: const ButtonStyle(
                                padding: MaterialStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        vertical: 11, horizontal: 18)),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(6)))),
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 34, 1, 90)),
                                surfaceTintColor: MaterialStatePropertyAll(
                                    Colors.white)), // Deep blue color

                            child: Row(
                              children: [
                                const Text(
                                  'Confirm Team',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Icon(
                                  Icons.save,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ));
        },
      ),
    );
  }
}
