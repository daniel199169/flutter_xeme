import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:xenome/scoped_models/app_model.dart';
import 'package:xenome/splash.dart';
import 'package:xenome/theme.dart';
import 'package:xenome/splashfordynamiclink.dart';

// @override
// Widget build(BuildContext context) {
//   // TODO: implement build
//   return null;
// }

class XenomeApp extends StatelessWidget {
  String receiveDeepLink = '';

  @override
  void initState() {
    initDynamicLinks();
  }

  initDynamicLinks() async {
    await Future.delayed(Duration(seconds: 3));
    var data = await FirebaseDynamicLinks.instance.getInitialLink();
    var deepLink = data?.link;
    receiveDeepLink = deepLink.toString();
    // final queryParams = deepLink.queryParameters;
    // if (queryParams.length > 0) {
    // var userName = queryParams['userId'];
    // }
    FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
      var deepLink = dynamicLink?.link;
      receiveDeepLink = deepLink.toString();
      debugPrint('DynamicLinks onLink $deepLink');
    }, onError: (e) async {
      debugPrint('DynamicLinks onError $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ScopedModelDescendant<AppModel>(
        builder: (context, child, model) => MaterialApp(
              title: 'Xenome',
              theme: buildTheme(),
              home: receiveDeepLink != ''
                  ? SplashForDynamLinkScreen(
                      dynalink: receiveDeepLink,
                    )
                  : SplashScreen(),
            ));
  }
}
