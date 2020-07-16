import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/brand_color_manager.dart';
import 'package:xenome/models/styled_text.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:xenome/utils/string_helper.dart';

class BuildMedium extends StatefulWidget {
  //final String imageData;
  final Function update;
  final String title;
  final StyledText styledText;

  //EditProfileScreen(this.imageData, this.title);
  BuildMedium({this.update, this.title, this.styledText});

  @override
  _BuildMediumState createState() => _BuildMediumState();
}

class _BuildMediumState extends State<BuildMedium> {
  static GlobalKey _sharedInstance = GlobalKey<_BuildMediumState>();
  Color _currentColor;
  bool pressed = true;
  double _currentSize;
  List<int> colorList = [];
  int _count = 0;
  int _i = 0;

  getColorList() async {
    List<int> _colorList = await BrandColorManager.getColorList();
    setState(() {
      colorList = _colorList;
      _count = _colorList.length;
    });
  }

  static GlobalKey<_BuildMediumState> getInstance() {
    return _sharedInstance;
  }

  TextEditingController _titleController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = _loadTitle();
    if (widget.title == "title") {
      _currentColor = widget.styledText.color;
      pressed = widget.styledText.isBold;
      _currentSize = widget.styledText.size;
    } else {
      _currentColor = widget.styledText.subColor;
      pressed = widget.styledText.isSubBold;
      _currentSize = widget.styledText.subSize;
    }

    this.getColorList();
  }

  TextEditingController _loadTitle() {
    // If in edit mode then load the provided title
    return widget.title == "title"
        ? TextEditingController(text: widget.styledText.title)
        : TextEditingController(text: widget.styledText.subTitle);
  }

  onClose() {
    Navigator.of(context).pop();
  }

  changeColor(Color color) {
    setState(() {
      _currentColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(top: 50.0, left: 0, bottom: 50.0, right: 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: Image.asset(
                    'assets/images/pic17.jpg',
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: 25.0, left: 0, bottom: 0.0, right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_i < _count) {
                                  _currentColor = intToColor(colorList[_i]);
                                } else {
                                  _currentColor = intToColor(colorList[0]);
                                }
                                _i++;
                              });
                            },
                            child: new Container(
                              width: 42.0,
                              height: 42.0,
                              padding: const EdgeInsets.all(6.0),
                              // borde width
                              decoration: new BoxDecoration(
                                color: Colors.black, // border color
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                backgroundColor: _currentColor,
                                //backgroundColor: widget.currentColor,
                                radius: 18.0,
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        ButtonTheme(
                          minWidth: 20.0,
                          height: 40.0,
                          child: RaisedButton(
                            color: Colors.black,
                            textColor: Colors.white,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                              setState(() {
                                pressed = !pressed;
                              });
                            },
                            child: Text('Bold'),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_currentSize < 90.0) {
                                _currentSize = _currentSize + 10.0;
                              } else {
                                _currentSize = 10.0;
                              }
                            });
                          },
                          child: CircleAvatar(
                            child: new Icon(Icons.text_fields, size: 30),
                            backgroundColor: Colors.black,
                            radius: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Expanded(
                    flex: 1,
                    child: Center(
                      child: Container(
                        child: TextFormField(
                          controller: _titleController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Enter Here...',
                            hintStyle: TextStyle(
                              fontFamily: 'Roboto Black',
                              fontWeight:
                                  pressed ? FontWeight.bold : FontWeight.normal,
                              fontSize: _currentSize,
                              color: Colors.white,
                            ),
                            disabledBorder: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                              //borderSide:
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Roboto Reqular',
                            fontWeight:
                                pressed ? FontWeight.bold : FontWeight.normal,
                            fontSize: _currentSize,
                            color: _currentColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 0, bottom: 20.0, right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              onClear(context);
                            },
                            child: new Container(
                                child: new CircleAvatar(
                                  child: new Icon(Icons.clear, size: 25),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Color(0xFF2B8DD8),
                                  radius: 30.0,
                                ),
                                width: 62.0,
                                height: 62.0,
                                padding: const EdgeInsets.all(2.0),
                                // borde width
                                decoration: new BoxDecoration(
                                  color: Colors.black, // border color
                                  shape: BoxShape.circle,
                                ))),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                            onTap: () {
                              onSave(context);
                            },
                            child: new Container(
                                child: new CircleAvatar(
                                  child: new Icon(Icons.check, size: 25),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Color(0xFF2B8DD8),
                                  radius: 30.0,
                                ),
                                width: 62.0,
                                height: 62.0,
                                padding: const EdgeInsets.all(2.0),
                                // borde width
                                decoration: new BoxDecoration(
                                  color: Colors.black, // border color
                                  shape: BoxShape.circle,
                                ))),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  void onClear(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onSave(BuildContext context) {
    final String title = _titleController.text;
    final StyledText styledText = StyledText(
      title: title,
      subTitle: title,
      color: _currentColor,
      subColor: _currentColor,
      size: _currentSize,
      subSize: _currentSize,
      isBold: pressed ? true : false,
      isSubBold: pressed ? true : false,
    );

    // Check if we need to add new or edit old one
    widget.update(styledText);

    Navigator.pop(context);
  }
}

class ContactRow extends StatefulWidget {
  ValueChanged<Color> changeColor;
  Color currentColor;

  ContactRow(this.changeColor, this.currentColor);

  @override
  State<StatefulWidget> createState() => new _ContactRow();
}

class _ContactRow extends State<ContactRow> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              titlePadding: const EdgeInsets.all(0.0),
              contentPadding: const EdgeInsets.all(0.0),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: widget.currentColor,
                  onColorChanged: widget.changeColor,
                  colorPickerWidth: 300.0,
                  pickerAreaHeightPercent: 0.7,
                  enableAlpha: true,
                  displayThumbColor: true,
                  enableLabel: true,
                  paletteType: PaletteType.hsv,
                ),
              ),
            );
          },
        );
      },
      child: CircleAvatar(
        backgroundColor: widget.currentColor,
        radius: 28.0,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
