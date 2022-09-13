import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/ProfileCard/profile.dart';
import 'package:shop_admin_module/screens/setting/api.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
  Size get preferredSize {
    return Size.fromHeight(myAppBarHeight);
  }
}

class _MyAppBarState extends State<MyAppBar> {
  late String userName = "";
  Server server = Server();
  bool hiddenMenu = true;
  _MyAppBarState() {
    getUserName().then((result) {
      setState(() {
        this.userName = result.toString();
      });
    });
  }

  getUserName() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString("username")!);
    return user;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: MediaQuery.of(context).size.width * 0.15,
      backgroundColor: headerTitleColor,
      leading: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(defaultPadding / 2),
            child: Image(
              image: AssetImage(headerIconImage),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(defaultPadding / 2.0),
          child: IconButton(
            icon: Transform.scale(
              scale: 1.5,
              child: Container(
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(getProfileImageAPI)))),
            ),
            onPressed: null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding / 2.0),
          child: Center(
            child: Text(this.userName,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding / 2.0),
          child: ProfileCard(),
        ),
      ],
    );
  }
}
