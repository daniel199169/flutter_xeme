import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:xenome/screens/custom_widgets/custom_text_form_field.dart';
import 'package:xenome/screens/view/home.dart';

class CreateStarter extends StatefulWidget {
  @override
  _CreateStarterState createState() => _CreateStarterState();
}

class _CreateStarterState extends State<CreateStarter>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  bool initConfigState = true;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Home()),
    );
  }

  saveDraft() {
    //save to the firebase? by Rpz
    goBack();
  }

  @override
  Widget build(BuildContext context) {
    confListenerState(context);

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: new Column(
          children: <Widget>[
            _simpleStack(),
          ],
        ),
      ),
    );
  }

  Widget _simpleStack() => Container(
        // constraints: BoxConstraints.expand(
        //   height: MediaQuery.of(context).size.height - 150.0,
        // ),
        child: Column(
          children: <Widget>[
            Container(
              height: 65,
              margin: EdgeInsets.only(top: 140, left: 40, right: 62, bottom: 0),
              child: Center(
                child: new Text('Share knowledge and gather feedback',
                    style: TextStyle(
                        fontFamily: 'Roboto Black',
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: Colors.white)),
              ),
            ),
            Container(
              // height: 250,
              margin: EdgeInsets.only(top: 0, left: 30, right: 62, bottom: 0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      label: 'Title',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      label: 'Description',
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  void confListenerState(BuildContext context) {
    if (!initConfigState) {
      initConfigState = true;
      SimpleHiddenDrawerProvider.of(context)
          .getMenuStateListener()
          .listen((state) {
        if (state == MenuState.open) {
          _animationController.forward();
          FocusScope.of(context).unfocus();
        }

        if (state == MenuState.closing) {
          _animationController.reverse();
          FocusScope.of(context).unfocus();
        }
      });
    }
  }
}
