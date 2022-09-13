import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/objectFactory.dart';
import 'package:shop_admin_module/screens/Class/server.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({
    Key? key,
    required this.pageName,
    required this.rowData,
    required this.api,
  }) : super(key: key);
  final String pageName;
  final String api;
  final String rowData;
  @override
  DashboardScreenState createState() =>
      DashboardScreenState(pageName, rowData, api);
}

class DashboardScreenState extends State<DashboardScreen> {
  late String pageName;
  String rowData = "";
  String api = "";

  List columns = [];
  bool hiddenMenu = true;
  DashboardScreenState(String pageName, String rowData, String api) {
    this.pageName = pageName;
    this.rowData = rowData;
    this.api = api;
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Server().getdataTableColumnType(pageName, rowData, this.api),
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
