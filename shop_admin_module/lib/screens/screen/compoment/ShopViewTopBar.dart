import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/components/ListView/switchView.dart';
import 'package:shop_admin_module/screens/components/Screen/dashboardScreen.dart';
import 'package:shop_admin_module/screens/setting/api.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class ShopViewTopBar extends StatefulWidget {
  ShopViewTopBar({
    Key? key,
    required this.setting,
    required this.dataTableManage,
  }) : super(key: key);
  final setting;
  final MyDataTableData dataTableManage;
  @override
  State<ShopViewTopBar> createState() =>
      ShopViewTopBarState(setting, dataTableManage);
}

class ShopViewTopBarState extends State<ShopViewTopBar> {
  late var setting;
  late MyDataTableData dataTableManage;

  ShopViewTopBarState(setting, MyDataTableData dataTableManage) {
    this.setting = setting;
    this.dataTableManage = dataTableManage;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = dataTableManage.data[0].data;
    var names = Server().convertLanguageToJson(
        this.dataTableManage.data[0].data["name"].toString());
    //convert descriptions to json type
    var status = "";
    return Container(
      width: MediaQuery.of(context).size.width * this.setting['width'],
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: defaultPadding,
          ),
          Image.network(
            getMeauHaederIconAPI,
            width: MediaQuery.of(context).size.height * 0.10,
            height: MediaQuery.of(context).size.height * 0.10,
          ),
          SizedBox(
            width: defaultPadding,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.62,
            child: Text(names["tc"].toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            child: Text(status),
          ),
          Builder(builder: (BuildContext context) {
            return SwitchView(
              status: data["status"].toString(),
              setting: setting,
              data: data,
              dataManager: this.dataTableManage,
              keyword: "status",
            );
          }),
          //垂直分割線
          Padding(
            padding: const EdgeInsets.all(1),
            child: SizedBox(
              width: 1,
              height: MediaQuery.of(context).size.height * 0.05,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFF0F0F0)),
              ),
            ),
          ),
          SizedBox(
            width: defaultPadding,
          ),
          ElevatedButton(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/icon_accessController.png',
                    width: addButtonIconSize,
                    height: addButtonIconSize,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("進入叫號控制台",
                      style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color((0xFF38B2FF)),
              padding: EdgeInsets.all(defaultPadding),
            ),
            onPressed: () {
              // CallNumberView
              Route route = MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                        api: 'shopUser/views/callNumber',
                        pageName: 'callNumber',
                        rowData: '',
                      ));
              Navigator.push(context, route);
              // if (!setting["replacePage"]) {
              //   Navigator.push(context, route);
              // } else {
              //   Navigator.pushReplacement(context, route);
              // }
            },
          ),
        ],
      ),
    );
  }
}
