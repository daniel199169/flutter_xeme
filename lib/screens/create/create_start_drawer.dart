import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:xenome/screens/base_widgets/custom_show_dialog.dart';
import 'package:xenome/screens/create/create_start.dart';
import 'package:xenome/screens/create/create_starter.dart';
import 'package:xenome/screens/view/home.dart';

class CreateStartDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleHiddenDrawer(
      slidePercent: 94,
      menu: CreateStarter(),
      screenSelectedBuilder: (position, controller) {
        Widget screenCurrent;
        switch (position) {
          case 0:
            screenCurrent = CreateStart(
              toggle: controller.toggle,
            );
//                CreateStartScreen(toggle: controller.toggle, context: context);
            break;
        }
        return screenCurrent;
      },
    );
  }
}

class CreateStartLayout extends StatefulWidget {
  @override
  _CreateStartLayoutState createState() => _CreateStartLayoutState();
}

class _CreateStartLayoutState extends State<CreateStartLayout> {
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
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: PreferredSize(
        preferredSize: Size(null, 100),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.transparent, spreadRadius: 5, blurRadius: 2)
          ]),
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1.0),
            child: Container(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.fromLTRB(25, 20, 25, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new IconButton(
                        icon: Icon(Icons.navigate_before,
                            size: 25, color: Color(0xFF868E9C)),
                        onPressed: () async {
                          ConfirmAction _selAction = await CustomShowDialog(
                              context,
                              title: 'Are you going to save?',
                              content:
                                  'Please click the save to keep the draft.');
                          if (_selAction == ConfirmAction.SAVE) {
                            saveDraft();
                          }
                          if (_selAction == ConfirmAction.SAVE) {
                            goBack();
                          }
                        }),
                    new GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (_) => CreatePublish()),
                        // );
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Roboto Medium',
                          color: Color(0xFF868E9C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: CreateStartDrawer(),
    );
  }
}
