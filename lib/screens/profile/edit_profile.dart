import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xenome/models/User.dart';
import 'package:xenome/screens/base_widgets/login_register_button.dart';
import 'package:xenome/firebase_services/authentication.dart';
import 'package:xenome/screens/profile/my_profile.dart';
import 'package:xenome/screens/profile/personal_info.dart';
import 'package:xenome/screens/profile/professional_sheet.dart';
import 'package:xenome/screens/custom_widgets/fade_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:path/path.dart' as Path;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = new GlobalKey<FormState>();

  String userId = '';
  String imageUrl = '';
  String fullname = '';
  String email = '';
  String birthday = '';
  String description = '';
  Gender gender = Gender.MALE;
  String tellusname = '';
  String website = '';
  String otherlink = '';
  String professional = '';
  String permission = '';
  File _image;

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
    fullname = SessionManager.getFullname();
    email = SessionManager.getEmail();
    birthday = SessionManager.getDate();
    description = SessionManager.getDescription();
    tellusname = SessionManager.getTellUsName();
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

  saveDraft() async {
//    if (!checkValidation()) return;
//    SessionManager.setUserId(this.id);
    if (validateAndSave()) {
      await saveUserInfo();
      Navigator.push(context, FadeRoute(page: MyProfile()));
    }
    setState(() {
      _formKey.currentState.reset();
    });
//    SessionManager.hasLoggedIn();
//    Navigator.pushReplacement(
//        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  Future updateImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profiles/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) {
      Auth().updateImage(fileURL, userId);
      setState(() {
        imageUrl = fileURL;
      });
    });
  }

  // Perform login or signup
  void validateAndSubmit() async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.6,
            child: Container(
              color: Color(0xFF737373),
              height: 500,
              child: Container(
                child: ProfessionalSheet(),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                ),
              ),
            ),
          );
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
                    new GestureDetector(
                      onTap: () {
                        Navigator.push(context, FadeRoute(page: MyProfile()));
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Roboto Medium',
                          color: Color(0xFF868E9C),
                        ),
                      ),
                    ),
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto Medium',
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    new GestureDetector(
                      onTap: saveDraft,
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
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.black,
        child: new Column(
          children: <Widget>[
            _buildPrimaryChild(),
            _buildFormChild(),
            _buildProfessionalButtonChild(),
            _buildLineChild(),
            _buildLinkUrlChild(),
            _buildLineChild(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryChild() => Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 5.0, 0.0, 5.0),
        child: SizedBox(
          height: 105,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new GestureDetector(
                onLongPress: () {
                  updateImage();
                },
                child: imageUrl !=
                        'https://firebasestorage.googleapis.com/v0/b/xenome-mobile.appspot.com/o/profiles%2Fuser_big_outlined%402x.png?alt=media&token=5707511f-cdcd-4bf8-b49e-fde668bcd4f5'
                    ? CircleAvatar(
                        radius: 43,
                        backgroundImage: NetworkImage(
                          imageUrl,
                          //fit: BoxFit.cover,
                        ),
                      )
                    : new CircleAvatar(
                        radius: 43,
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (BuildContext context, String url) =>
                              Image.asset(
                            'assets/icos/loader.gif',
                            height: 43,
                            width: 43,
                            fit: BoxFit.cover,
                          ),
                          width: 43,
                          height: 43,
                          fit: BoxFit.fill,
                        ),
                        backgroundColor: Color(0xFF272D3A),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 35.0, 0.0, 0.0),
                  child: Text('Change profile picture',
                      style: TextStyle(
                        fontFamily: 'Roboto Medium',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                ),
              ),
            ],
          ),
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
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                      onSaved: (value) {
                        setState(() {
                          tellusname = value.trim();
                        });
                      }),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: new BorderRadius.circular(14.0)),
                  child: TextFormField(
                    //focusNode: myEmailFocusNode,
                    maxLines: 7,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    initialValue: description,
                    style: TextStyle(
                      fontFamily: 'Roboto Reqular',
                      color: Color(0xFFFFFFFF),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Description',
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
                    onSaved: (value) => description = value.trim(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: new BorderRadius.circular(14.0)),
                  child: TextFormField(
                    //focusNode: myEmailFocusNode,
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    initialValue: website,
                    style: TextStyle(
                      fontFamily: 'Roboto Reqular',
                      color: Color(0xFFFFFFFF),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Website',
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
                    onSaved: (value) => website = value.trim(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: new BorderRadius.circular(14.0)),
                  child: TextFormField(
                    //focusNode: myEmailFocusNode,
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    initialValue: otherlink,
                    style: TextStyle(
                      fontFamily: 'Roboto Reqular',
                      color: Color(0xFFFFFFFF),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Other link',
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
                    onSaved: (value) => otherlink = value.trim(),
                  ),
                ),
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
                  Navigator.push(context, FadeRoute(page: PersonalInfo()));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 5.0, 0.0),
                  child: Text('Personal information settings',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color(0xFF868E9C),
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
                        Navigator.push(
                            context, FadeRoute(page: PersonalInfo()));
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
