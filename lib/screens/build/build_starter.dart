import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:xenome/screens/custom_widgets/custom_text_form_field.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:xenome/firebase_services/brand_color_manager.dart';
import 'package:xenome/screens/view/home.dart';
import 'package:xenome/utils/string_helper.dart';

class BuildStarter extends StatefulWidget {
  @override
  _BuildStarterState createState() => _BuildStarterState();
}

class _BuildStarterState extends State<BuildStarter>
    with TickerProviderStateMixin {
  int _count = 0;
  List<int> colorList = [];
  Color currentColor = Colors.amber;

  void changeColor(Color color) => setState(() => currentColor = color);

  AnimationController _animationController;
  bool initConfigState = true;

  @override
  void initState() {
    super.initState();
    getColorList();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  getColorList() async {
    List<int> _colorList = await BrandColorManager.getColorList();
    setState(() {
      colorList = _colorList;
      _count = _colorList.length;
    });
  }

  goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Home()),
    );
  }

  saveDraft() {
    //save to the firebase? by Rpz
    //goBack();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _contatos = new List.generate(
        _count, (int i) => new ContactRow(index: i, colorList: this.colorList));

    confListenerState(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        color: Colors.black,
        child: new Column(
          children: <Widget>[
            Container(
              // constraints: BoxConstraints.expand(
              //   height: MediaQuery.of(context).size.height - 150.0,
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 25,
                    margin: EdgeInsets.only(
                        top: 140, left: 30, right: 0, bottom: 0),
                    child: new Text('Initial setup',
                        style: TextStyle(
                            fontFamily: 'Roboto Black',
                            fontSize: 18.0,
                            color: Colors.white)),
                  ),
                  Container(
                    // height: 250,
                    margin:
                        EdgeInsets.only(top: 0, left: 30, right: 62, bottom: 0),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            label: 'Title',
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            label: 'Description',
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 25,
                    margin: EdgeInsets.only(
                        top: 20, left: 30, right: 0, bottom: 10),
                    child: new Text('Brand colours',
                        style: TextStyle(
                            fontFamily: 'Roboto Black',
                            fontSize: 18.0,
                            color: Colors.white)),
                  ),
                ],
              ),
            ),
            new LayoutBuilder(builder: (context, constraint) {
              final _maxHeight = constraint.biggest.height / 3;

              return new Center(
                child: new Row(
//                    mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(
                          top: 0, left: 35, right: 0, bottom: 0),
                      child: GestureDetector(
                        onTap: () {
                          _addNewContactRow();
                        },
                        child: CircleAvatar(
                          child: new Icon(Icons.add, size: 30),
                          backgroundColor: Colors.grey,
                          radius: 25.0,
                        ),
                      ),
                    ),

                    Expanded(
                      child: new Container(
                        height: 50.0,
                        margin: EdgeInsets.only(
                            top: 0, left: 10, right: 35, bottom: 0),
                        child: new ListView(
                          children: _contatos,
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                      flex: 2,
                    ),

                    //new ContactRow()
                  ],
                ),
              );
            }),
//              GestureDetector(
//                onTap: () {
//                  _addNewContactRow();
//                },
//                child:  CircleAvatar(
//                  child: new Icon(Icons.add, size: 30),
//                  backgroundColor: Colors.grey,
//                  radius: 25.0,
//
//                ),
//              ),
          ],
        ),
      ),
    );
  }

  void _addNewContactRow() {
    setState(() {
      colorList.add(colorToInt(Color(0xFFFFFF00)));
      BrandColorManager.updateColor(colorList);
    });
    setState(() {
      _count = _count + 1;
    });
  }

  void confListenerState(BuildContext context) {
    if (!initConfigState) {
      initConfigState = true;
      SimpleHiddenDrawerProvider.of(context)
          .getMenuStateListener()
          .listen((state) {
        if (state == MenuState.open) {
          _animationController.forward();
          FocusScope.of(context).unfocus();
        }

        if (state == MenuState.closing) {
          _animationController.reverse();
          FocusScope.of(context).unfocus();
        }
      });
    }
  }
}

class ContactRow extends StatefulWidget {
  final int index;
  final List<int> colorList;

  const ContactRow({Key key, this.index, this.colorList}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ContactRow();
}

class _ContactRow extends State<ContactRow> {
  Color currentColor;
  List<int> colorList;

  void changeColor(Color color) {
    colorList[widget.index] = colorToInt(color);
    BrandColorManager.updateColor(colorList);
    setState(() => currentColor = color);
  }

  @override
  void initState() {
    colorList = widget.colorList;
    currentColor = intToColor(colorList[widget.index]);
    super.initState();
  }

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
                  pickerColor: currentColor,
                  onColorChanged: changeColor,
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
      //onLongPressEnd: ,
      child: CircleAvatar(
        backgroundColor: currentColor,
        radius: 28.0,
      ),
    );
  }
}
