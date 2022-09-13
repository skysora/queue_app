import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/Screen/dashboardScreen.dart';
import 'package:shop_admin_module/screens/setting/api.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class CallNumberTopBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _CallNumberTopBarState createState() => _CallNumberTopBarState();
  Size get preferredSize {
    return new Size.fromHeight(myAppBarHeight);
  }
}

class _CallNumberTopBarState extends State<CallNumberTopBar> {
  late String userName = "";
  Server server = Server();
  bool hiddenMenu = true;
  _CallNumberTopBarState() {
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
      leadingWidth: 300,
      backgroundColor: headerTitleColor,
      leading: Row(
        children: [
          SizedBox(
            width: defaultPadding,
          ),
          Image.network(
            getMeauHaederIconAPI,
            width: MediaQuery.of(context).size.height * 0.05,
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          SizedBox(
            width: defaultPadding,
          ),
          Text(
            "叫號控制台",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(defaultPadding / 2.0),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(color: Colors.green),
                    shape: BoxShape.circle,
                  ),
                  height: 10.0,
                  width: 10.0,
                ),
                SizedBox(width: defaultPadding / 2),
                Text("Server",
                    style: TextStyle(fontSize: 10, color: Color(0xFF999999))),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding / 2.0),
          child: Container(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(color: Colors.red),
                    shape: BoxShape.circle,
                  ),
                  height: 10.0,
                  width: 10.0,
                ),
                SizedBox(width: defaultPadding / 2),
                Text("列印正常",
                    style: TextStyle(fontSize: 10, color: Color(0xFF999999))),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding / 2.0),
          child: IconButton(
            icon: Transform.scale(
              scale: 1.5,
              child: Image.asset('assets/icons/TV.png'),
            ),
            onPressed: () {
              Route route = MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                        api: 'shopUser/views/qrCodeView',
                        pageName: 'Qrcode',
                        rowData: '',
                      ));
              Navigator.push(context, route);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding / 2.0),
          child: IconButton(
            icon: Transform.scale(
              scale: 1.5,
              child: Image.asset('assets/icons/analysis.png'),
            ),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding / 2.0),
          child: IconButton(
            icon: Transform.scale(
              scale: 1.5,
              child: Image.asset('assets/icons/close.png'),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
