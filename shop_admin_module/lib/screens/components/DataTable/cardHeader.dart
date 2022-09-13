import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/objectFactory.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/components/Dialog/CustomDialog.dart';
import 'package:shop_admin_module/screens/components/ListView/myDropdownbutton.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class CardHeader extends StatefulWidget {
  CardHeader({
    Key? key,
    required this.setting,
    required this.dataTableManage,
  }) : super(key: key);
  final Map<String, dynamic> setting;
  final DataTableSource dataTableManage;
  @override
  _CardHeaderState createState() => _CardHeaderState(setting, dataTableManage);
}

class _CardHeaderState extends State<CardHeader> {
  late Map<String, dynamic> setting;

  late Widget? header;
  late List<Widget>? actions;
  late MyDataTableData dataTableManage;

  _CardHeaderState(setting, dataTableManage) {
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
                Text(this.setting['editButton']["objectSetting"]["objectName"],
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
                setState(() {
                  this.dataTableManage = res;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ObjectFactory().generateClass(setting["page"])),
                );
              }
            },
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
                Text(this.setting['addButton']["objectSetting"]["objectName"],
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
              var res = await CustomDialogState().showAddDialogBox(
                context,
                dataTableManage,
                this.setting["addButton"]["objectSetting"],
              );
              if (res.toString() != "cancel") {
                this.dataTableManage = res;
                if (res.toString() != "cancel") {
                  this.dataTableManage = res;
                  Route route = MaterialPageRoute(
                      builder: (context) =>
                          ObjectFactory().generateClass(setting["page"]));
                  if (setting["replacePage"] != null) {
                    Navigator.push(context, route);
                  } else {
                    Navigator.pushReplacement(context, route);
                  }
                }
              }
            },
          );
       
        } else {
          return SizedBox();
        }
      }),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    // HEADER
    final List<Widget> headerWidgets = <Widget>[];
    if (this.header != null) {
      headerWidgets.add(Expanded(child: this.header!));
    }
    if (this.actions != null) {
      headerWidgets.addAll(
        this.actions!.map<Widget>((Widget action) {
          return Padding(
            // 8.0 is the default padding of an icon button
            padding: const EdgeInsetsDirectional.only(start: 24.0 - 8.0 * 2.0),
            child: action,
          );
        }).toList(),
      );
    }
    return Semantics(
      container: true,
      child: DefaultTextStyle(
        style: themeData.textTheme.headline6!
            .copyWith(fontWeight: FontWeight.w400),
        child: IconTheme.merge(
          data: const IconThemeData(
            opacity: 0.54,
          ),
          child: Ink(
            height: DataTableHeaderHeight,
            // color: themeData.secondaryHeaderColor,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 24, end: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: headerWidgets,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
