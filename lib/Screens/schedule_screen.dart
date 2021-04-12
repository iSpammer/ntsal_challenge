import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ntsal_challenge/Component/artist_card.dart';
import 'package:ntsal_challenge/Component/card_details.dart';
import 'package:ntsal_challenge/Component/time_slider.dart';
import 'package:ntsal_challenge/Model/Album.dart';
import 'package:ntsal_challenge/Model/ArtistSchedule.dart';
import 'package:http/http.dart' as http;
import 'package:ntsal_challenge/Model/RadioModel.dart';
class ScheduleScreen extends StatefulWidget {
  final List<Album> albums;
  final int currentArtist;

  const ScheduleScreen({Key key, @required this.albums, @required this.currentArtist}) : super(key: key);
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with TickerProviderStateMixin {
  Future<List<RadioModel>> hourList;
  int _index = 0;
  PageController _pageController;
  ScrollController _timeController;
  @override
  void initState() {
    super.initState();
    hourList = fetchArtistSchedule();
    _index = widget.currentArtist - 1;
    _pageController = PageController(viewportFraction: 0.7, initialPage: _index);
    _timeController = ScrollController(initialScrollOffset: _index*35.0);

  }

  Future<List<RadioModel>> fetchArtistSchedule() async {
    var url = Uri.parse(
        'https://run.mocky.io/v3/aa51022e-ece4-4426-8665-cbe9d2e0e127');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      List<ArtistSchedule> artistSchedules = list.map((season) => ArtistSchedule.fromJson(season)).toList();
      List<RadioModel> hl = [];
      print("meawww");
      for(ArtistSchedule as in artistSchedules){
        if (widget.currentArtist == int.parse(as.artistId))
          setState(() {
            hl.add(RadioModel(true, as.time, as),);
          });
      else
        hl.add(RadioModel(false, as.time, as),);
      }
      return hl;
    } else {
      print('Error!! sad');
      throw Exception('Failed to Load artistSchedules');
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeSlider example',
      home: Scaffold(
        backgroundColor: Color(0xff043b48),

        body : FutureBuilder<List<RadioModel>>(
          future: hourList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var artistSchedule = snapshot.data;
              int _artistSearch(String x){
                for(int j = 0; j < artistSchedule.length; j++){
                  if(artistSchedule[j].artistSchedule.artistId == x)
                    return j;
                }
              }
              return Column(
                children: [
                  SizedBox(height: 30,),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 150,
                    child: PageView.builder(
                      itemCount: artistSchedule.length,
                      controller: _pageController,
                      onPageChanged: (int index) => setState(() {
                        _index = index;
                        artistSchedule.forEach((element) => element.isSelected = false);
                        artistSchedule[_artistSearch(widget.albums[index].id)].isSelected = true;
                        _timeController.animateTo(40.0*index, duration: Duration(microseconds: 1500), curve: Curves.easeIn);
                      }),
                      itemBuilder: (_, i) {
                        var duration = "⌚ ${artistSchedule[_artistSearch(widget.albums[i].id)].artistSchedule.time.substring(0, artistSchedule[_artistSearch(widget.albums[i].id)].artistSchedule.time.length-3)} - ${_addTime(TimeOfDay(hour:int.parse(artistSchedule[_artistSearch(widget.albums[i].id)].artistSchedule.time.split(":")[0]),minute: int.parse(artistSchedule[_artistSearch(widget.albums[i].id)].artistSchedule.time.split(":")[1].substring(0, artistSchedule[_artistSearch(widget.albums[i].id)].artistSchedule.time.split(":")[1].length-3))), int.parse(artistSchedule[_artistSearch(widget.albums[i].id)].artistSchedule.duration)).format(context)} ${artistSchedule[_artistSearch(widget.albums[i].id)].artistSchedule.time.substring(artistSchedule[_artistSearch(widget.albums[i].id)].artistSchedule.time.length-3).toUpperCase()}";
                        return Transform.scale(
                          scale: i == _index ? 1 : 0.9,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            elevation: 2,
                            // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [

                                Image.network(widget.albums[i].image, fit: BoxFit.cover,),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(duration, style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(widget.albums[i].name, style: TextStyle(color: Colors.white, fontSize: 28),),
                                  ),
                                ),
                                // Center(
                                //   child: Text(
                                //     "Card ${i + 1} ${widget.albums}",
                                //     style: TextStyle(fontSize: 32),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 100,
                    child: TimeSlider(
                      onPressed: () {
                        for (int i = 0; i < artistSchedule.length; i++){
                          if(artistSchedule[i].isSelected){
                            setState(() {
                              _index = int.parse(artistSchedule[i].artistSchedule.artistId) -1;
                              _pageController.animateToPage(_index, duration: Duration(microseconds: 1000), curve: Curves.linear);
                            });
                            print("index must be $_index");
                            break;
                          }
                        }
                      },
                      scrollController: _timeController,
                      separation: 10,
                      hoursList: artistSchedule,
                      height: 37,
                      width: 70,
                      textColor: Colors.white,
                      selectedTextColor: Colors.white,
                      color: Colors.blue,
                      selectedColor: Colors.grey,
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("Error");
            }
            else{
              return Center(child: CircularProgressIndicator(),);
            }
            return Center(child: CircularProgressIndicator(),);
          },
        )

      ),
    );
  }

  TimeOfDay _addTime(TimeOfDay from ,int mins){
    final now = new DateTime.now();
    DateTime tmp = new DateTime(now.year, now.month, now.day, from.hour, from.minute);
    return TimeOfDay.fromDateTime(tmp.add(Duration(minutes: mins)));
  }

}
