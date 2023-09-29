import 'package:flutter/material.dart';

class WebtoonDetail extends StatelessWidget {
  final String genre, age, about;

  const WebtoonDetail({
    super.key,
    required this.genre,
    required this.age,
    required this.about,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${genre} / ${age}",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          about,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
