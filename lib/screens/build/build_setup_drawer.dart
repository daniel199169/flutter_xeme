import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'build_starter.dart';
import 'package:xenome/screens/build/build_start.dart';

class BuildSetupDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleHiddenDrawer(
      slidePercent: 94,
      menu: BuildStarter(),
      screenSelectedBuilder: (position, controller) {
        Widget screenCurrent;
        switch (position) {
          case 0:
            screenCurrent = BuildStart(
              toggle: controller.toggle,
            );
//                CreateStartScreen(toggle: controller.toggle, context: context);
            break;
        }
        return screenCurrent;
      },
    );
  }
}
