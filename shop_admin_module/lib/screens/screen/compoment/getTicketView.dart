import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/setting/api.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GetTicketView extends StatefulWidget {
  GetTicketView({
    Key? key,
    required this.setting,
    required this.dataTableManage,
  }) : super(key: key);
  final setting;
  final MyDataTableData dataTableManage;
  @override
  State<GetTicketView> createState() =>
      GetTicketViewState(setting, dataTableManage);
}

class GetTicketViewState extends State<GetTicketView> {
  late var setting;
  late MyDataTableData dataTableManage;
  late Map<int, Color> color;
  late String title;

  List prefixList = [];
  List bannerList = [];
  List statusList = [];

  final _bannerController = PageController(viewportFraction: 1, keepPage: true);

  String? phone;
  String? people;

  String typing = "phone";

  String qrUrl = "";
  Timer? timer;

  late double height =
      (MediaQuery.of(context).size.height - myAppBarHeight) * setting["height"];
  late double width = MediaQuery.of(context).size.width * this.setting['width'];
  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    getQueueStatus();
    timer =
        Timer.periodic(Duration(seconds: 30), (Timer t) => getQueueStatus());
    super.initState();
  }

  GetTicketViewState(setting, MyDataTableData dataTableManage) {
    this.setting = setting;
    this.dataTableManage = dataTableManage;
    this.color = {
      50: Color.fromRGBO(255, 227, 75, .1),
      100: Color.fromRGBO(255, 227, 75, .2),
      200: Color.fromRGBO(255, 227, 75, .3),
      300: Color.fromRGBO(255, 227, 75, .4),
      400: Color.fromRGBO(255, 227, 75, .5),
      500: Color.fromRGBO(255, 227, 75, .6),
      600: Color.fromRGBO(255, 227, 75, .7),
      700: Color.fromRGBO(255, 227, 75, .8),
      800: Color.fromRGBO(255, 227, 75, .9),
      900: Color.fromRGBO(255, 227, 75, 1),
    };
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width * this.setting['width'],
        height: (MediaQuery.of(context).size.height - myAppBarHeight) *
            setting["height"],
        child: Column(
          children: [
            banner(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ticketStatus(),
                getTicket(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget banner() {
    double widgetWidth = MediaQuery.of(context).size.width;
    double widgetHeight = MediaQuery.of(context).size.height * 0.3;
    final bannerPage = List.generate(
      bannerList.length,
      (index) => Container(
        height: widgetHeight,
        width: widgetWidth,
        color: Color.fromRGBO(177, 177, 177, (10 - index.toDouble()) / 10),
        child: Image.network(
          bannerList[index]['banner_url'] == null
              ? "https://w7.pngwing.com/pngs/29/173/png-transparent-null-pointer-symbol-computer-icons-pi-miscellaneous-angle-trademark.png"
              : gobalUrl + bannerList[index]['banner_url'],
          fit: BoxFit.fitWidth,
        ),
      ),
    );
    return Container(
      width: widgetWidth,
      height: widgetHeight,
      color: Colors.black,
      child: bannerPage.length == 0
          ? Container()
          : Stack(
              children: [
                SizedBox(
                  height: widgetHeight,
                  child: PageView.builder(
                    controller: _bannerController,
                    // itemCount: pages.length,
                    itemBuilder: (_, index) {
                      return bannerPage[index % bannerPage.length];
                    },
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(
                      bottom: 40,
                      right: 30,
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SmoothPageIndicator(
                        controller: _bannerController, // PageController
                        count: bannerPage.length,
                        effect: const ColorTransitionEffect(
                          dotWidth: 18.0,
                          dotHeight: 18.0,
                          dotColor: Colors.black38,
                          activeDotColor: Colors.white60,
                        ),
                      ),
                    )),
              ],
            ),
    );
  }

  Widget ticketStatus() {
    double widgetWidth = MediaQuery.of(context).size.width * 0.5;
    double widgetHeight =
        this.height - MediaQuery.of(context).size.height * 0.3;
    return Container(
      width: widgetWidth,
      height: widgetHeight,
      color: const Color.fromRGBO(0, 0, 0, 1),
      padding: const EdgeInsets.all(20),
      child: Container(
          width: widgetWidth,
          height: widgetHeight - 40,
          decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(240, 240, 240, 1),
              ),
              borderRadius: BorderRadius.circular(25),
              color: const Color.fromRGBO(255, 255, 255, 1)),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 40,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("當前排隊概況",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color.fromRGBO(29, 29, 27, 1))),
                ),
              ),
              Container(
                height: widgetHeight - 162,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                child: SingleChildScrollView(
                    child: ListView.builder(
                  itemCount: statusList.length,
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    Map queue = statusList[index];
                    String? status;
                    String? maxTicket = queue['max_ticket_num'] != null
                        ? queue['prefix'] + queue['max_ticket_num'].toString()
                        : null;
                    return _queueInfo(
                        status,
                        queue['prefix'] + "票",
                        '${queue['answer_text']['tc']}人',
                        queue['count'].toString(),
                        maxTicket);
                  },
                )),
              ),
            ],
          )),
    );
  }

  Widget getTicket() {
    double widgetWidth = MediaQuery.of(context).size.width * 0.5;
    double widgetHeight =
        this.height - MediaQuery.of(context).size.height * 0.3;
    return Container(
      width: widgetWidth,
      height: widgetHeight,
      color: const Color.fromRGBO(0, 0, 0, 1),
      padding: const EdgeInsets.all(20),
      child: Container(
          width: widgetWidth,
          height: widgetHeight - 40,
          decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(240, 240, 240, 1),
              ),
              borderRadius: BorderRadius.circular(25),
              color: const Color.fromRGBO(255, 255, 255, 1)),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                height: 40,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("排隊取票",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color.fromRGBO(29, 29, 27, 1))),
                ),
              ),
              Container(
                height: widgetHeight - 202 - 100,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                child: QrImage(
                  data: qrUrl,
                  version: QrVersions.auto,
                ),
              ),
              InkWell(
                  onTap: () {
                    setState(() async {
                      SharedPreferences localStorage =
                          await SharedPreferences.getInstance();
                      var branch_id = json
                          .decode(
                              localStorage.getString('branch_id').toString())
                          .toString();
                      var shop_id = json
                          .decode(localStorage.getString('shop_id').toString())
                          .toString();
                      qrUrl =
                          '{"branch_id": $branch_id, "shop_id": $shop_id ,"date":${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}}';
                    });
                  },
                  child: Container(
                      height: 100,
                      width: widgetWidth * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color.fromRGBO(255, 215, 0, 1),
                        ),
                        color: const Color.fromRGBO(255, 251, 229, 1),
                      ),
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.refresh,
                              size: 32, color: Color.fromRGBO(108, 82, 49, 1)),
                          Text("刷新",
                              style: TextStyle(
                                  fontSize: 28,
                                  color: Color.fromRGBO(108, 82, 49, 1))),
                        ],
                      ))),
            ],
          )),
    );
  }

  Widget _queueInfo(String? status, String tableName, String tableInfo,
      String frontPeople, String? nowQueueNum) {
    double widgetWidth = MediaQuery.of(context).size.width * 0.5;
    double widgetHeight = MediaQuery.of(context).size.height;

    return Container(
        height: 150,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromRGBO(235, 235, 235, 1),
            ),
            borderRadius: BorderRadius.circular(25),
            color: const Color.fromRGBO(255, 255, 255, 1)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: (widgetWidth - 100) / 3,
                      child: Column(children: <Widget>[
                        Text(tableName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color.fromRGBO(29, 29, 27, 1))),
                      ])),
                  SizedBox(
                      width: (widgetWidth - 100) / 3,
                      child: Column(children: <Widget>[
                        Text(frontPeople,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color.fromRGBO(255, 137, 47, 1))),
                      ])),
                  SizedBox(
                      width: (widgetWidth - 100) / 3,
                      child: Column(children: <Widget>[
                        Text(nowQueueNum ?? '無需排隊',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: nowQueueNum != null
                                    ? const Color.fromRGBO(0, 0, 0, 1)
                                    : const Color.fromRGBO(153, 153, 153, 1))),
                      ])),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: (widgetWidth - 100) / 3,
                      margin: const EdgeInsets.only(left: 10),
                      child: Column(children: <Widget>[
                        Text(tableInfo,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 28,
                                color: Color.fromRGBO(153, 153, 153, 1))),
                      ])),
                  Container(
                      width: (widgetWidth - 100) / 3,
                      margin: const EdgeInsets.only(right: 0),
                      child: Column(children: const <Widget>[
                        Text('前方排隊(檯)',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 28,
                                color: Color.fromRGBO(153, 153, 153, 1))),
                      ])),
                  Container(
                      width: (widgetWidth - 100) / 3,
                      margin: const EdgeInsets.only(right: 0),
                      child: Column(children: const <Widget>[
                        Text('目前號碼',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 28,
                                color: Color.fromRGBO(153, 153, 153, 1))),
                      ])),
                ],
              ),
            ]));
  }

  Future<void> getQueueStatus() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token =
        json.decode(localStorage.getString('token').toString()).toString();
    var shopID =
        jsonDecode(localStorage.getString('shop_id').toString()).toString();
    var branchID =
        jsonDecode(localStorage.getString('branch_id').toString()).toString();
    final qusResponse = await http.get(
        Uri.parse(gobalUrl + "/api/queue/status?branch_id=$branchID"),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        });
    var branchQuestion = json.decode(qusResponse.body);
    final imageResponse = await http.get(Uri.parse(setting["img_api"]),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        });
    var image = json.decode(imageResponse.body);
    setState(() {
      if (branchQuestion['data'] is List) {
        statusList = branchQuestion['data'];
      } else {
        Map tmp = branchQuestion['data'];
        statusList = tmp.values.toList();
      }
      bannerList = image['data']['data'];
    });
  }
}
