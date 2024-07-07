import 'package:flutter/material.dart';

class SquadPreview extends StatelessWidget {
  const SquadPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Icon(
              Icons.arrow_back_ios,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          title: Text(
            'My Team',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 38),
          child: Column(
            children: [
              Container(
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/avatars/field.jpg',
                      ),
                      fit: BoxFit.fill),
                ),
              ),
            ],
          ),
        ));
  }
}
