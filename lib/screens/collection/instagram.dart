import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xenome/models/instagram.dart';
import 'package:video_player/video_player.dart';
import 'package:xenome/models/collection.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Instagram extends StatefulWidget {
  var data;
  Instagram({this.data});

  @override
  _InstagramState createState() => _InstagramState();
}

class _InstagramState extends State<Instagram> {
  InstagramModel instagram;
  bool visible;
  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    visible = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: GestureDetector(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 0, bottom: 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.data.videoURL,
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
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height - 270),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ListView(
                        children: <Widget>[
                          SvgPicture.asset('assets/icos/instagram.svg'),
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
                            'Instagram',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF868E9C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _error(BuildContext context, String url, dynamic error) {
    print(error);
    return const Center(child: Icon(Icons.error));
  }
}
