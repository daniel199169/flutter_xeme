import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:load/load.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xenome/scoped_models/app_model.dart';
import 'package:xenome/utils/session_manager.dart';
import 'app.dart';
import 'firebase_services/build_manager.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  SessionManager.initialize(sharedPreferences);
  BuildManager.initialize(sharedPreferences);
  debugPaintSizeEnabled = false;

  runApp(ScopedModel<AppModel>(
    
    model: AppModel(sharedPreferences),
    child: LoadingProvider(
        themeData: LoadingThemeData(
          tapDismiss: false,
        ),
        child: XenomeApp()),
  ));
}
