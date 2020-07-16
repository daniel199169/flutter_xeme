import 'package:flutter/material.dart';
import 'package:xenome/models/collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:link/link.dart';

class ViewerImage extends StatefulWidget {
  ViewerImage({this.data});

  var data;
  @override
  _ViewerImageState createState() => _ViewerImageState();
}

class _ViewerImageState extends State<ViewerImage>
    with SingleTickerProviderStateMixin {
  final collectionTitleController = TextEditingController();
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
  }

  void _showErrorSnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Oops... the URL couldn\'t be opened!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black87,
      body: Container(
          margin: EdgeInsets.only(left: 0.0, right: 0.0, top: 0, bottom: 0),
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(top: 0.0, left: 0, bottom: 50.0, right: 0),
                child: GestureDetector(
                  child: widget.data.link != ''
                      ? Link(
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
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                fit: BoxFit.cover,
                              ),
                              fit: BoxFit.cover,
                              errorWidget: _error,
                            ),
                          ),
                          url: widget.data.link,
                          onError: _showErrorSnackBar,
                        )
                      : ClipRRect(
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
            ],
          )),
    );
  }

  Widget _error(BuildContext context, String url, dynamic error) {
    print(error);
    return const Center(child: Icon(Icons.error));
  }
}
