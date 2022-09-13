import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/TableInformation.dart';
import 'package:shop_admin_module/screens/Class/objectFactory.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/components/Dialog/CustomDialog.dart';
import 'package:shop_admin_module/screens/components/ListView/tagView.dart';
import 'package:shop_admin_module/screens/setting/api.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';
import 'package:expandable_text/expandable_text.dart';

class ShopListViewSideBar extends StatefulWidget {
  ShopListViewSideBar({
    Key? key,
    required this.setting,
    required this.dataTableManage,
  }) : super(key: key);
  final setting;
  final MyDataTableData dataTableManage;
  @override
  _ShopListViewSideBarState createState() =>
      _ShopListViewSideBarState(setting, dataTableManage);
}

class _ShopListViewSideBarState extends State<ShopListViewSideBar> {
  // basis
  List<TableInformation> dataList = [];
  String dataAPI = "";
  late var setting;
  late MyDataTableData dataTableManage;

  bool hiddenMenu = true;
  final Server server = Server();
  _ShopListViewSideBarState(setting, dataTableManage) {
    this.setting = setting;
    this.dataTableManage = dataTableManage;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width * this.setting['width'],
        height: (MediaQuery.of(context).size.height - myAppBarHeight) *
            setting["height"],
        child: Stack(
          children: <Widget>[
            sideBar(),
          ],
        ),
      ),
    );
  }

  Container sideBar() {
    //convert names to json type
    var names = Server().convertLanguageToJson(
        this.dataTableManage.data[0].data["name"].toString());
    //convert descriptions to json type
    var descriptions = Server().convertLanguageToJson(
        this.dataTableManage.data[0].data["description"].toString());
    int tagLineCount = 3;
    return Container(
      width: MediaQuery.of(context).size.width * this.setting['width'],
      height: MediaQuery.of(context).size.height - myAppBarHeight - 6,
      color: sideMeauBackgroudColor,
      child: SingleChildScrollView(
        // it enables scorlling
        child: Column(children: [
          SizedBox(
            height: 100,
            child: Container(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                children: [
                  Image.network(getMeauHaederIconAPI),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  Text(names["tc"].toString(),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                ],
              ),
            ),
          ),
          Divider(color: Color(0xFFF0F0F0)),
          SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ListTile(
                  title: Text('商戶資訊',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Text("英文名稱",
                      style: shopDetailMeauListTitleLeadingTextStyle),
                  trailing: Text(names["en"].toString(),
                      style: shopDetailMeauListTitleTrailingTextStyle),
                ),
                ListTile(
                  leading: Text("繁體中文名稱",
                      style: shopDetailMeauListTitleLeadingTextStyle),
                  trailing: Text(names["tc"].toString(),
                      style: shopDetailMeauListTitleTrailingTextStyle),
                ),
                ListTile(
                  leading: Text("簡體中文名稱",
                      style: shopDetailMeauListTitleLeadingTextStyle),
                  trailing: Text(names["sc"].toString(),
                      style: shopDetailMeauListTitleTrailingTextStyle),
                ),
                ListTile(
                  leading: Text("電郵地址",
                      style: shopDetailMeauListTitleLeadingTextStyle),
                  trailing: Text(
                      this.dataTableManage.data[0].data["email"].toString(),
                      style: shopDetailMeauListTitleTrailingTextStyle),
                ),
                ListTile(
                  leading: Text("聯絡電話",
                      style: shopDetailMeauListTitleLeadingTextStyle),
                  trailing: Text(
                      this.dataTableManage.data[0].data["phone"].toString(),
                      style: shopDetailMeauListTitleTrailingTextStyle),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: defaultPadding,
                    ),
                    Text("標籤", style: shopDetailMeauListTitleLeadingTextStyle),
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                              this.setting['width'] -
                          (tagLineCount + 1) * 55,
                    ),
                    SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TagView(
                              data: this.dataTableManage.data[0].data["tag"],
                              rowLimit: tagLineCount),
                          SizedBox(
                            height: defaultPadding,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                //英文描述
                ListTile(
                  title: Text("英文描述",
                      style: shopDetailMeauListTitleLeadingTextStyle),
                ),
                ListTile(
                  title: ExpandableText(
                    descriptions["en"].toString(),
                    expandText: '顯示全部',
                    collapseText: '顯示部分',
                    maxLines: 4,
                    linkColor: Colors.blue,
                  ),
                ),
                //繁體中文描述
                ListTile(
                  title: Text("繁體中文描述",
                      style: shopDetailMeauListTitleLeadingTextStyle),
                ),
                ListTile(
                  title: ExpandableText(
                    descriptions["tc"].toString(),
                    expandText: '顯示全部',
                    collapseText: '顯示部分',
                    maxLines: 4,
                    linkColor: Colors.blue,
                  ),
                ),
                //簡體中文描述
                ListTile(
                  title: Text("簡體中文描述",
                      style: shopDetailMeauListTitleLeadingTextStyle),
                ),
                ListTile(
                  title: ExpandableText(
                    descriptions["sc"].toString(),
                    expandText: '顯示全部',
                    collapseText: '顯示部分',
                    maxLines: 4,
                    linkColor: Colors.blue,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            child: Container(
              padding: const EdgeInsets.all(defaultPadding),
              child: Builder(builder: (BuildContext context) {
                if (this.setting['editButton'] != null) {
                  return ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(this.setting['editButton'],
                            style: TextStyle(
                                color: Color(0xFF6C5231),
                                fontSize: addButtonTextSize,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color((0xFFFFE34B)),
                      padding: EdgeInsets.all(defaultPadding),
                    ),
                    onPressed: () async {
                      var res = await CustomDialogState().showEditDialogBox(
                        context,
                        0,
                        this.dataTableManage,
                        setting,
                      );
                      if (res.toString() != "cancel") {
                        this.dataTableManage = res;
                        Route route = MaterialPageRoute(
                            builder: (context) =>
                                ObjectFactory().generateClass(setting["page"]));
                        Navigator.pushReplacement(context, route);
                      }
                    },
                  );
                } else {
                  return SizedBox();
                }
              }),
            ),
          ),
        ]),
      ),
    );
  }
}
