//import 'package:device_preview/device_preview.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'pages/splash.dart';

void main() {
  runApp(const MyApp());
}

//void main() => runApp(DevicePreview(enabled: !kReleaseMode, builder: (context)=> const MyApp(),));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: true,
        //  useInheritedMediaQuery: true,
        //locale: DevicePreview.locale(context),
        //builder: DevicePreview.appBuilder,
        theme: ThemeData.dark(),
        home: const SplashPage());
  }
}
