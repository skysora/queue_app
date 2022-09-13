import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/TableInformation.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

import 'customListView.dart';

class MyListView extends StatefulWidget {
  MyListView({
    Key? key,
    required this.dataTableManage,
    required this.setting,
  }) : super(key: key);
  final MyDataTableData dataTableManage;
  final dynamic setting;
  @override
  MyListViewState createState() => MyListViewState(dataTableManage, setting);
}

class MyListViewState extends State<MyListView> {
  List<TableInformation> dataList = [];
  var setting;
  MyDataTableData dataTableManage = MyDataTableData();

  MyListViewState(MyDataTableData dataTableManage, setting) {
    this.dataTableManage = dataTableManage;
    this.setting = setting;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    return Container(
        width: MediaQuery.of(context).size.width * this.setting['width'],
        height: MediaQuery.of(context).size.height * setting["height"] -
            myAppBarHeight,
        child: SingleChildScrollView(
          child: Builder(builder: (BuildContext context) {
            this.dataList = dataTableManage.data;
            return dataTableManage.getDataList().isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  )
                : SizedBox(
                    child: CustomListView(
                      controller: _scrollController,
                      dataAPI: setting["API"]['nextAPI'],
                      setting: setting,
                      source: dataTableManage,
                      // onPageChanged: (data) async {
                      //   if (data.isEmpty) {
                      //     CostomAlterDiaglogState().showDialogBox(
                      //         context, "沒有下一頁哦", "Error Message");
                      //   } else {
                      //     setState(() {
                      //       dataTableManage.setData(
                      //           data, context, setting['api']);
                      //     });
                      //   }
                      // },
                    ),
                  );
          }),
        ));
  }
}
