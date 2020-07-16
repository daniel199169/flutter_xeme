import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  final String appBarTitle;
  final bool hasBackButton;
  final bool hasDoneButton;
  final Widget body;
  final Function onDone;
  final Function onBack;

  const BaseScreen(
      {Key key,
      this.onDone,
      this.onBack,
      this.appBarTitle = "Example",
      this.hasBackButton = false,
      this.hasDoneButton = false,
      this.body = const Text(
        "Empty Screen",
      )})
      : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: PreferredSize(
          preferredSize: Size(null, 100),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.transparent, spreadRadius: 5, blurRadius: 2)
            ]),
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1.0),
              child: Container(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 20, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: widget.hasBackButton,
                        child: new IconButton(
                            icon: Icon(Icons.navigate_before,
                                size: 25, color: Color(0xFF868E9C)),
                            onPressed: () {
                              widget.onBack(context);
                            }),
                      ),
                      Visibility(
                        visible: widget.hasDoneButton,
                        child: new GestureDetector(
                          onTap: () {
                            widget.onDone(context);
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: widget.body);
  }
}
