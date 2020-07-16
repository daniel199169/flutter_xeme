import 'package:flutter/material.dart';

class BasicSwitch extends StatefulWidget {
  @override
  BasicSwitchState createState() {
    return new BasicSwitchState();
  }
}

class BasicSwitchState extends State<BasicSwitch> {
  bool _isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Switch Example"),
      ),
      body: Center(
        child: Switch(
          onChanged: (val) => setState(() => _isSwitched = val),
          value: _isSwitched,
        ),
      ),
    );
  }
}
