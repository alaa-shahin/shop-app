import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'auth_screen.dart';

class SplashScreens extends StatefulWidget {
  static const routeName = '/SplashScreen';

  @override
  _SplashScreensState createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: SplashScreen(
            backgroundColor: Colors.lightBlueAccent,
            imageBackground: AssetImage('assets/images/shopping-online.jpg'),
            seconds: 3,
            loadingText: Text('Loading...'),
            loaderColor: Colors.yellow,
            navigateAfterSeconds: AuthScreen(),
          ),
        ),
      ),
    );
  }
}
