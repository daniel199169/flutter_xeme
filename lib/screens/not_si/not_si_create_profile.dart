import 'package:flutter/material.dart';
import 'package:link/link.dart';
import 'package:xenome/firebase_services/authentication.dart';
import 'package:xenome/screens/base_widgets/title_sentence.dart';
import 'not_si_register.dart';
import 'login_sentence.dart';

class NotSiCreateProfile extends StatefulWidget {
  State<StatefulWidget> createState() => new _NotSiCreateProfileState();
}

class _NotSiCreateProfileState extends State<NotSiCreateProfile> {
  bool checkingFlight = false;
  bool success = false;

  void _showErrorSnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Oops... the URL couldn\'t be opened!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return !checkingFlight
        ? Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Center(
                      child: CustomPaint(painter: Drawhorizontalline()),
                    ),
                  ),
                  TitleSentence(),
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Center(
                      child: new Text(
                        'Mix with like-minded critical thinkers',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Center(
                      child: new Text(
                        'Create your free profile and embrace the opportunity to have your say or create your own experience maps while gathering valuable insights from the community',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF868E9C),
                          
                        )
                      ,
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: Link(
                        child: new Text(
                          'Learn more',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline,
                        ),
                        url: 'https://xenome.app/',
                        onError: _showErrorSnackBar,
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 25, right: 25),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                          return NotSiRegister();
                        }));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            'Create your free profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Roboto Medium',
                              color: Color(0xFF2B8DD8),
                            ),
                          )
                        ],
                      ),
                      elevation: 0,
                      minWidth: 350,
                      height: 50,
                      textColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: Color(0xFF181C26))),
                    ),
                  ),
                  LoginSentence()
                ]),
          )
        : !success
            ? CircularProgressIndicator()
            : Icon(
                Icons.check,
                color: Colors.green,
              );
  }
}

class Drawhorizontalline extends CustomPainter {
  Paint _paint;

  Drawhorizontalline() {
    _paint = Paint()
      ..color = Color(0xFF868E9C)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(-30.0, 0.0), Offset(30.0, 0.0), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
