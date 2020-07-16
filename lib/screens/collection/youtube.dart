import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:xenome/models/youtube.dart';
import 'package:xenome/models/collection.dart';
import 'package:video_player/video_player.dart';

class YouTube extends StatefulWidget {
  var data;
  YouTube({this.data});

  @override
  _YouTubeState createState() => _YouTubeState();
}

class _YouTubeState extends State<YouTube> {
  YoutubeModel youtube;
  bool visible;
  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    visible = true;
    super.initState();
  }

  void playYoutubeVideo() {
    FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: "AIzaSyDncHr2DX-5qVd8bwURNs-p5wsZpfaCcow",
      // videoUrl: "https://www.youtube.com/watch?v=iLnmTe5Q2Qw",
      videoUrl: widget.data.videoURL,
      autoPlay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(left: 0.0, right: 0.0, top: 0, bottom: 0),
                  child: GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.data.image,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.8,
                        placeholder: (BuildContext context, String url) =>
                            Image.asset(
                          'assets/icos/loader.gif',
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.8,
                          fit: BoxFit.cover,
                        ),
                        fit: BoxFit.cover,
                        errorWidget: _error,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 100.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        playYoutubeVideo();
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 100.0,
                            width: 100.0,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40.0, top: 35.0),
                            child: SvgPicture.asset('assets/icos/play.svg'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height - 270),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ListView(
                      children: <Widget>[
                        SvgPicture.asset('assets/icos/youtube.svg'),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.data.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.data.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _error(BuildContext context, String url, dynamic error) {
    print(error);
    return const Center(child: Icon(Icons.error));
  }
}
