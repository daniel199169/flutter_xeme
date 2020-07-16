import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xenome/firebase_services/buildder_manager.dart';
import 'package:xenome/models/image.dart';
import 'package:path/path.dart' as Path;
import 'package:xenome/utils/session_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyImage extends StatefulWidget {
  MyImage({this.id, this.type, this.subOrder});
  final String id;
  final String type;
  final String subOrder;
  @override
  _MyImageState createState() => _MyImageState();
}

class _MyImageState extends State<MyImage> {
  File _image;

  String imageURL;
  String link;
  String description;
  String tag;
  String reference;

  ImageModel data;
  TextEditingController _linkController;
  TextEditingController _descriptionController;
  TextEditingController _tagController;
  TextEditingController _referenceController;

  @override
  void initState() {
    super.initState();

    data = new ImageModel(
        imageURL: "", link: "", description: "", tag: "", reference: "");
    _linkController = TextEditingController(text: "");
    _descriptionController = TextEditingController(text: "");
    _tagController = TextEditingController(text: "");
    _referenceController = TextEditingController(text: "");

    getData();
  }

  getData() async {
    String uid = SessionManager.getUserId();

    ImageModel _data = await BuildderManager.getMyImageData(
        uid, widget.id, widget.type, int.parse(widget.subOrder));
    setState(() {
      data = _data;
      _linkController = TextEditingController(text: data.link);
      _descriptionController = TextEditingController(text: data.description);
      _tagController = TextEditingController(text: data.tag);
      _referenceController = TextEditingController(text: data.reference);
      link = data.link;
      description = data.description;
      tag = data.tag;
      reference = data.reference;
      imageURL = data.imageURL;
    });
  }

  onClose() {
    Navigator.of(context).pop();
  }

  _saveBuilder() async {
    if (imageURL != null && imageURL != '') {
      ImageModel myImage = ImageModel(
          link: link,
          imageURL: imageURL,
          description: description,
          tag: tag,
          reference: reference);
      BuildderManager.updateMyImage(myImage, SessionManager.getUserId(),
          widget.id, widget.type, int.parse(widget.subOrder));
    }
  }

  Future updateImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('xebuilds/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) {
      ImageModel myImage = ImageModel(
          link: link,
          imageURL: fileURL,
          description: description,
          tag: tag,
          reference: reference);
      BuildderManager.updateMyImage(myImage, SessionManager.getUserId(),
          widget.id, widget.type, int.parse(widget.subOrder));
      setState(() {
        imageURL = fileURL;
      });
    });
  }

  Future selectImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('xebuilds/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        imageURL = fileURL;
        _saveBuilder();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                margin: EdgeInsets.fromLTRB(25, 50, 25, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new IconButton(
                      icon: Icon(Icons.navigate_before,
                          size: 25, color: Color(0xFF868E9C)),
                      onPressed: () {
                        onClose();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(
                  40, 40, MediaQuery.of(context).size.width * 0.64, 20),
              width: 60,
              height: MediaQuery.of(context).size.height * 0.16,
              child: imageURL == null || imageURL == ""
                  ? MaterialButton(
                      onPressed: () {
                        selectImage();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconTheme(
                              data: new IconThemeData(
                                color: Color(0xFF868E9C),
                              ),
                              child: new Icon(Icons.camera_enhance),
                            ),
                            Text(
                              'Add Image',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Roboto Medium',
                                color: Color(0xFF868E9C),
                              ),
                            )
                          ],
                        ),
                      ),
                      color: Colors.transparent,
                      elevation: 0,
                      minWidth: 50,
                      height: 100,
                      textColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Color(0xFF868E9C))),
                    )
                  : new GestureDetector(
                      onLongPress: () {
                        updateImage();
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                              imageUrl: imageURL,
                              placeholder: (BuildContext context, String url) =>
                                  Image.asset(
                                    'assets/icos/loader.gif',
                                    height: 60,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                              height: 60,
                              width: 150,
                              fit: BoxFit.cover)),
                    ),
            ),
            Container(
              margin: EdgeInsets.only(top: 0, left: 40, right: 40, bottom: 0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _linkController,
                      maxLines: 3,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      style: TextStyle(
                        fontFamily: 'Roboto Reqular',
                        color: Color(0xFFFFFFFF),
                      ),
                      decoration: InputDecoration(
                        labelText: 'link',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF868E9C),
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
                      onChanged: (value) => link = value.trim(),
                      onFieldSubmitted: (_linkController) {
                        _saveBuilder();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      style: TextStyle(
                        fontFamily: 'Roboto Reqular',
                        color: Color(0xFFFFFFFF),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF868E9C),
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
                      onChanged: (value) => description = value.trim(),
                      onFieldSubmitted: (_descriptionController) {
                        _saveBuilder();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _tagController,
                      maxLines: 3,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      style: TextStyle(
                        fontFamily: 'Roboto Reqular',
                        color: Color(0xFFFFFFFF),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Tags',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF868E9C),
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
                      onChanged: (value) => tag = value.trim(),
                      onFieldSubmitted: (_tagController) {
                        _saveBuilder();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _referenceController,
                      maxLines: 3,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      style: TextStyle(
                        fontFamily: 'Roboto Reqular',
                        color: Color(0xFFFFFFFF),
                      ),
                      decoration: InputDecoration(
                        labelText: 'References',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF868E9C),
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
                      onChanged: (value) => reference = value.trim(),
                      onFieldSubmitted: (_referenceController) {
                        _saveBuilder();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
