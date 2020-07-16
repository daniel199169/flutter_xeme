import 'package:flutter/material.dart';
import 'package:xenome/splash.dart';

class CustomDropDownButton extends StatelessWidget {
  final String label;
  final ValueChanged<String> onPressed;
  final List<String> listItems;
  final String initialValue;

  CustomDropDownButton({this.label, this.onPressed, this.listItems,
    this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(label, style: TextStyle(color: Colors.white, fontSize: 16),),
                new DropdownButton<String>(
                    style: TextStyle(
                      backgroundColor: Colors.black,
                    ),
                    value: initialValue,
                    items:
                    listItems.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Roboto Medium',
                            color: Colors.white,
                          ),),
                      );
                    }).toList(),
                    onChanged: (value){
                      onPressed(value);
                    }
                ),
              ]),
        ],
      ),
    );
  }
}
