import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:xenome/models/quadTitle.dart';
import 'package:xenome/firebase_services/buildder_manager.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/screens/base_widgets/alert_dialog.dart';

class QuadChart extends StatefulWidget {
  QuadChart({this.id, this.type, this.subOrder});
  final String id;
  final String type;
  final String subOrder;
  @override
  _QuadChartState createState() => _QuadChartState();
}

class _QuadChartState extends State<QuadChart>
    with SingleTickerProviderStateMixin {
  String title;
  String color;
  String labelOne;
  String labelTwo;
  String labelThree;
  String labelFour;
  String description;
  String tag;
  String reference;

  QuadTitleModel data;
  TextEditingController _titleController;
  TextEditingController _colorController;
  TextEditingController _labelOneController;
  TextEditingController _labelTwoController;
  TextEditingController _labelThreeController;
  TextEditingController _labelFourController;
  TextEditingController _descriptionController;
  TextEditingController _tagController;
  TextEditingController _referenceController;

  @override
  void initState() {
    super.initState();

    data = new QuadTitleModel(
        title: "",
        color: "",
        labelOne: "",
        labelTwo: "",
        labelThree: "",
        labelFour: "",
        description: "",
        tag: "",
        reference: "");
    _titleController = TextEditingController(text: "");
    _colorController = TextEditingController(text: "");
    _labelOneController = TextEditingController(text: "");
    _labelTwoController = TextEditingController(text: "");
    _labelThreeController = TextEditingController(text: "");
    _labelFourController = TextEditingController(text: "");
    _descriptionController = TextEditingController(text: "");
    _tagController = TextEditingController(text: "");
    _referenceController = TextEditingController(text: "");

    getData();
  }

  getData() async {
     

    QuadTitleModel _data = await BuildderManager.getQuadTitleData(
        widget.id, widget.type, int.parse(widget.subOrder));
    setState(() {
      data = _data;
      _titleController = TextEditingController(text: data.title);
      _colorController = TextEditingController(text: data.color);
      _labelOneController = TextEditingController(text: data.labelOne);
      _labelTwoController = TextEditingController(text: data.labelTwo);
      _labelThreeController = TextEditingController(text: data.labelThree);
      _labelFourController = TextEditingController(text: data.labelFour);
      _descriptionController = TextEditingController(text: data.description);
      _tagController = TextEditingController(text: data.tag);
      _referenceController = TextEditingController(text: data.reference);

      title = data.title;
      color = data.color;
      labelOne = data.labelOne;
      labelTwo = data.labelTwo;
      labelThree = data.labelThree;
      labelFour = data.labelFour;
      description = data.description;
      tag = data.tag;
      reference = data.reference;
    });
  }

  onClose() {
    Navigator.of(context).pop();
  }

  _saveBuilder() async {
    if (title != ''){
     
        QuadTitleModel quadTitle = QuadTitleModel(
          title: title,
          color: color,
          labelOne: labelOne,
          labelTwo: labelTwo,
          labelThree: labelThree,
          labelFour: labelFour,
          description: description,
          tag: tag,
          reference: reference);
      BuildderManager.updateQuadTitle(quadTitle, SessionManager.getUserId(),
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
              margin: EdgeInsets.only(top: 30, left: 40, right: 40, bottom: 0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _titleController,
                      maxLines: 1,
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
                      controller: _colorController,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      style: TextStyle(
                        fontFamily: 'Roboto Reqular',
                        color: Color(0xFFFFFFFF),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Color',
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
                      onChanged: (value) => color = value.trim(),
                      onFieldSubmitted: (_colorController) {
                        _saveBuilder();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _labelOneController,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      style: TextStyle(
                        fontFamily: 'Roboto Reqular',
                        color: Color(0xFFFFFFFF),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Label one',
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
                      onChanged: (value) => labelOne = value.trim(),
                      onFieldSubmitted: (_labelOneController) {
                        _saveBuilder();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _labelTwoController,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      style: TextStyle(
                        fontFamily: 'Roboto Reqular',
                        color: Color(0xFFFFFFFF),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Label two',
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
                      onChanged: (value) => labelTwo = value.trim(),
                      onFieldSubmitted: (_labelTwoController) {
                        _saveBuilder();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _labelThreeController,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      style: TextStyle(
                        fontFamily: 'Roboto Reqular',
                        color: Color(0xFFFFFFFF),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Label three',
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
                      onChanged: (value) => labelThree = value.trim(),
                      onFieldSubmitted: (_labelThreeController) {
                        _saveBuilder();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _labelFourController,
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      style: TextStyle(
                        fontFamily: 'Roboto Reqular',
                        color: Color(0xFFFFFFFF),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Label Four',
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
                      onChanged: (value) => labelFour = value.trim(),
                      onFieldSubmitted: (_labelFourController) {
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
