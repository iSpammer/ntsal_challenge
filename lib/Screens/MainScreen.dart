import 'package:flutter/cupertino.dart';
import 'package:ntsal_challenge/Model/Album.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:convert';

import 'detail_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<List<Album>> albums;

  @override
  void initState() {
    super.initState();
    albums = fetchAlbums();
  }

  Future<List<Album>> fetchAlbums() async {
    var url = Uri.parse(
        'https://run.mocky.io/v3/68afe586-0e22-487b-92dc-1a6588a7184c');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      var albums = list.map((season) => Album.fromJson(season)).toList();
      return albums;
    } else {
      print('Error!! sad');
      throw Exception('Failed to Load albums');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Lineup"),
          backgroundColor: Color(0xff043b48),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color(0xff043b48),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Album>>(
              future: albums,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      Album album = snapshot.data[index];
                      return InkWell(
                        child: Hero(
                          tag: album.id+"s",
                          child: Card(
                            child: Stack(
                              children: [
                                Image.network(album.image),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      album.name,
                                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(icon:Icon(album.isFavorite ? Icons.favorite : Icons.favorite_border_outlined), onPressed: () {  }, color: Colors.red,),
                                )
                              ],
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (_) {
                            return DetailScreen(album: album, heroId: index, albums: snapshot.data);
                          }));
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("Error");
                }
                return Center(child: CircularProgressIndicator(),);
              },
            ),
          ),
        ),
      ),
    );
  }
}
