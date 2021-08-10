import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'DetailMovie.dart';
import 'MovieModel.dart';

class ListDataku extends StatefulWidget {
  const ListDataku({Key key}) : super(key: key);

  @override
  _ListDatakuState createState() => _ListDatakuState();
}

class _ListDatakuState extends State<ListDataku> {
  MovieModel movieModel;
  bool isloading = true;
  fetchMovieList() async {

    var apiResult = await http.get(Uri.parse("https://api.themoviedb.org/3/movie/now_playing?api_key=6ac7a042ac3b7599a689eb943fa0b6d0&language=en-US"));
    if (apiResult.statusCode == 200) {
      var parsedRes = json.decode(apiResult.body);
      print(parsedRes.toString());
      print("body : "+ apiResult.body.toString());
      movieModel = MovieModel.fromJson(parsedRes);
      setState(() {
        isloading = false;
      });
    } else {
      print(apiResult.body.toString());
      return null;
      // throw Exception('Failed to load ');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMovieList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : isloading == true ? Center(
        child: CircularProgressIndicator(),
      ) : Container(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DetailMovie(movieModel.results[index]);
                }));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            height: 100,
                            imageUrl: "https://image.tmdb.org/t/p/w500/"+movieModel.results[index].posterPath,
                            placeholder: (context, url) => Image.asset(
                              'images/movielogo.png',
                              height: 200,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'images/movielogo.png',
                              height: 200,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(movieModel.results[index].originalTitle,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16)),
                            SizedBox(height: 10),
                            Text(
                              '${movieModel.results[index].overview}',
                              style: TextStyle(fontSize: 14),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: movieModel.results.length,
        ),
      ),
      );
  }
}
