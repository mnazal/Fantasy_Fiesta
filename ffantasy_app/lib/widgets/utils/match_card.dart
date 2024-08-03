import 'package:ffantasy_app/bloc/squad_bloc/squad_event_bloc.dart';

import 'package:ffantasy_app/private/api/api.dart';
import 'package:ffantasy_app/screens/create_team_page.dart';

import 'package:ffantasy_app/private/api/match.dart';
import 'package:ffantasy_app/widgets/team_preview/squad_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final int type;

  const MatchCard({
    Key? key,
    required this.match,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String homeImage =
        'https://a.espncdn.com/combiner/i?img=/i/teamlogos/soccer/500/${match.homeTeamID}.png&scale=crop&cquality=40&location=origin&w=40&h=40';
    final String awayImage =
        'https://a.espncdn.com/combiner/i?img=/i/teamlogos/soccer/500/${match.awayTeamID}.png&scale=crop&cquality=40&location=origin&w=40&h=40';

    return GestureDetector(
      onTap: () {
        if (type == 0) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => SquadEventBloc(),
              child: CreateTeam(
                  homeImage: homeImage, awayImage: awayImage, match: match),
            ),
          ));
        } else if (type == 1) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SquadPreview(
                  homeImage: homeImage, awayImage: awayImage, match: match)));
        }
      },
      child: Card(
        elevation: 5,
        borderOnForeground: true,
        shape: const RoundedRectangleBorder(
            side: BorderSide(width: 0.4, color: Colors.deepPurple),
            borderRadius: BorderRadius.all(Radius.circular(4))),
        surfaceTintColor: Colors.white,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: Image.network(
                      homeImage,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(placeholderImage2);
                      },
                      width: 45,
                      height: 45,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      match.homeTeam,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    match.time,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: Image.network(
                      awayImage,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(placeholderImage2);
                      },
                      width: 45,
                      height: 45,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      match.awayTeam,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
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
