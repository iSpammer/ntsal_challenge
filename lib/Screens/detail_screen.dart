import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ntsal_challenge/Component/button_with_text.dart';
import 'package:ntsal_challenge/Model/Album.dart';
import 'package:ntsal_challenge/Screens/schedule_screen.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final Album album;
  final int heroId;
  final List<Album> albums;

  const DetailScreen({Key key, @required this.album, @required this.heroId,@required this.albums})
      : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  PanelController _panelController = new PanelController();
  bool _collapsed = true;
  double _opacity = 0;
  Timer _timer;

  _colLoad() {
    _timer = new Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _opacity = 1;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _colLoad();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          _opacity = 0;
          Navigator.of(context).pop();
          return true;
        });
      },
      child: Scaffold(
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (_panelController.isPanelOpen) {
                  _panelController.close();
                }
              },
              child: Hero(
                tag: widget.album.id,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.album.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: Duration(milliseconds: 1000),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32.0, 0, 0, 0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: RaisedButton(
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.arrow_back),
                                  Text(
                                    'Back',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 280,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(widget.album.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border_outlined),
                                onPressed: () {},
                                color: Colors.red,
                              ),
                              Text(
                                widget.album.isFavorite
                                    ? "Remove from favorite"
                                    : "Add To Favorite",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32.0, 0, 0, 0),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              widget.album.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) /* add child content here */,
                ),
              ),
            ),
            SlidingUpPanel(
              onPanelClosed: () {
                setState(() {
                  _collapsed = true;
                });
              },
              onPanelOpened: () {
                setState(() {
                  _collapsed = false;
                });
              },
              controller: _panelController,
              collapsed: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Color(0xffffce66),
                  onPressed: () {
                    setState(() {});
                    _panelController.open();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("PLAYING ON"),
                          Text(widget.album.schedule.date)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("♬ DAY ${widget.album.schedule.day}"),
                          Text(widget.album.schedule.time)
                        ],
                      )
                    ],
                  ),
                ),
              ),
              panel: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: _collapsed ? 0 : 1,
                child: Container(
                  color: Color(0xff86bcc3),
                  child: _collapsed
                      ? Container()
                      : Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16.0, 8.0, 16, 0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "ABOUT THE ARTIST",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(widget.album.bio),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height -
                                        612,
                                  ),
                                  Card(
                                    child: ListTile(
                                      onTap: () {
                                        _launchUrl(widget.album.soundcloud);
                                      },
                                      leading:
                                          Image.asset("assets/soundcloud.png"),
                                      title: Text("LISTEN ON SOUNDCLOUD"),
                                      trailing: Icon(Icons.arrow_forward),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      onTap: () {
                                        _launchUrl(widget.album.instagram);
                                      },
                                      leading:
                                          Image.asset("assets/instagram.png"),
                                      title: Text("WATCH ON INSTAGRAM"),
                                      trailing: Icon(Icons.arrow_forward),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      onTap: () {
                                        _launchUrl(widget.album.facebook);
                                      },
                                      leading:
                                          Image.asset("assets/facebook.png"),
                                      title: Text("CHECK ON FACEBOOK"),
                                      trailing: Icon(Icons.arrow_forward),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              color: Color(0xff043b48),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ButtonWithText(
                                      icon: Icons.home,
                                      txt: "Home",
                                      color: Colors.white,
                                      fn: () {}),
                                  ButtonWithText(
                                    icon: Icons.queue_music,
                                    txt: "Schehdule",
                                    color: Colors.yellow,
                                    fn: (){
                                      print("hii");
                                      Navigator.push(context, CupertinoPageRoute(builder: (_) {
                                        return ScheduleScreen(albums: widget.albums, currentArtist: int.parse(widget.album.id),);
                                      }));
                                    },

                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}
