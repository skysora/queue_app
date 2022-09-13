import 'dart:convert';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/TableInformation.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/DataTable/cardHeader.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/components/Dialog/CustomDialog.dart';
import 'package:shop_admin_module/screens/components/ListView/tagView.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class ShopDetailPage extends StatefulWidget {
  const ShopDetailPage({
    Key? key,
    required this.setting,
    required this.dataTableManage,
  }) : super(key: key);
  final dynamic setting;
  final MyDataTableData dataTableManage;
  @override
  State<ShopDetailPage> createState() =>
      _ShopDetailPageState(setting, dataTableManage);
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  var setting;
  late Widget? header;
  late List<Widget>? actions;
  late MyDataTableData dataTableManage;
  List<TableInformation> dataList = [];
  var data = {};
  int tagLineCount = 5;
  _ShopDetailPageState(setting, MyDataTableData dataTableManage) {
    this.setting = setting;
    this.dataTableManage = dataTableManage;
    this.header = Text(setting['objectName'], style: dataTableTitleStyle);
    this.actions = <Widget>[
      // 編輯
      Builder(builder: (BuildContext context) {
        if (this.setting['editButton'] != null) {
          return ElevatedButton(
            child: Row(
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
            onPressed: () {},
          );
        } else {
          return SizedBox();
        }
      }),
      // 新增
      Builder(builder: (BuildContext context) {
        if (this.setting['addButton'] != null) {
          return ElevatedButton(
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/add_role.png',
                  width: addButtonIconSize,
                  height: addButtonIconSize,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(this.setting['addButton'],
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
            onPressed: () {},
          );
        } else {
          return SizedBox();
        }
      }),
    ];
  }
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    // top block
    data["names"] = Server().dataToJson(
            this.dataTableManage.data[0].data["name"].toString())[0] ??
        {};
    data["names_en"] = data["names"]["en"] ?? "";
    data["names_tc"] = data["names"]["tc"] ?? "";
    data["names_sc"] = data["names"]["sc"] ?? "";
    data["email"] = dataTableManage.data[0].data["email"] ?? "";
    data["phone"] = dataTableManage.data[0].data["phone"] ?? "";
    data["tempTags"] = this.dataTableManage.data[0].data["tag"] ?? "";
    data["descriptions"] = Server().convertLanguageToJson(
            this.dataTableManage.data[0].data["description"].toString()) ??
        {};
    // down block
    data["description_en"] = data["descriptions"]["en"] ?? "";
    data["description_tc"] = data["descriptions"]["tc"] ?? "";
    data["description_sc"] = data["descriptions"]["sc"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    return Container(
      width: MediaQuery.of(context).size.width * this.setting['width'],
      height: MediaQuery.of(context).size.height * setting["height"] -
          myAppBarHeight,
      color: sideMeauBackgroudColor,
      child: Card(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // CardHeader(
              //   dataTableManage: dataTableManage,
              //   setting: setting,
              // ),
              Semantics(
                container: true,
                child: DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.w400),
                  child: IconTheme.merge(
                    data: const IconThemeData(
                      opacity: 0.54,
                    ),
                    child: Ink(
                      height: DataTableHeaderHeight,
                      // color: themeData.secondaryHeaderColor,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 24, end: 14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                                child:
                                    Text("商戶資訊", style: dataTableTitleStyle)),
                            ElevatedButton(
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/add_role.png',
                                    width: addButtonIconSize,
                                    height: addButtonIconSize,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("編輯",
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
                                var res = await CustomDialogState()
                                    .showBranchDetailEditDialogBox(
                                  context,
                                  dataTableManage,
                                  this.setting["editButton"]["objectSetting"],
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              
              // header分隔線
              Divider(color: Color(0xFFF0F0F0)),
              // Block one
              Container(
                width:
                    MediaQuery.of(context).size.width * this.setting['width'],
                padding: const EdgeInsets.all(defaultPadding),
                height: MediaQuery.of(context).size.height * 0.3,
                child: top_block(),
              ),
              // 分隔線
              Divider(color: Color(0xFFF0F0F0)),
              Container(
                padding: const EdgeInsets.all(defaultPadding),
                width:
                    MediaQuery.of(context).size.width * this.setting['width'],
                height: MediaQuery.of(context).size.height * setting["height"],
                child: down_block(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column top_block() {
    const first_block_width = 0.06;
    const second_block_width = 0.15;
    const center_block = 0.15;
    return Column(children: [
      SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * first_block_width,
                  child: Text("英文名稱",
                      style: shopDetailMeauListTitleLeadingTextStyle)),
              SizedBox(
                width: defaultPadding,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * second_block_width,
                child: Text(this.data["names_en"].toString(),
                    style: shopDetailMeauListTitleTrailingTextStyle),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * center_block,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * first_block_width,
                  child: Text("電郵地址",
                      style: shopDetailMeauListTitleLeadingTextStyle)),
              SizedBox(
                width: defaultPadding,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                child: Text(this.data["email"].toString(),
                    style: shopDetailMeauListTitleTrailingTextStyle),
              )
            ],
          )),
      Spacer(),
      SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * first_block_width,
                  child: Text("繁體中文名稱",
                      style: shopDetailMeauListTitleLeadingTextStyle)),
              SizedBox(
                width: defaultPadding,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * second_block_width,
                child: Text(this.data["names_tc"].toString(),
                    style: shopDetailMeauListTitleTrailingTextStyle),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * center_block,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * first_block_width,
                  child: Text("聯絡電話",
                      style: shopDetailMeauListTitleLeadingTextStyle)),
              SizedBox(
                width: defaultPadding,
              ),
              Text(this.data["phone"].toString(),
                  style: shopDetailMeauListTitleTrailingTextStyle)
            ],
          )),
      Spacer(),
      SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * first_block_width,
                  child: Text("簡體中文名稱",
                      style: shopDetailMeauListTitleLeadingTextStyle)),
              SizedBox(
                width: defaultPadding,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * second_block_width,
                child: Text(this.data["names_sc"].toString(),
                    style: shopDetailMeauListTitleTrailingTextStyle),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * center_block,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * first_block_width,
                  child: Text("標籤",
                      style: shopDetailMeauListTitleLeadingTextStyle)),
              SizedBox(
                width: defaultPadding,
              ),
              this.data["tempTags"].isEmpty
                  ? SizedBox()
                  : SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TagView(
                            rowLimit: tagLineCount,
                            data: this.data["tempTags"],
                          ),
                          SizedBox(
                            height: defaultPadding,
                          )
                        ],
                      ),
                    )
            ],
          )),
    ]);
  }

  Column down_block() {
    return Column(children: [
      ListTile(
        title: Text("英文描述", style: shopDetailMeauListTitleLeadingTextStyle),
      ),
      ListTile(
        title: ExpandableText(
          this.data["description_en"].toString(),
          expandText: '顯示全部',
          collapseText: '顯示部分',
          maxLines: 4,
          linkColor: Colors.blue,
        ),
      ),
      //繁體中文描述
      ListTile(
        title: Text("繁體中文描述", style: shopDetailMeauListTitleLeadingTextStyle),
      ),
      ListTile(
        title: ExpandableText(
          this.data["description_tc"].toString(),
          expandText: '顯示全部',
          collapseText: '顯示部分',
          maxLines: 4,
          linkColor: Colors.blue,
        ),
      ),
      //簡體中文描述
      ListTile(
        title: Text("簡體中文描述", style: shopDetailMeauListTitleLeadingTextStyle),
      ),
      ListTile(
        title: ExpandableText(
          this.data["description_sc"].toString(),
          expandText: '顯示全部',
          collapseText: '顯示部分',
          maxLines: 4,
          linkColor: Colors.blue,
        ),
      ),
    ]);
  }
}
