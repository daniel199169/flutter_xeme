import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:xenome/screens/custom_widgets/custom_dropdown.dart';
import 'package:xenome/models/User.dart';
import 'package:xenome/screens/base_widgets/custom_show_dialog.dart';
import 'package:xenome/screens/base_widgets/login_register_button.dart';
import 'package:xenome/firebase_services/authentication.dart';
import 'package:xenome/firebase_services/trending_manager.dart';
import 'package:xenome/models/trending.dart';
import 'package:xenome/screens/builder/builder_starter.dart';
import 'package:xenome/screens/custom_widgets/custom_text_form_field.dart';
import 'package:xenome/screens/profile/edit_profile.dart';
import 'package:xenome/screens/view/home.dart';
import 'package:xenome/screens/view/search.dart';
import 'package:xenome/utils/constant.dart';
import 'package:xenome/utils/date_utils.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/screens/custom_widgets/fade_transition.dart';

class PersonalInfo extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final _formKey = new GlobalKey<FormState>();

  String userId = '';
  String imageUrl = '';
  String tellusname = '';
  String fullname = '';
  String email = '';
  String birthday = '';
  String description = '';
  Gender gender = Gender.MALE;
  String website = '';
  String otherlink = '';
  String professional = '';
  String permission = '';
  DateTime dom = DateTime.now();

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    userId = SessionManager.getUserId();
    imageUrl = SessionManager.getImage();
    tellusname = SessionManager.getTellUsName();
    fullname = SessionManager.getFullname();
    email = SessionManager.getEmail();
    gender = SessionManager.getGender();
    birthday = SessionManager.getDate();
    description = SessionManager.getDescription();
    website = SessionManager.getWebsite();
    otherlink = SessionManager.getOtherlink();
    professional = SessionManager.getProfessional();
    permission = SessionManager.getPermission();
  }

  Future<void> saveUserInfo() async {
    User newUser = new User(
        userId,
        tellusname,
        email,
        imageUrl,
        gender,
        birthday,
        description,
        fullname,
        website,
        otherlink,
        professional,
        permission);

    try {
      bool _res = await Auth().setUserInfo(newUser);
      if (_res) {
        SessionManager.saveUserInfoToLocal(newUser);
      } else {
//        Global.showToastMessage(context: context, msg:'Something went wrong');
      }
    } catch (e) {
      print(e);
    }
  }

  // Perform login or signup
  void validateAndSubmit() async {}

  goBack() {
    Navigator.push(context, FadeRoute(page: EditProfile()));
  }

  saveDraft() async {
    if (validateAndSave()) {
      await saveUserInfo();
      Navigator.push(context, FadeRoute(page: EditProfile()));
    }
    setState(() {
      _formKey.currentState.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
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
                margin: EdgeInsets.fromLTRB(25, 30, 25, 0),
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
                    Text(
                      'Personal information',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto Medium',
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    new Text(' '),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.black,
        child: new Column(
          children: <Widget>[
            _buildCommentChild(),
            _buildFormChild(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentChild() => Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 25.0),
        child: Text(
          'This won\'t be part of your public profile.',
          textAlign: TextAlign.start,
          style: TextStyle(
              fontSize: 15,
              fontFamily: 'Roboto Medium',
              color: Color(0xFF868E9C)),
        ),
      );

  Widget _buildFormChild() => Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
        child: Form(
          key: _formKey,
          //autovalidate: _autoValidate,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: new BorderRadius.circular(14.0)),
                  child: TextFormField(
                    //focusNode: myEmailFocusNode,
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    initialValue: fullname,
                    style: TextStyle(
                      fontFamily: 'Roboto Reqular',
                      color: Color(0xFFFFFFFF),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Full name',
                      labelStyle: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF868E9C),
                        //color: myEmailFocusNode.hasFocus ? Color(0xFFFFFFFF) : Color(0xFF868E9C)
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFFFFFFFF),
                            style: BorderStyle.solid),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFF868E9C),
                            style: BorderStyle.solid),
                      ),
                    ),
                    //validator: _validateEmail,
                    onSaved: (value) => fullname = value.trim(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: new BorderRadius.circular(14.0)),
                  child: TextFormField(
                    //focusNode: myEmailFocusNode,
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    initialValue: tellusname,
                    style: TextStyle(
                      fontFamily: 'Roboto Reqular',
                      color: Color(0xFFFFFFFF),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Display name',
                      labelStyle: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF868E9C),
                        //color: myEmailFocusNode.hasFocus ? Color(0xFFFFFFFF) : Color(0xFF868E9C)
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFFFFFFFF),
                            style: BorderStyle.solid),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFF868E9C),
                            style: BorderStyle.solid),
                      ),
                    ),
                    //validator: _validateEmail,
                    onSaved: (value) => tellusname = value.trim(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.black,
                    borderRadius: new BorderRadius.circular(14.0),
                    border: Border.all(
                        width: 1,
                        color: Color(0xFF868E9C),
                        style: BorderStyle.solid),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: CustomDropDownButton(
                      label: 'Gender: ',
                      initialValue: genderToString(gender),
                      listItems: ['male', 'female'],
                      onPressed: (value) {
                        var _gender = genderFromString(value);
                        setState(() {
                          gender = _gender;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Column(children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    // child: Card(

                    //   // elevation: 10,
                    //   shape: customButtonShape,
                    //   color: Colors.black,
                    child: InkWell(
                      onTap: () {
                        DateUtils.pickDOM(
                                context: context,
                                initialDate: dom,
                                firstDate: DateTime(1900, 1, 1))
                            .then((DateTime dateTime) {
                          if (dateTime != null) {
                            setState(() {
                              this.dom = dateTime;
                              birthday = DateUtils.getTimeStringWithFormat(
                                  dateTime: dom, format: DateFormat);
                            });
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 0),
                        decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(14.0),
                            border: Border.all(
                                width: 1,
                                color: Color(0xFF868E9C),
                                style: BorderStyle.solid)),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Date of Birth: $birthday',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        alignment: Alignment(-1.0, 0),
                      ),
                    ),
                    // ),
                  )
                ]),
              ),
            ],
          ),
        ),
      );

  Widget _buildProfessionalButtonChild() => Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 15.0),
        child: LoginRegisterButton(
          title: 'Create a professional account',
          onPressed: validateAndSubmit,
        ),
      );

  Widget _buildLinkUrlChild() => Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(builder: (_) => CreateDistribution()),
//                              );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0.0),
                  child: Text('Personal information settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 15,
                      )),
                ),
              ),
              flex: 12,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: IconTheme(
                  data: new IconThemeData(color: Color(0xFF868E9C)),
                  child: new IconButton(
                      icon: Icon(Icons.arrow_forward_ios,
                          size: 15, color: Color(0xFF868E9C)),
                      onPressed: () {
                        //                              Navigator.push(
                        //                                context,
                        //                                MaterialPageRoute(builder: (_) => Search()),
                        //                              );
                      }),
                ), // myIcon is a 48px-wide widget.
              ),
              flex: 1,
            ),
          ],
        ),
      );

  Widget _buildLineChild() => Container(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        height: 0.5,
        color: Colors.grey,
      );
}
