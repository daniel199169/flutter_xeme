import 'package:flutter/material.dart';
import 'package:xenome/models/styled_scale.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ScaleMedium extends StatefulWidget {
  //final String imageData;
  final Function update;
  final String title;
  final StyledScale styledScale;

  //EditProfileScreen(this.imageData, this.title);
  ScaleMedium({this.update, this.title, this.styledScale});

  @override
  _ScaleMediumState createState() => _ScaleMediumState();
}

class _ScaleMediumState extends State<ScaleMedium> {
  static GlobalKey _sharedInstance = GlobalKey<_ScaleMediumState>();
  Color _currentColor;
  bool pressed = true;
  double _currentSize;

  static GlobalKey<_ScaleMediumState> getInstance() {
    return _sharedInstance;
  }

  TextEditingController _titleController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = _loadTitle();
  }

  TextEditingController _loadTitle() {
    // If in edit mode then load the provided title
    switch (widget.title) {
      case "title":
        {
          return TextEditingController(text: widget.styledScale.title);
        }
        break;

      case "sub1Title":
        {
          return TextEditingController(text: widget.styledScale.sub1title);
        }
        break;

      case "sub2Title":
        {
          return TextEditingController(text: widget.styledScale.sub2title);
        }
        break;
    }
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
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(
                      top: 50.0, left: 0, bottom: 50.0, right: 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.grey,
                        //                   <--- border color
                        width: 1.0,
                      ),
                      color: Colors.transparent,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 50, left: 0, right: 0),
                      child: ListView(
                        children: <Widget>[
                          Container(
                            color: Colors.transparent,
                            height: MediaQuery.of(context).size.height - 260,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 50.0, left: 0, bottom: 50.0, right: 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: 65.0, left: 0, bottom: 0.0, right: 0),
                    child: Text(
                      '',
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
                              fontFamily: 'Roboto Medium',
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0,
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
                            fontFamily: 'Roboto Medium',
                            fontWeight: FontWeight.normal,
                            fontSize: 20.0,
                            color: Colors.white,
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
                                  backgroundColor: Colors.black,
                                  radius: 30.0,
                                ),
                                width: 62.0,
                                height: 62.0,
                                padding: const EdgeInsets.all(1.0),
                                // borde width
                                decoration: new BoxDecoration(
                                  color: Colors.white, // border color
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
                                  backgroundColor: Colors.black,
                                  radius: 30.0,
                                ),
                                width: 62.0,
                                height: 62.0,
                                padding: const EdgeInsets.all(1.0),
                                // borde width
                                decoration: new BoxDecoration(
                                  color: Colors.white, // border color
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
    final StyledScale styledScale = StyledScale(
      title: title,
      sub1title: title,
      sub2title: title,
    );

    // Check if we need to add new or edit old one
    widget.update(styledScale);

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
