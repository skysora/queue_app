import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:shop_admin_module/screens/setting/api.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class ProfileCardCenter extends StatefulWidget {
  ProfileCardCenter({
    Key? key,
    required this.setting,
  }) : super(key: key);
  final setting;
  @override
  State<ProfileCardCenter> createState() => ProfileCardCenterState(setting);
}

class ProfileCardCenterState extends State<ProfileCardCenter> {
  late String userName = "";
  late var setting;

  ProfileCardCenterState(setting) {
    this.setting = setting;
  }

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
    double width = MediaQuery.of(context).size.width * this.setting['width'];
    double height = (MediaQuery.of(context).size.height - myAppBarHeight) *
        setting["height"] *
        0.2;
    double textSize =
        MediaQuery.of(context).size.width * this.setting['width'] / 18.0;

    return Container(
      child: Column(
        children: [
          SizedBox(
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                
                Image.network(
                  getMeauHaederIconAPI,
                  width: width * 0.7,
                  height: width * 0.7,
                ),
                Container(
                  width: width * 0.35,
                  height: height * 0.20,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                        color: Color((0xFFFFE34B)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Align(
                      alignment: AlignmentDirectional.center,
                      child: Text('超級管理員',
                          style: TextStyle(
                              fontSize: textSize, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.10,
          ),
          SizedBox(
            child: Text(this.userName,
                style: TextStyle(
                    fontSize: textSize * 2, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
