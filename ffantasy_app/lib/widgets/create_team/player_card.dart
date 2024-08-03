// ignore_for_file: unused_import

import 'dart:convert';

import 'package:ffantasy_app/bloc/squad_bloc/squad_event_bloc.dart';

import 'package:ffantasy_app/data/players.dart';
import 'package:ffantasy_app/private/api/api.dart';
import 'package:ffantasy_app/private/api/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class PlayerCard extends StatefulWidget {
  final bool home;

  Player player;

  PlayerCard({
    super.key,
    required this.home,
    required this.player,
  });

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  late Future<Map<String, dynamic>> playerDetails;
  Map<String, dynamic> playerData = {};
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    playerDetails = sendPostRequest();
    playerDetails.then((data) {
      if (mounted) {
        setState(() {
          playerData = data;
          isDataLoaded = true;
        });
      }
    });
  }

  Future<Map<String, dynamic>> sendPostRequest() async {
    final url = Uri.parse(playerUri); // Replace with your API endpoint
    final headers = {"Content-Type": "application/json"};

    final body = jsonEncode({
      "player_name": widget.player.playerName.replaceFirst(' ', '+'),
      "key2": widget.player.age,
      "key3": widget.player.position,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        //print('Failed to send data. Status code: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      //print('Error occurred: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = isDataLoaded ? playerData['playerImage'] ?? '' : '';
    final playerValue = isDataLoaded
        ? (playerData['newMarketValue'] is double
            ? playerData['newMarketValue']
            : double.tryParse(playerData['newMarketValue'].toString()) ?? 0.0)
        : 0.0;

    widget.player.marketValue = playerValue;
    widget.player.playerImage = imageUrl == '' ? placeholderImage : imageUrl;

    Color containerColor = Colors.white;
    return BlocBuilder<SquadEventBloc, SquadEventState>(
      builder: (context, state) {
        if (state is SquadAddedState) {
          if (checkPlayerSelected(
              state.squad, int.parse(widget.player.playerID))) {
            containerColor = Colors.amber;
          } else {
            containerColor = Colors.white;
          }
        }
        return GestureDetector(
          onTap: () {
            if (isDataLoaded) {
              context
                  .read<SquadEventBloc>()
                  .add(AddPlayerEvent(context, widget.home, widget.player));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.1),
              color: containerColor,
            ),
            height: 75,
            padding:
                const EdgeInsets.only(left: 10, top: 3, bottom: 3, right: 19),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(Icons.help),
                  onPressed: () {},
                  iconSize: 20,
                ),
                Flexible(
                  flex: 6,
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      AnimatedOpacity(
                        opacity: isDataLoaded ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.player.playerImage
                                    .replaceFirst('small', 'medium'),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              widget.player.playerName.length > 13
                                  ? "${widget.player.playerName.substring(0, 13)}.."
                                  : widget.player.playerName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 34, 1, 90),
                                fontWeight: FontWeight.w600,
                                fontSize: 14.5,
                              ),
                            ),
                            Text(
                              widget.player.teamName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
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
                      widget.player.age.toString(),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 34, 1, 90),
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Row(
                    children: [
                      Text(
                        widget.player.marketValue.toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
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

bool checkPlayerSelected(List<List<Player>> squad, int playerid) {
  for (List<Player> positionList in squad) {
    for (Player player in positionList) {
      if (int.parse(player.playerID) == playerid) {
        return true;
      }
    }
  }
  return false;
}
