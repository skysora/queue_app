import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TableInformation {
  final Map<String, String> data;
  final int columnNumber;

  const TableInformation({required this.data, required this.columnNumber});

  factory TableInformation.convertNewRow(newRow) {
    Map<String, String> row = {};
    newRow.forEach((k, v) {
      row["$k"] = "$v";
    });
    return TableInformation(
      data: row,
      columnNumber: 10,
    );
  }

  factory TableInformation.fromJson(Map<String, dynamic> json) {
    Map<String, String> row = {};
    json.forEach((k, v) {
      row["$k"] = "$v";
    });
    return TableInformation(
      data: row,
      columnNumber: 10,
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    String response = "";
    for (final key in data.keys) {
      response += data[key].toString();
      response += " ";
    }
    return response;
  }

  getData() {
    return this.data;
  }

  List<TableInformation> removeColumn(List<TableInformation> data, String key) {
    Map<String, String> row = {};
    data[0].data.remove(key);
    return data;
  }
}

Future<List<TableInformation>> fetchData(String url) async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var token =
      json.decode(localStorage.getString('token').toString()).toString();

  var response;
  var data;
  print("dataTable:$url");
  try {
    response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      "Access-Control_Allow_Origin": "*", // Required for CORS support to work,
    });
    data = json.decode(response.body);
  } catch (error) {
    throw Exception(error.toString());
  }
  print(data["status"]);
  if (data["status"] == "success") {
    return compute(parseData, data);
  }
  //測試通過
  if (data != null) {
    return compute(parseData, data);
  }
  throw Exception('Failed to load ServerData');
}

// A function that converts a response body into a List<Photo>.
List<TableInformation> parseData(data) {
  var parsed;
  try {
    parsed = data["data"]["data"];
  } catch (error) {
    parsed = data["data"];
  }
  var res;
  try {
    if (parsed[0] == null) {
      parsed = [parsed];
    }
    res = parsed
        .map<TableInformation>((json) => TableInformation.fromJson(json))
        .toList();
  } catch (error) {
    res = <TableInformation>[];
  }
  return res;
}
