import 'package:ffantasy_app/data/country.dart';
import 'package:ffantasy_app/screens/create_team_page.dart';
import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final String homeTeam;
  final String awayTeam;

  const MatchCard({
    Key? key,
    required this.homeTeam,
    required this.awayTeam,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? homeCountryCode = countryCode[homeTeam];
    final String? awayCountryCode = countryCode[awayTeam];
    print(homeCountryCode);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return CreateTeam(homeTeamName: homeTeam, awayTeamName: awayTeam);
        }));
      },
      child: Card(
        elevation: 0,
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.5, color: Colors.deepPurple),
            borderRadius: BorderRadius.all(Radius.circular(0))),
        surfaceTintColor: Colors.white,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Column(
                children: [
                  Image.network(
                    'https://flagsapi.com/$homeCountryCode/shiny/64.png',
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Error');
                    },
                    width: 45,
                    height: 45,
                  ),
                  SizedBox(width: 8),
                  Text(
                    homeTeam,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                    'Today',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Time : 8 pm',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Image.network(
                    'https://flagsapi.com/$awayCountryCode/shiny/64.png',
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Error');
                    },
                    width: 45,
                    height: 45,
                  ),
                  SizedBox(width: 8),
                  Text(
                    awayTeam,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
