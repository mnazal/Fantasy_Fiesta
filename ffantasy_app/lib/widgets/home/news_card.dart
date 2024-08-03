import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String newsHeading;
  final String image;
  const NewsCard({
    Key? key,
    required this.newsHeading,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: const BorderSide(width: 0.6, color: Colors.deepPurple)),
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsHeading,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      height: 30,
                      width: 100,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            padding: MaterialStatePropertyAll(
                                EdgeInsets.only(top: 3, bottom: 3)),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)))),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.deepPurple),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white),
                            surfaceTintColor:
                                MaterialStatePropertyAll(Colors.white)),
                        onPressed: () {},
                        child: const Text('Read More'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
