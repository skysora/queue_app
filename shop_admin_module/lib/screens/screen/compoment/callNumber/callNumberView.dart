import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shop_admin_module/screens/setting/api.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CallNumberView extends StatefulWidget {
  CallNumberView({
    Key? key,
    required this.setting,
    required this.dataTableManage,
  }) : super(key: key);
  final setting;
  final MyDataTableData dataTableManage;
  @override
  State<CallNumberView> createState() =>
      CallNumberViewState(setting, dataTableManage);
}

class CallNumberViewState extends State<CallNumberView> {
  late var setting;
  late MyDataTableData dataTableManage;
  late MaterialColor colorCustom;
  late Map<int, Color> color = color = {
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
  CallNumberViewState(setting, MyDataTableData dataTableManage) {
    this.setting = setting;
    this.dataTableManage = dataTableManage;
  }

  bool auto = true;

  List prefixList = [];
  List statusList = [];
  List peopleRange = [];
  String? range;
  int resetTime = 2;
  List<bool> isSelected = [true];
  int testNum = 0;

  List waitingQueueList = [];

  bool showCreate = false;
  int? createPrefix;
  List<bool> createPrefixSelected = [true];
  var dayList = {};
  late double height =
      (MediaQuery.of(context).size.height - myAppBarHeight) * setting["height"];
  late double width = MediaQuery.of(context).size.width * this.setting['width'];
  Timer? timer;
  Timer? statusTimer;

  bool speaking = false;

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    getQueueStatus();
    this.colorCustom = MaterialColor(0xFFFFE34B, color);
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {});
    });
    statusTimer =
        Timer.periodic(Duration(seconds: 30), (_) => getQueueStatus());

    flutterTts.setStartHandler(() {
      setState(() {
        speaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        speaking = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    statusTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width * this.setting['width'],
        height: (MediaQuery.of(context).size.height - myAppBarHeight) *
            setting["height"],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            currentQueuing(),
            waitingQueuing(),
          ],
        ),
      ),
    );
  }

  Widget currentQueuing() {
    double widgetWidth = this.width * 0.55;
    double widgetHeight = this.height;
    return Container(
      width: widgetWidth,
      height: widgetHeight,
      color: const Color.fromRGBO(237, 237, 237, 1),
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Column(
          children: [
            Container(
              height: 80,
              padding: const EdgeInsets.all(20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        timer?.cancel();
                      },
                      child: const Text(
                        "當前叫號隊列",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color.fromRGBO(0, 0, 0, 1)),
                      ),
                    ),
                    // Row(children: [
                    //   Container(
                    //     margin: const EdgeInsets.only(right: 10),
                    //     child: const Text(
                    //       "自動叫號",
                    //       style: TextStyle(
                    //           fontSize: 20,
                    //           color: Color.fromRGBO(0, 0, 0, 1)),
                    //     ),
                    //   ),
                    //   FlutterSwitch(
                    //     width: 80.0,
                    //     height: 40.0,
                    //     toggleSize: 30.0,
                    //     value: auto,
                    //     borderRadius: 45.0,
                    //     activeColor: const Color.fromRGBO(255, 137, 47, 1),
                    //     onToggle: (val) {
                    //       setState(() {
                    //         auto = val;
                    //       });
                    //     },
                    //   ),
                    // ]),
                  ]),
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.all(20),
              color: const Color.fromRGBO(250, 250, 250, 1),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: widgetWidth * 0.15,
                      child: const Text(
                        "票號",
                        style: TextStyle(
                            fontSize: 16, color: Color.fromRGBO(0, 0, 0, 1)),
                      ),
                    ),
                    SizedBox(
                      width: widgetWidth * 0.25,
                      child: const Text(
                        "等待時間",
                        style: TextStyle(
                            fontSize: 16, color: Color.fromRGBO(0, 0, 0, 1)),
                      ),
                    ),
                    SizedBox(
                      width: widgetWidth * 0.1,
                      child: const Text(
                        "人數",
                        style: TextStyle(
                            fontSize: 16, color: Color.fromRGBO(0, 0, 0, 1)),
                      ),
                    ),
                    SizedBox(
                      width: widgetWidth * 0.1,
                      child: const Text(
                        "叫號",
                        style: TextStyle(
                            fontSize: 16, color: Color.fromRGBO(0, 0, 0, 1)),
                      ),
                    ),
                    SizedBox(
                      width: widgetWidth * 0.1,
                      child: const Text(
                        "入座",
                        style: TextStyle(
                            fontSize: 16, color: Color.fromRGBO(0, 0, 0, 1)),
                      ),
                    ),
                    SizedBox(
                      width: widgetWidth * 0.1,
                      child: const Text(
                        "過號",
                        style: TextStyle(
                            fontSize: 16, color: Color.fromRGBO(0, 0, 0, 1)),
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              height: widgetHeight - 80 - 60 - 40,
              child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        thickness: 1,
                        height: 1,
                      ),
                  itemCount: statusList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map queuing = statusList[index];
                    String waitingTime = "- -";
                    if (queuing['next'] is Map) {
                      DateTime createAt =
                          DateTime.parse(queuing['next']['created_at']);
                      var timeDiff = DateTime.now().difference(createAt);
                      format(Duration d) =>
                          d.toString().split('.').first.padLeft(8, "0");
                      waitingTime = format(timeDiff);
                    }
                    return Container(
                      padding: const EdgeInsets.all(20),
                      height: 130,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: widgetWidth * 0.15,
                              child: Text(
                                "${queuing['prefix']}${queuing['min_ticket_num'] ?? ""}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 36,
                                    color: Color.fromRGBO(0, 0, 0, 1)),
                              ),
                            ),
                            SizedBox(
                              width: widgetWidth * 0.25,
                              child: Text(
                                waitingTime,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Color.fromRGBO(0, 0, 0, 1)),
                              ),
                            ),
                            SizedBox(
                              width: widgetWidth * 0.1,
                              child: Text(
                                queuing['answer_text']['tc'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Color.fromRGBO(0, 0, 0, 1)),
                              ),
                            ),
                            queuing['min_ticket_num'] == null
                                ? SizedBox(width: widgetWidth * 0.1)
                                : SizedBox(
                                    width: widgetWidth * 0.1,
                                    child: InkWell(
                                        onTap: () => speakWord(
                                            "${queuing['prefix']}${queuing['min_ticket_num']}"),
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              height: widgetWidth * 0.08,
                                              width: widgetWidth * 0.08,
                                              child: Image.asset(
                                                  'assets/icons/button_call_number.png'),
                                            ),
                                            (testNum == null || testNum == 0)
                                                ? SizedBox(
                                                    height: widgetWidth * 0.08,
                                                    width: widgetWidth * 0.08,
                                                  )
                                                : SizedBox(
                                                    height: widgetWidth * 0.08,
                                                    width: widgetWidth * 0.08,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Container(
                                                        height: 24,
                                                        width: 24,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(24),
                                                          color: const Color
                                                                  .fromRGBO(
                                                              255, 91, 47, 1),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "$testNum",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            1)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        )),
                                  ),
                            queuing['min_ticket_num'] == null
                                ? SizedBox(width: widgetWidth * 0.1)
                                : SizedBox(
                                    width: widgetWidth * 0.1,
                                    child: InkWell(
                                        onTap: () {
                                          changeStatus(
                                              queuing['queue_id'], "seated");
                                        },
                                        child: SizedBox(
                                          height: widgetWidth * 0.08,
                                          width: widgetWidth * 0.08,
                                          child: Image.asset(
                                              'assets/icons/button_take_seat.png'),
                                        )),
                                  ),
                            queuing['min_ticket_num'] == null
                                ? SizedBox(width: widgetWidth * 0.1)
                                : SizedBox(
                                    width: widgetWidth * 0.1,
                                    child: InkWell(
                                        onTap: () {
                                          changeStatus(
                                              queuing['queue_id'], "pass");
                                        },
                                        child: SizedBox(
                                          height: widgetWidth * 0.08,
                                          width: widgetWidth * 0.08,
                                          child: Image.asset(
                                              'assets/icons/button_pass_number.png'),
                                        )),
                                  ),
                          ]),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget waitingQueuing() {
    double widgetWidth = this.width * 0.45;
    double widgetHeight = this.height;
    return Stack(
      children: [
        Container(
          width: widgetWidth,
          height: widgetHeight,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Column(
            children: [
              Container(
                height: 80,
                padding: const EdgeInsets.all(20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "正在等候隊列",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color.fromRGBO(0, 0, 0, 1)),
                      )
                    ]),
              ),
              Container(
                height: 80,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      width: 1.0,
                    ),
                    top: BorderSide(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: statusList
                      .map((f) => SizedBox(
                            width: widgetWidth * 0.2,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: widgetWidth * 0.05,
                                  child: Center(
                                    child: Text(
                                      f['prefix'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          color: Color.fromRGBO(0, 0, 0, 1)),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: widgetWidth * 0.1,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Color.fromRGBO(250, 250, 250, 1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${f['count']}",
                                      style: const TextStyle(
                                          fontSize: 24,
                                          color:
                                              Color.fromRGBO(255, 137, 47, 1)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              Container(
                height: 60,
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                    width: widgetWidth * 0.6,
                    child: const Text(
                      "人數範圍",
                      style: TextStyle(
                          fontSize: 18, color: Color.fromRGBO(0, 0, 0, 1)),
                    ),
                  ),
                  //   SizedBox(
                  //     width: widgetWidth * 0.3,
                  //     child: const Text(
                  //       "還原時間（秒）",
                  //       style: TextStyle(
                  //           fontSize: 18, color: Color.fromRGBO(0, 0, 0, 1)),
                  //     ),
                  //   ),
                ]),
              ),
              Container(
                height: 80,
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(
                    width: widgetWidth * 0.6,
                    child: ToggleButtons(
                      constraints: BoxConstraints.tightForFinite(
                        width: widgetWidth * 0.14,
                        height: 55,
                      ),
                      children: filterBtn(),
                      onPressed: (int index) {
                        var ans;
                        try {
                          ans = peopleRange[index - 1];
                        } catch (e) {
                          ans = null;
                        }
                        if (range != ans) {
                          setState(() {
                            for (int buttonIndex = 0;
                                buttonIndex < isSelected.length;
                                buttonIndex++) {
                              if (buttonIndex == index) {
                                isSelected[buttonIndex] = true;
                                range = ans;
                              } else {
                                isSelected[buttonIndex] = false;
                              }
                            }
                          });
                          getQueueStatus();
                        }
                      },
                      isSelected: isSelected,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      borderColor: const Color.fromRGBO(224, 224, 224, 1),
                      selectedColor: const Color.fromRGBO(255, 251, 229, 1),
                      selectedBorderColor: const Color.fromRGBO(255, 215, 0, 1),
                      borderRadius: const BorderRadius.all(Radius.circular(7)),
                    ),
                  ),
                  //   SizedBox(
                  //     width: widgetWidth * 0.3,
                  //     child: Row(
                  //       children: [
                  //         InkWell(
                  //           onTap: () {
                  //             setState(() {
                  //               if (resetTime > 0) {
                  //                 resetTime--;
                  //               }
                  //             });
                  //           },
                  //           child: Container(
                  //             width: widgetWidth * 0.07,
                  //             height: widgetWidth * 0.07,
                  //             decoration: BoxDecoration(
                  //               borderRadius: const BorderRadius.only(
                  //                   bottomLeft: Radius.circular(10.0),
                  //                   topLeft: Radius.circular(10.0)),
                  //               border: Border.all(
                  //                 color:
                  //                     const Color.fromRGBO(224, 224, 224, 1),
                  //                 width: 1,
                  //               ),
                  //             ),
                  //             child: const Center(
                  //               child: Icon(Icons.remove,
                  //                   color: Color.fromRGBO(0, 0, 0, 1)),
                  //             ),
                  //           ),
                  //         ),
                  //         Container(
                  //           width: widgetWidth * 0.1,
                  //           height: widgetWidth * 0.07,
                  //           decoration: const BoxDecoration(
                  //             border: Border(
                  //               bottom: BorderSide(
                  //                 color: Color.fromRGBO(224, 224, 224, 1),
                  //                 width: 1.0,
                  //               ),
                  //               top: BorderSide(
                  //                 color: Color.fromRGBO(224, 224, 224, 1),
                  //                 width: 1.0,
                  //               ),
                  //             ),
                  //           ),
                  //           child: Center(
                  //             child: Text(
                  //               "$resetTime",
                  //               style: const TextStyle(
                  //                   fontSize: 24,
                  //                   color: Color.fromRGBO(0, 0, 0, 1)),
                  //             ),
                  //           ),
                  //         ),
                  //         InkWell(
                  //           onTap: () {
                  //             setState(() {
                  //               if (resetTime > 0) {
                  //                 resetTime++;
                  //               }
                  //             });
                  //           },
                  //           child: Container(
                  //             width: widgetWidth * 0.07,
                  //             height: widgetWidth * 0.07,
                  //             decoration: BoxDecoration(
                  //               borderRadius: const BorderRadius.only(
                  //                   bottomRight: Radius.circular(10.0),
                  //                   topRight: Radius.circular(10.0)),
                  //               border: Border.all(
                  //                 color:
                  //                     const Color.fromRGBO(224, 224, 224, 1),
                  //                 width: 1,
                  //               ),
                  //             ),
                  //             child: const Center(
                  //               child: Icon(Icons.add,
                  //                   color: Color.fromRGBO(0, 0, 0, 1)),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                ]),
              ),
              Container(
                height: 60,
                padding: const EdgeInsets.all(20),
                color: const Color.fromRGBO(250, 250, 250, 1),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: widgetWidth * 0.15,
                        child: const Text(
                          "票號",
                          style: TextStyle(
                              fontSize: 16, color: Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ),
                      SizedBox(
                        width: widgetWidth * 0.25,
                        child: const Text(
                          "等待時間",
                          style: TextStyle(
                              fontSize: 16, color: Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ),
                      SizedBox(
                        width: widgetWidth * 0.1,
                        child: const Text(
                          "人數",
                          style: TextStyle(
                              fontSize: 16, color: Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ),
                      SizedBox(
                        width: widgetWidth * 0.1,
                        child: const Text(
                          "叫號",
                          style: TextStyle(
                              fontSize: 16, color: Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ),
                      SizedBox(
                        width: widgetWidth * 0.1,
                        child: const Text(
                          "入座",
                          style: TextStyle(
                              fontSize: 16, color: Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ),
                      SizedBox(
                        width: widgetWidth * 0.1,
                        child: const Text(
                          "過號",
                          style: TextStyle(
                              fontSize: 16, color: Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: widgetHeight - 80 - 80 - 150 - 60 - 40 - 60,
                child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          thickness: 1,
                          height: 1,
                        ),
                    itemCount: waitingQueueList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map queuing = waitingQueueList[index];
                      String waitingTime = "";
                      DateTime createAt = DateTime.parse(queuing['created_at']);
                      var timeDiff = DateTime.now().difference(createAt);
                      format(Duration d) =>
                          d.toString().split('.').first.padLeft(8, "0");
                      waitingTime = format(timeDiff);

                      int prefixIndex = prefixList.indexWhere(
                          (element) => element['prefix'] == queuing['prefix']);
                      String desc = prefixIndex == -1
                          ? "1"
                          : prefixList[prefixIndex]['text']['tc'];
                      return Container(
                        padding: const EdgeInsets.all(20),
                        height: 110,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: widgetWidth * 0.15,
                                child: Text(
                                  queuing['ticket_number'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                      color: Color.fromRGBO(0, 0, 0, 1)),
                                ),
                              ),
                              SizedBox(
                                width: widgetWidth * 0.25,
                                child: Text(
                                  waitingTime,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Color.fromRGBO(0, 0, 0, 1)),
                                ),
                              ),
                              SizedBox(
                                width: widgetWidth * 0.1,
                                child: Text(
                                  queuing['ticket_answer_text'] is Map
                                      ? queuing['ticket_answer_text']['tc']
                                      : desc,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Color.fromRGBO(0, 0, 0, 1)),
                                ),
                              ),
                              SizedBox(
                                width: widgetWidth * 0.1,
                                child: InkWell(
                                    onTap: () =>
                                        speakWord(queuing['ticket_number']),
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          height: widgetWidth * 0.08,
                                          width: widgetWidth * 0.08,
                                          child: Image.asset(
                                              'assets/icons/button_call_number.png'),
                                        ),
                                        (testNum == null || testNum == 0)
                                            ? SizedBox(
                                                height: widgetWidth * 0.08,
                                                width: widgetWidth * 0.08,
                                              )
                                            : SizedBox(
                                                height: widgetWidth * 0.08,
                                                width: widgetWidth * 0.08,
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                    height: 24,
                                                    width: 24,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                      color:
                                                          const Color.fromRGBO(
                                                              255, 91, 47, 1),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "$testNum",
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    )),
                              ),
                              SizedBox(
                                width: widgetWidth * 0.1,
                                child: InkWell(
                                    onTap: () {
                                      changeStatus(queuing['id'], "seated");
                                    },
                                    child: SizedBox(
                                      height: widgetWidth * 0.08,
                                      width: widgetWidth * 0.08,
                                      child: Image.asset(
                                          'assets/icons/button_take_seat.png'),
                                    )),
                              ),
                              SizedBox(
                                width: widgetWidth * 0.1,
                                child: InkWell(
                                    onTap: () {
                                      changeStatus(queuing['id'], "pass");
                                    },
                                    child: SizedBox(
                                      height: widgetWidth * 0.08,
                                      width: widgetWidth * 0.08,
                                      child: Image.asset(
                                          'assets/icons/button_pass_number.png'),
                                    )),
                              ),
                            ]),
                      );
                    }),
              ),
              InkWell(
                onTap: () => setState(() {
                  showCreate = true;
                }),
                child: Container(
                  height: 80,
                  width: widgetWidth - 40,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: const Color.fromRGBO(255, 227, 75, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('創建票號',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Color.fromRGBO(108, 82, 49, 1),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showCreate)
          SizedBox(
              width: widgetWidth,
              height: widgetHeight,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  width: widgetWidth * 0.95,
                  height: 290,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 4), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(240, 240, 240, 1),
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Row(children: [
                          const Text(
                            "正在等候隊列",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color.fromRGBO(0, 0, 0, 1)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5, left: 10),
                            child: const Text(
                              "只限沒有手機的顧客",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(153, 153, 153, 1)),
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        height: 60,
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: widgetWidth * 0.4,
                                child: const Text(
                                  "檯型",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromRGBO(0, 0, 0, 1)),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        height: 80,
                        padding: const EdgeInsets.only(
                          top: 5,
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: widgetWidth * 0.85,
                                child: ToggleButtons(
                                  constraints: BoxConstraints.tightForFinite(
                                    width:
                                        (widgetWidth - 100) / prefixList.length,
                                    height: 55,
                                  ),
                                  children: prefixList
                                      .map((e) => Text(
                                            e['text']['tc'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1)),
                                          ))
                                      .toList(),
                                  onPressed: (int index) {
                                    setState(() {
                                      for (int buttonIndex = 0;
                                          buttonIndex <
                                              createPrefixSelected.length;
                                          buttonIndex++) {
                                        if (buttonIndex == index) {
                                          createPrefixSelected[buttonIndex] =
                                              true;
                                          createPrefix =
                                              prefixList[index]['id'];
                                        } else {
                                          createPrefixSelected[buttonIndex] =
                                              false;
                                        }
                                      }
                                    });
                                  },
                                  isSelected: createPrefixSelected,
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  borderColor:
                                      const Color.fromRGBO(224, 224, 224, 1),
                                  selectedColor:
                                      const Color.fromRGBO(255, 251, 229, 1),
                                  selectedBorderColor:
                                      const Color.fromRGBO(255, 215, 0, 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(7)),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        height: 70,
                        padding: const EdgeInsets.only(
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () => setState(() {
                                  showCreate = false;
                                  clearCreateForm();
                                }),
                                child: Container(
                                  height: 70,
                                  width: widgetWidth * 0.4,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(
                                      color: const Color.fromRGBO(
                                          224, 224, 224, 1),
                                      width: 1,
                                    ),
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                  child: const Center(
                                    child: Text('取消',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                        )),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await getTicket();
                                },
                                child: Container(
                                  height: 70,
                                  width: widgetWidth * 0.4,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: Color.fromRGBO(255, 227, 75, 1),
                                  ),
                                  child: const Center(
                                    child: Text('創建票號',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Color.fromRGBO(108, 82, 49, 1),
                                        )),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ))
      ],
    );
  }

  void changeStatus(id, status) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token =
        json.decode(localStorage.getString('token').toString()).toString();

    final qusResponse = await http.put(
      Uri.parse(gobalUrl + "/api/queue/$id"),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"status": status}),
    );
    print("-- ID: $id, Status: $status, Success:${qusResponse.statusCode} --");
    if (qusResponse.statusCode != 200) {
      print(qusResponse.body);
    }
    getQueueStatus();
  }

  List<Widget> filterBtn() {
    List<Widget> widgetList = [];
    widgetList.add(Text(
      "All",
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Color.fromRGBO(0, 0, 0, 1)),
    ));
    peopleRange.forEach((element) {
      widgetList.add(Text(
        element,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color.fromRGBO(0, 0, 0, 1)),
      ));
    });
    return widgetList;
  }

  void initFilter() {
    setState(() {
      peopleRange = [];
      isSelected = [];
      createPrefixSelected = [];
      isSelected.add(true);
      statusList.forEach((element) {
        peopleRange.add(element['prefix']);
        isSelected.add(false);
        createPrefixSelected.add(false);
      });
    });
  }

  void clearCreateForm() {
    setState(() {
      createPrefixSelected = [];
      prefixList.forEach((element) {
        createPrefixSelected.add(false);
      });
    });
  }

  Future<void> getTicket() async {
    if (createPrefix == null) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text('創建票號失敗',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  )),
              content: Container(
                width: 60,
                margin: EdgeInsets.only(
                  right: 0,
                  top: 20,
                ),
                child: Text('請輸入檯型。',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 24, color: Color.fromRGBO(0, 0, 0, 1))),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('確認',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color.fromRGBO(255, 137, 47, 1))),
                  onPressed: () {
                    Navigator.of(context).pop('cancel');
                  },
                ),
              ],
            );
          });
    } else {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var token =
          jsonDecode(localStorage.getString('token').toString()).toString();
      var branchID =
          jsonDecode(localStorage.getString('branch_id').toString()).toString();
      await http.post(Uri.parse(gobalUrl + "/api/queue"),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
              {"branch_id": branchID, "ticket_answer": createPrefix}));
      setState(() {
        showCreate = false;
        clearCreateForm();
      });
    }
  }

  Future<void> getQueueStatus() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token =
        jsonDecode(localStorage.getString('token').toString()).toString();
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
    final queueListResponse = await http.get(
        Uri.parse(gobalUrl +
            "/api/queue?branch_id=$branchID&query[name]=special&pagination[page]&pagination[perpage]=100&hour24=true&except[]=cancelled&except[]=seated&query[ticket_number]=${range ?? ""}"),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        });
    var queueList = json.decode(queueListResponse.body);
    final prefixListResponse = await http.get(
        Uri.parse(gobalUrl +
            "/api/shops/$shopID/branches/$branchID/question?key=queue"),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        });
    var prefixData = json.decode(prefixListResponse.body);
    setState(() {
      if (branchQuestion['data'] is List) {
        statusList = branchQuestion['data'];
      } else {
        Map tmp = branchQuestion['data'];
        statusList = tmp.values.toList();
      }

      prefixList = prefixData['ticket_question']['answer'];
      waitingQueueList = queueList['data']['data'];
    });
    if (range == null) {
      initFilter();
    }
  }

  Future<void> speakWord(String text) async {
    if (!speaking) {
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setLanguage("zh-HK");
      await flutterTts.speak(text);

      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setLanguage("zh-CN");
      await flutterTts.speak(text);

      await flutterTts.setSpeechRate(0.25);
      await flutterTts.setLanguage("en-US");
      await flutterTts.speak(text);
    }
  }
}
