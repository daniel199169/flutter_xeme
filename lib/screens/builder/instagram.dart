import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/buildder_manager.dart';
import 'package:xenome/models/instagram.dart';
import 'package:xenome/utils/session_manager.dart';


class Instagram extends StatefulWidget {
  Instagram({this.id, this.type, this.subOrder});
  final String id;
  final String type;
  final String subOrder;
  @override
  _InstagramState createState() => _InstagramState();
}

class _InstagramState extends State<Instagram> {
  
  String title;
  String instagramURL;
  String description;
  String tag;
  String reference;

  InstagramModel data;
  TextEditingController _titleController;
  TextEditingController _instagramURLController;
  TextEditingController _descriptionController;
  TextEditingController _tagController;
  TextEditingController _referenceController;

  @override
  void initState() {
    super.initState();

    data = new InstagramModel(
        title: "",
        instagramURL: "",
        description: "",
        tag: "",
        reference: "");
    _titleController = TextEditingController(text: "");
    _instagramURLController = TextEditingController(text: "");
    _descriptionController = TextEditingController(text: "");
    _tagController = TextEditingController(text: "");
    _referenceController = TextEditingController(text: "");

    getData();
  }

  getData() async {
    
    String uid = SessionManager.getUserId();
    InstagramModel _data = await BuildderManager.getInstagramData(
        uid, widget.id, widget.type, int.parse(widget.subOrder));
    setState(() {
      data = _data;
      _titleController = TextEditingController(text: data.title);
      _instagramURLController = TextEditingController(text: data.instagramURL);
      _descriptionController = TextEditingController(text: data.description);
      _tagController = TextEditingController(text: data.tag);
      _referenceController = TextEditingController(text: data.reference);

      title = data.title;
      instagramURL = data.instagramURL;
      description = data.description;
      tag = data.tag;
      reference = data.reference;
      
    });
  }

   onClose() {
    Navigator.of(context).pop();
  }

  _saveBuilder() async {
    if (title != null && title != '') {
      InstagramModel instagram = InstagramModel(
          title: title,
          instagramURL: instagramURL,
          description: description,
          tag: tag,
          reference: reference);
      BuildderManager.updateInstagram(instagram, SessionManager.getUserId(),
          widget.id, widget.type, int.parse(widget.subOrder));
    }
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
              margin: EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _titleController,
                      maxLines: 3,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      style: TextStyle(
                        fontFamily: 'Roboto Reqular',
                        color: Color(0xFFFFFFFF),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Title',
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
                      onChanged: (value) => title = value.trim(),
                      onFieldSubmitted: (_titleController) {
                        _saveBuilder();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _instagramURLController,
                      maxLines: 3,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      style: TextStyle(
                        fontFamily: 'Roboto Reqular',
                        color: Color(0xFFFFFFFF),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Instagram URL',
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
                      onChanged: (value) => instagramURL = value.trim(),
                      onFieldSubmitted: (_instagramURLController) {
                        _saveBuilder();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      keyboardType: TextInputType.emailAddress,
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
                      keyboardType: TextInputType.emailAddress,
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
                      keyboardType: TextInputType.emailAddress,
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
