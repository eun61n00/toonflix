import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/services/api_service.dart';
import 'package:toonflix/widgets/webtoon_detail_widget.dart';
import 'package:toonflix/widgets/webtoon_episodes_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> detail;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences pref;
  bool isLiked = false;

  Future initPreferences() async {
    pref = await SharedPreferences.getInstance();
    final likedToons = pref.getStringList('likedToons');
    if (likedToons != null) {
      if (likedToons.contains(widget.id)) {
        isLiked = true;
        setState(() {});
      }
    } else {
      pref.setStringList('likedToons', []);
    }
  }

  onLikeTap() async {
    final likedToons = pref.getStringList('likedToons');
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }
      await pref.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    detail = ApiService.getWebtoonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              fontFamily: "Giants",
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.green.shade800,
          elevation: 3,
          actions: [
            IconButton(
              onPressed: onLikeTap,
              icon: isLiked
                  ? const Icon(Icons.favorite_rounded, color: Colors.red)
                  : const Icon(Icons.favorite_outline_rounded,
                      color: Colors.red),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              children: [
                Center(
                  child: Hero(
                    tag: widget.id,
                    child: Container(
                      width: 250,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(5, 5),
                            color: Colors.black87.withOpacity(0.4),
                          ),
                        ],
                      ),
                      child: Image.network(
                        widget.thumb,
                        headers: const {
                          "User-Agent":
                              "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return WebtoonDetail(
                          genre: snapshot.data!.genre,
                          age: snapshot.data!.age,
                          about: snapshot.data!.about);
                    }
                    return Text("...");
                  },
                  future: detail,
                ),
                const SizedBox(
                  height: 30,
                ),
                FutureBuilder(
                  future: episodes,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          for (var episode in snapshot.data!)
                            WebtoonEpisode(
                                episode: episode, webtoonId: widget.id)
                        ],
                      );
                    }
                    return Container();
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ));
  }
}
