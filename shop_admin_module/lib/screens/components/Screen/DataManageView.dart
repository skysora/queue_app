import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/TableInformation.dart';
import 'package:shop_admin_module/screens/Class/objectFactory.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';

class DataManageView extends StatefulWidget {
  const DataManageView({
    Key? key,
    required this.setting,
  }) : super(key: key);
  final setting;
  @override
  _DataManageViewState createState() => _DataManageViewState(setting);
}

class _DataManageViewState extends State<DataManageView> {
  var setting;
  _DataManageViewState(setting) {
    this.setting = setting;
  }
  @override
  Widget build(BuildContext context) {
    print(setting['API']);
    return FutureBuilder(
        future: fetchData(setting['API']["data"]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Get Data Error:" + snapshot.error!.toString()),
              // child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            MyDataTableData dataTableManage = MyDataTableData();
            dataTableManage.set(snapshot.data!, setting);
            dataTableManage.context = context;
            return ObjectFactory()
                .generateLoadDataObject(setting, dataTableManage);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
