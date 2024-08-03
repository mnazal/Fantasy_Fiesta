import 'dart:math';

import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> bg = ['assets/intial/bg1.jpg', 'assets/intial/bg2.jpg'];
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 1, 90),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(bg[Random().nextInt(2)]),
              fit: BoxFit.fitHeight),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 66,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8)))),
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                        surfaceTintColor:
                            MaterialStatePropertyAll(Colors.white)),
                    child: const Text(
                      'LET\'S PLAY',
                      style: TextStyle(
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Color.fromARGB(255, 34, 1, 90),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
