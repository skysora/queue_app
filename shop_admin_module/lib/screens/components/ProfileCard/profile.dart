import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/ProfileCard/tooltiShape.dart';
import 'dart:convert';

import 'package:shop_admin_module/screens/components/Screen/login.dart';

class ProfileCard extends StatefulWidget {
  ProfileCard({Key? key}) : super(key: key);
  @override
  State<ProfileCard> createState() => ProfileCardState();
}

class ProfileCardState extends State<ProfileCard> {
  late String userName = "";

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: Offset(0, 50),
      icon: Transform.scale(
        scale: 1.5,
        child: Image.asset("assets/icons/keyboard_arrow_down.png"),
      ),
      shape: const TooltipShape(),
      itemBuilder: (_) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.calculate_outlined),
            title: const Text('LogOut'),
          ),
          onTap: () async {
            Server().logOut();
            runApp(MaterialApp(
              home: Scaffold(body: LogInScreen()),
            ));
          },
        ),
      ],
    );
  }
}
