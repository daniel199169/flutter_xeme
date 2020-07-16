import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xenome/screens/base_widgets/base_screen.dart';
import 'package:xenome/screens/custom_widgets/custom_removable_item.dart';
import 'package:xenome/models/postion.dart';
import 'package:xenome/models/styled_text.dart';
import 'package:xenome/firebase_services/build_manager.dart';
import 'package:xenome/screens/build/build_medium.dart';
import 'package:xenome/utils/session_manager.dart';
import 'package:xenome/utils/string_helper.dart';


class BuildStartScreen extends BaseScreen {
  static GlobalKey _sharedInstance = GlobalKey<_BuildStartState>();

  static GlobalKey<_BuildStartState> getInstance() {
    return _sharedInstance;
  }

  Function toggle;
  BuildContext context;

  BuildStartScreen({Key key, this.toggle, this.context})
    : super(
      key: key,
      hasBackButton: true,
      hasDoneButton: false,
      onBack: (BuildContext context) {
        toggle();
        FocusScope.of(context).unfocus();
      },
      body: BuildStart(
        toggle: toggle,
        key: _sharedInstance,
      )
  );
}

class BuildStart extends StatefulWidget {
  final Function toggle;
  BuildStart({this.toggle, Key key}) : super(key: key);
  @override
  _BuildStartState createState() => _BuildStartState();
}

class _BuildStartState extends State<BuildStart> {
  Position position;
  List<double> positionList;
  FocusNode myFocusNode;
  String imageData = '';
  StyledText _styledText;
  File _image;
  String title = "Title";
  String subtitle = "Subtitle";
  var titleList = [];
  var subTitlelist = [];
  String uid = "";

  getTitle() async{
    var titleList = await BuildManager.getTitle(uid);
    title = titleList[0];
    setState(() {
      _styledText.title = titleList[0];
      _styledText.color = intToColor(titleList[1]);
      _styledText.size = titleList[2].toDouble();
      _styledText.isBold = titleList[3];

    });
  }

  getSubtitle() async{
    var subTitlelist = await BuildManager.getSubtitle(uid);
    subtitle = subTitlelist[0];
    setState(() {
      _styledText.subTitle = subTitlelist[0];
      _styledText.subColor = intToColor(subTitlelist[1]);
      _styledText.subSize = subTitlelist[2].toDouble();
      _styledText.isSubBold = subTitlelist[3];

    });
  }
  getPositionList() async{
    List<double> positionList = await BuildManager.getPositionList(uid);
    BuildManager.savePositionList(positionList);
    setState(() {
      position.x = -1.142578125;
      position.y = 47.79910714285717;
    });
  }

  Future getImage() async {
    String filePath = await BuildManager.getImage(uid);
    BuildManager.updateImage(filePath, uid);
    File image = await getFile(filePath);
    setState(() {
      _image = image;
    });

  }

  Future<File> getFile(String path) async {
    return File(path);
  }

  @override
  void initState() {
    super.initState();
    widget.toggle();
    _styledText = new StyledText(
        title: this.title,
        subTitle: this.subtitle,
        color: Color(0xffffff66),
        subColor: Color(0xffffff66),
        size: 50.0,
        subSize: 30.0,
        isBold: true,
        isSubBold: true
    );
    uid = SessionManager.getUserId();

    getTitle();
    getSubtitle();
    getPositionList();
    getImage();
  }

  _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => DetailsMenu()),
    // );
  }

  Future updateImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    List<String> realPath = image.toString().split("File: '");
    BuildManager.updateImage(realPath[1].substring(0, realPath[1].length-1), uid);
    File upimage = await getFile(realPath[1].substring(0, realPath[1].length-1));

    setState(() {
      _image = upimage;
    });
  }

  void _updateTitle(StyledText styledText) {
    setState(() {
      _styledText.title = styledText.title;
      _styledText.color = styledText.color;
      _styledText.size = styledText.size;
      _styledText.isBold = styledText.isBold;
      titleList.clear();
      titleList.add(styledText.title);
      titleList.add(colorToInt(styledText.color));
      titleList.add(styledText.size);
      titleList.add(styledText.isBold);
      BuildManager.updateTitle(titleList, uid);
      BuildManager.saveTitleList(titleList);
    });
  }

  void _updateSubTitle(StyledText styledText) {
    setState(() {
      _styledText.subTitle = styledText.subTitle;
      _styledText.subColor = styledText.subColor;
      _styledText.subSize = styledText.subSize;
      _styledText.isSubBold = styledText.isSubBold;
      subTitlelist.clear();
      subTitlelist.add(styledText.title);
      subTitlelist.add(colorToInt(styledText.color));
      subTitlelist.add(styledText.size);
      subTitlelist.add(styledText.isBold);
      BuildManager.updateSubtitle(subTitlelist, uid);
      BuildManager.saveSubTitleList(subTitlelist);
    });
  }

  updatePosition(double xPos, double yPos) {
    position.x = xPos;
    position.y = yPos;

    positionList.clear();
    positionList.add(xPos);
    positionList.add(yPos);
    BuildManager.savePositionList(positionList);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.black,
        child: new Column(
          children: <Widget>[
            _simpleStack(context),
          ],
        ),
      ),
    );
  }

  Widget description(BuildContext context){
    return  Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.grey,
            width: 1
        ),

      ),//       <--- BoxDecoration here
      child: Center(
        child: Column(
          children: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => BuildMedium(
                        update: _updateTitle,
                        title: "title",
                        styledText: _styledText,
                      ),
                  ),
                );
              },
              child: Text(
                _styledText.title,
                style: TextStyle(
                    fontFamily: 'Roboto Black',
                    fontWeight: _styledText.isBold
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: _styledText.size,
                    color: _styledText.color
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => BuildMedium(
                      update: _updateSubTitle,
                      title: "subTitle",
                      styledText: _styledText,
                    ),
                  ),
                );
              },
              child: Text(
                _styledText.subTitle,
                style: TextStyle(
                    fontFamily: 'Roboto Black',
                    fontWeight: _styledText.isSubBold
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: _styledText.subSize,
                    color: _styledText.subColor
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _simpleStack(BuildContext context) => SingleChildScrollView(
        reverse: true,
        child: Stack(
          //fit: StackFit.expand,
          children: <Widget>[
            new InkWell(
              onLongPress: () {
                updateImage();
              },
              child: Container(
                child: GestureDetector(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: _image != null ?
                    Image.file(_image,
                        height: MediaQuery.of(context).size.height *0.8,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover
                    ) :
                    Image.asset('assets/images/pic17.jpg',
                        height: MediaQuery.of(context).size.height *0.8,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover)
                    ,
                  ),
                  onHorizontalDragUpdate: (DragUpdateDetails update) =>
                      _onDragUpdate(context, update),
                ),


              ),
            ),
            CustomMoveableItem(description(context), position, updatePosition),
          ],
        ),
      );
}
