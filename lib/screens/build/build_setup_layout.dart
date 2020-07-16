import 'package:flutter/material.dart';
import 'package:xenome/screens/base_widgets/custom_show_dialog.dart';
import 'package:xenome/firebase_services/build_manager.dart';
import 'package:xenome/screens/view/home.dart';
import 'package:xenome/utils/session_manager.dart';
import 'build_setup_drawer.dart';

class BuildSetupLayout extends StatefulWidget {
  @override
  _BuildSetupLayoutState createState() => _BuildSetupLayoutState();
}

class _BuildSetupLayoutState extends State<BuildSetupLayout> {
  goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Home()),
    );
  }

  saveDraft() {
    //save to the firebase? by Rpz

    BuildManager.addBuildList(SessionManager.getUserId());
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
                          if (_selAction == ConfirmAction.CANCEL) {
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
      body: BuildSetupDrawer(),
    );
  }
}
