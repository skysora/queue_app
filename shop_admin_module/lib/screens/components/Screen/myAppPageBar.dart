import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/setting/api.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class MyAppPageBar extends StatefulWidget implements PreferredSizeWidget {
  MyAppPageBar({
    Key? key,
    required this.setting,
  }) : super(key: key);
  final setting;
  @override
  _MyAppPageBarState createState() => _MyAppPageBarState(setting);
  Size get preferredSize {
    return new Size.fromHeight(myAppBarHeight);
  }
}

class _MyAppPageBarState extends State<MyAppPageBar> {
  late String userName = "";
  Server server = Server();
  bool hiddenMenu = true;
  late var setting;
  _MyAppPageBarState(setting) {
    getUserName().then((String result) {
      setState(() {
        this.userName = result;
      });
    });
    this.setting = setting;
  }
  Future<String> getUserName() async {
    var response;
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      Map<String, dynamic> user = jsonDecode(localStorage.getString("user")!);
      response = user['username'];
    } catch (error) {
      response = "default";
    }
    return response;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pop();
          // back 初始化程式
          for (int index = 0; index < shopMeau.length; index++) {
            shopMeau[index]['onTop'] = false;
          }
          shopMeau[0]['onTop'] = true;
        },
      ),
      backgroundColor: headerTitleColor,
      title: Text(setting["objectName"],
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }
}
