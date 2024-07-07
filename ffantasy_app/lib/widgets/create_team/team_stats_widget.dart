import 'package:flutter/material.dart';

class TeamStats extends StatelessWidget {
  const TeamStats({
    super.key,
    required this.playernumber,
    required this.homeNumber,
    required this.awayNumber,
    required this.creditsLeft,
    required int totalPlayers,
  }) : _totalPlayers = totalPlayers;

  final int playernumber;
  final int homeNumber;
  final int awayNumber;
  final int creditsLeft;
  final int _totalPlayers;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: const BoxDecoration(color: Color.fromARGB(255, 34, 1, 90)),
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
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
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
  }
}
