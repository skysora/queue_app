import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/objectFactory.dart';
import 'package:shop_admin_module/screens/Class/server.dart';


// ignore: must_be_immutable
class DashboardPage extends StatelessWidget {
  late String pageName;
  String rowData = "";
  String API = "";
  List columns = [];
  bool hiddenMenu = true;
  @override
  DashboardPage(
    String pageName,
    String rowData,
    String API,
  ) {
    this.pageName = pageName;
    this.rowData = rowData;
    this.API = API;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Server().getdataTableColumnType(pageName, rowData, API),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error!.toString()),
            // child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          // init setting start
          var page = jsonDecode(snapshot.data!.toString());
          // init setting end
          return Container(child: ObjectFactory().generateObject(page));
        } else {
          //   print("***** 1 *****");
          //   print(API);
          //   print("***** 1 *****");
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
