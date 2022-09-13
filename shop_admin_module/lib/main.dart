// import 'package:bugsnag_crashlytics/bugsnag_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_admin_module/screens/screen/pageSetting/mainScreen.dart';

import 'screens/components/Screen/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

//   // pass your key api of bugsnag to the plugin to setup
//   BugsnagCrashlytics.instance.register(
//       androidApiKey: "27db72a838537273988b0ef375f5ded8",
//       iosApiKey: "27db72a838537273988b0ef375f5ded8",
//       releaseStage: 'UAT',
//       appVersion: 'pad-0.0.1(2)');

//   // Pass all uncaught errors from the framework to Crashlytics.
//   FlutterError.onError = BugsnagCrashlytics.instance.recordFlutterError;
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.iOS: createTransition(),
            TargetPlatform.android: createTransition(),
            TargetPlatform.macOS: createTransition(),
            TargetPlatform.linux: createTransition(),
            TargetPlatform.windows: createTransition(),
          },
        ),
      ),
      routes: {
        '/': (context) => CheckAuth(),
      },
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var _isLogin = localStorage.getString('keepLogin').toString();
    print(_isLogin);
    if (_isLogin == "true") {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (isAuth) {
      child = MainScreen();
    } else {
      child = LogInScreen();
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: child,
    );
  }
}

PageTransitionsBuilder createTransition() {
  return FadeUpwardsPageTransitionsBuilder();
}
