import 'package:flutter/material.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:toonflix/services/api_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Today's toon",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 3,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text("${snapshot.data}");
          } else {
            return Text("Loading...");
          }
        },
        future: webtoons,
      ),
    );
  }
}
