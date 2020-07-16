import 'package:flutter/material.dart';
import 'package:xenome/screens/base_widgets/base_screen.dart';
import 'package:xenome/screens/custom_widgets/custom_removable_item.dart';
import 'package:xenome/screens/custom_widgets/custom_text_form_field_without_label.dart';
import 'package:xenome/models/postion.dart';

class CreateStartScreen extends BaseScreen {
  static GlobalKey _sharedInstance = GlobalKey<_CreateStartState>();

  static GlobalKey<_CreateStartState> getInstance() {
    return _sharedInstance;
  }

  Function toggle;
  BuildContext context;

  CreateStartScreen({Key key, this.toggle, this.context})
      : super(
            key: key,
            hasBackButton: true,
            hasDoneButton: false,
            onBack: (BuildContext context) {
              toggle();
              FocusScope.of(context).unfocus();
            },
            body: CreateStart(
              toggle: toggle,
              key: _sharedInstance,
            ));
}

class CreateStart extends StatefulWidget {
  final Function toggle;

  CreateStart({this.toggle, Key key}) : super(key: key);

  @override
  _CreateStartState createState() => _CreateStartState();
}

class _CreateStartState extends State<CreateStart> {
  Position position;
  FocusNode myFocusNode;
  String title = '';
  String subTitle = '';
  String introduction = '';

  @override
  void initState() {
    super.initState();
    widget.toggle();
  }

  setTitle(String val) {
    setState(() {
      title = val;
    });
  }

  setSubTitle(String val) {
    setState(() {
      subTitle = val;
    });
  }

  setIntroduction(String val) {
    setState(() {
      introduction = val;
    });
  }

  updatePosition(double xPos, double yPos) {
    position.x = xPos;
    position.y = yPos;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.black,
        child: new Column(
          children: <Widget>[
            _simpleStack(context),
          ],
        ),
      ),
    );
  }

  Widget description = Container(
    margin: const EdgeInsets.all(30.0),
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      border: Border.all(color: Color(0xFF2B8DD8), width: 2),
    ), //       <--- BoxDecoration here
    child: Center(
      child: Column(
        children: <Widget>[
          CustomTextFormFieldWithoutLabel(
            hintTitle: 'Add a title',
            fontSize: 50.0,
            onChanged: (val) {
              CreateStartScreen.getInstance().currentState.setTitle(val);
            },
          ),
          CustomTextFormFieldWithoutLabel(
            hintTitle: 'Add a subTitle',
            fontSize: 30.0,
            onChanged: (val) {
              CreateStartScreen.getInstance().currentState.setSubTitle(val);
            },
          ),
        ],
      ),
    ),
    // Container(
    //   height: 40,
    //   child: Center(
    //     child: new Text('Add short introduction',
    //         textAlign: TextAlign.center,
    //         style: TextStyle(
    //             fontFamily: 'Roboto Medium',
    //             fontWeight: FontWeight.bold,
    //             fontSize: 17.0,
    //             color: Colors.white)),
    //   ),
    // ),
  );

  Widget _simpleStack(BuildContext context) => SingleChildScrollView(
        reverse: true,
        child: Stack(
          //fit: StackFit.expand,
          children: <Widget>[
            new InkWell(
//              onTap: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (_) => CreateChangeBg()),
//                );
//              },
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: Image.asset(
                    'assets/images/pic17.jpg',
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            CustomMoveableItem(description, position, updatePosition),
          ],
        ),
      );
}
