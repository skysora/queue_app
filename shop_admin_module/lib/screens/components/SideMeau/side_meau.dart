import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/ProfileCard/profileCenter.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

import 'meau_foldItem.dart';

class SideMeau extends StatefulWidget {
  SideMeau({
    Key? key,
    required this.setting,
  }) : super(key: key);
  final setting;
  @override
  _SideMeauState createState() => new _SideMeauState(setting);
}

class _SideMeauState extends State<SideMeau> {
  late var setting;

  _SideMeauState(
    setting,
  ) {
    this.setting = setting;
  }

  @override
  Widget build(BuildContext context) {
    // data get
    final sideMeauList = Server().getMeauData(setting["meauName"] ?? "");
    ScrollController _scrollController = ScrollController();
    return Container(
      width: MediaQuery.of(context).size.width * this.setting['width'],
      height: (MediaQuery.of(context).size.height - myAppBarHeight) *
              setting["height"] -
          44,
      color: sideMeauBackgroudColor,
      // it enables scorlling
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(children: [
          Builder(builder: (context) {
            switch (setting["header"]) {
              case "ProfileCardCenter":
                return SizedBox(
                  height:
                      (MediaQuery.of(context).size.height - myAppBarHeight) *
                          setting["height"] *
                          0.35,
                  width:
                      MediaQuery.of(context).size.width * this.setting['width'],
                  child: DrawerHeader(
                    child: ProfileCardCenter(
                      setting: setting,
                    ),
                  ),
                );
              default:
                return SizedBox();
            }
          }),
          for (int index = 0; index < sideMeauList.length; index++)
            Builder(builder: (BuildContext context) {
              if (sideMeauList[index]['isGroup']) {
                return MenuFoldItem(
                  dropListModel: DropListModel([
                    for (int page = 0;
                        page < sideMeauList[index]['pages'].length;
                        page++)
                      OptionItem(
                          svgSrc: sideMeauList[index]['pages'][page]["svgSrc"],
                          title: sideMeauList[index]['pages'][page]["title"],
                          pushScreen: sideMeauList[index]['pages'][page]
                              ["onPress"]),
                  ]),
                  onOptionSelected: (OptionItem optionItem) {},
                  svgSrc: sideMeauList[index]['svgSrc'].toString(),
                  title: sideMeauList[index]['title'].toString(),
                );
              } else {
                return DrawerListTitle(
                  title: sideMeauList[index]['title'].toString(),
                  svgSrc: sideMeauList[index]['onTop']
                      ? sideMeauList[index]['svgSrc_selected'].toString()
                      : sideMeauList[index]['svgSrc'].toString(),
                  iconColor: sideMeauList[index]['onTop']
                      ? sideMeauBackgroudColorSelected
                      : sideMeauIconColor,
                  press: () {
                    setState(() {
                      // clear to all sideMeau text
                      for (int index = 0;
                          index < sideMeauList.length;
                          index++) {
                        sideMeauList[index]['onTop'] = false;
                      }
                      sideMeauList[index]['onTop'] =
                          !sideMeauList[index]['onTop'];
                    });
                    Route route = MaterialPageRoute(
                        builder: (context) => sideMeauList[index]['onPress']);
                    if (!setting["replacePage"]) {
                      Navigator.push(context, route);
                    } else {
                      Navigator.pushReplacement(context, route);
                    }
                  },
                );
              }
            }),
        ]),
      ),
    );
  }
}

class DrawerListTitle extends StatelessWidget {
  const DrawerListTitle({
    Key? key,
    // for selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
    required this.iconColor,
  }) : super(key: key);

  final String title, svgSrc;
  final Color iconColor;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Image.asset(
        svgSrc,
        width: 24,
        height: 24,
      ),
      title: Text(
        title,
        style: TextStyle(color: iconColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}
