import 'dart:async';
import 'package:flutter/material.dart';
import 'package:xenome/screens/viewer/viewer_init.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({this.id, this.type});
  final String id;
  final String type;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final List<String> imgList = [
  'https://firebasestorage.googleapis.com/v0/b/xenome-mobile.appspot.com/o/xebuilds%2Fimage_picker_28BDEA47-6AE7-449A-BB3C-D61AF9BD88FE-13796-00026A1B3A37180A.jpg?alt=media&token=e0e95da7-4774-4231-b68b-c8ee0e65dee8',
  'https://firebasestorage.googleapis.com/v0/b/xenome-mobile.appspot.com/o/xebuilds%2FSweepDown.jpg?alt=media&token=77c75c97-64a5-453d-a057-4c5e4b90ce4c',
  
];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initScreen(context),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 4);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ViewerInit(id: widget.id, type: widget.type)));
  }

  initScreen(BuildContext context) {
    return Scaffold(
      body: Center(
          child: CarouselSlider(
        height: MediaQuery.of(context).size.height,
        viewportFraction: 1.0,
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 2),
        items: map<Widget>(
        imgList,
        (index, i) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(i), fit: BoxFit.cover),
            ),
          );
        },
      ),
      )),
    );
  }
  List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}
}
