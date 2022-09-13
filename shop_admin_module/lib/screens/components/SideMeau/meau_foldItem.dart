import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:shop_admin_module/screens/setting/constants.dart';

import 'side_meau.dart';

class MenuFoldItem extends StatefulWidget {
  MenuFoldItem(
      {Key? key,
      required this.dropListModel,
      required this.onOptionSelected,
      required this.title,
      required this.svgSrc})
      : super(key: key);
  final DropListModel dropListModel;
  final Function(OptionItem optionItem) onOptionSelected;
  final String title, svgSrc;
  @override
  State<MenuFoldItem> createState() =>
      MenuFoldItemCardState(dropListModel, title, svgSrc);
}

class MenuFoldItemCardState extends State<MenuFoldItem>
    with SingleTickerProviderStateMixin {
  late final DropListModel dropListModel;

  late AnimationController expandController;
  late Animation<double> animation;
  late String title, svgSrc;
  bool isShow = false;
  late String userName = "";
  bool hiddenMenu = true;
  MenuFoldItemCardState(dropListModel, String title, String svgSrc) {
    this.dropListModel = dropListModel;
    this.title = title;
    this.svgSrc = svgSrc;
  }

  @override
  void initState() {
    super.initState();
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (isShow) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      if (hiddenMenu) {
        return Expanded(
            // default flex = 1
            // and it takes 1/6 part of the screen
            child: InkWell(
          onTap: () {
            this.isShow = !this.isShow;
            _runExpandCheck();
            setState(() {});
          },
          child: Container(
            child: Column(
              children: [
                Container(
                  child: ListTile(
                    horizontalTitleGap: 0.0,
                    leading: SvgPicture.asset(
                      svgSrc,
                      width: 16,
                      height: 16,
                      color: sideMeauIconColor,
                    ),
                    title: Text(
                      title,
                      style: TextStyle(
                          color: sideMeauTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.expand_more_outlined,
                        size: 16, color: sideMeauTextColor),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizeTransition(
                      axisAlignment: 1.0,
                      sizeFactor: animation,
                      child: Container(
                          decoration: new BoxDecoration(
                            color: sideMeauBackgroudColor,
                          ),
                          child: _buildDropListOptions(
                              dropListModel.listOptionItems, context))),
                ),
              ],
            ),
          ),
        ));
      } else {
        return SizedBox();
      }
    });
  }

  Column _buildDropListOptions(List<OptionItem> items, BuildContext context) {
    return Column(
      children: items.map((item) => _buildSubMenu(item, context)).toList(),
    );
  }

  Widget _buildSubMenu(OptionItem item, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(defaultPadding / 2),
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1)),
                  ),
                  child: DrawerListTitle(
                    title: item.title,
                    svgSrc: item.svgSrc,
                    iconColor: sideMeauIconColor,
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => item.pushScreen));
                    },
                  )),
            ),
          ],
        ),
        // onTap: () {
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (context) => item.pushScreen));
        //   isShow = false;
        //   expandController.reverse();
        //   widget.onOptionSelected(item);
        // },
      ),
    );
  }
}

class DropListModel {
  DropListModel(this.listOptionItems);
  final List<OptionItem> listOptionItems;
}

class OptionItem {
  final String svgSrc;
  final String title;
  final pushScreen;
  OptionItem(
      {required this.svgSrc, required this.title, required this.pushScreen});
}
