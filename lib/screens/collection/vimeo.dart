import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';
import 'package:xenome/models/vimeo.dart';
import 'package:xenome/screens/viewer/video_item.dart';
import 'package:xenome/models/collection.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Vimeo extends StatefulWidget {
  var data;
  Vimeo({this.data});
  @override
  _VimeoState createState() => _VimeoState();
}

class _VimeoState extends State<Vimeo> {
  VimeoModel vimeo;

  bool visible;

  VideoPlayerController _videoPlayerController;
  final collectionTitleController = TextEditingController();

  @override
  void initState() {
    visible = true;
    getVimeo();
    super.initState();
  }

  getVimeo() async {
    setState(() {
      _videoPlayerController = new VideoPlayerController.asset(
        widget.data.videoURL,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: VideoItem(
              videoPlayerController: _videoPlayerController == null
                  ? new VideoPlayerController.asset('videos/IntroVideo.mp4')
                  : _videoPlayerController,
              looping: true,
            ),
          ),
          Visibility(
            visible: visible,
            child: GestureDetector(
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: 0.0, right: 0.0, top: 0, bottom: 0),
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 100.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            visible = false;
                          });
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
                          SvgPicture.asset('assets/icos/vimeo.svg'),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _error(BuildContext context, String url, dynamic error) {
    print(error);
    return const Center(child: Icon(Icons.error));
  }
}
