import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_admin_module/screens/setting/api.dart';
import 'TableInformation.dart';
import 'package:dio/dio.dart';

class Server {
  List<TableInformation> search(String keyword, List listData) {
    List<TableInformation> response = [];
    for (int index = 0; index < listData.length; index++) {
      if (listData[index].toString().contains(keyword)) {
        response.add(listData[index]);
      }
    }
    return response;
  }

  getMeauData(String meauName) {
    if (meauName == "shopMeau") {
      return shopMeau;
    }
    return pageSetting;
  }

  getdataTableColumnType(String pageName, String rowData, String API) async {
    if (rowData == "") {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      rowData = jsonDecode(localStorage.getString("rowData")!);
    }
    var data = {'pageName': pageName, 'rowData': rowData};
    var res = await columnTypeData(data, API);
    var body = json.decode(res.body);
    if (body["status"] == "success") {
      return body["data"];
    } else {
      return body["msg"];
    }
  }

  columnTypeData(data, apiUrl) async {
    var fullUrl = gobalUrlAPI + apiUrl;
    print("fullUrl:" + fullUrl);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token =
        json.decode(localStorage.getString('token').toString()).toString();
    var res =
        await http.post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
      // charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    return res;
  }

  uploadSelectedFile(PlatformFile file) async {
    //---Create http package multipart request object
    final request = http.MultipartRequest(
      "POST",
      Uri.parse(gobalUrl + fileStoreAPI),
    );
    //-----add other fields if needed
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    request.fields["user"] = localStorage.getString('user').toString();
    //-----add selected file with request
    request.files.add(new http.MultipartFile(
        "file", file.readStream!, file.size,
        filename: file.name));
    request.fields["filename"] = file.name.toString();
    //-------Send request
    var resp = await request.send();
    //------Read response
    String result = await resp.stream.bytesToString();

    //-------Your response
    return result;
  }

  jsonToFormData(http.MultipartRequest request, row, dataColumnType) {
    row.keys.forEach((str) {
      switch (dataColumnType[str]["type"].toString()) {
        case "file":
          try {
            request
              ..files.add(http.MultipartFile(
                  str.toString(), row[str].readStream!, row[str].size,
                  filename: row[str].name));
          } catch (error) {}
          break;
        case "mutiData":
          for (final rowData in row[str]) {
            print(rowData.runtimeType);
          }
          break;
        case "mutiDownlist":
          for (int i = 0; i < row[str].toList().length; i++) {
            request.fields['$str[$i]'] = '${row[str][i]}';
          }
          break;
        case "group":
          request.fields[str] = jsonEncode(row[str]);
          break;
        default:
          request.fields[str] = row[str].toString();
      }
    });
    return request;
  }

  keepLogin() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('keepLogin', "true");
  }

  logOut() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.clear();
  }

  authData(data, apiUrl, _isLogin) async {
    var fullUrl = gobalUrl + apiUrl;
    print(fullUrl);
    var res = await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json"
        });
    var body = json.decode(res.body);
    print(body);
    if (body['status'] == "success") {
      var userDetail = await Server().cudData(
          data,
          getUserShopIDAPI + body['user_id'].toString(),
          body['token'].toString());
      userDetail = json.decode(userDetail.body);
      if (userDetail['status'] == "success") {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        if (_isLogin) {
          keepLogin();
        }
        localStorage.setString('user', json.encode(body['user_id']));
        localStorage.setString(
            'username', json.encode(userDetail["data"]['username']));
        localStorage.setString('token', json.encode(body['token']));
        localStorage.setString(
            'shop_id', json.encode(userDetail["data"]['shop_id']));
        localStorage.setString(
            'branch_id', json.encode(userDetail["data"]['branch_id']));
        localStorage.setString(
            'group_id', json.encode(userDetail["data"]['group_id']));
        localStorage.setString('user_id', json.encode(body['user_id']));
        localStorage.setString('identifier', json.encode(data['identifier']));
        localStorage.setString(
            'profile_url', json.encode(data['icon_path'] ?? ""));

        // rowData : shop_id+branch_id+group_id+identifier+paged+username+user_id
        var rowData = userDetail["data"]['shop_id'].toString() +
            "+" +
            userDetail["data"]['branch_id'].toString() +
            "+" +
            userDetail["data"]['group_id'].toString() +
            "+" +
            data['identifier'].toString() +
            "+" +
            "1" +
            "+" +
            data['username'].toString() +
            "+" +
            body['user_id'].toString();
        localStorage.setString('rowData', json.encode(rowData));
        return userDetail;
      } else {
        return userDetail;
      }
    } else {
      return body;
    }
  }

  cudData(data, apiUrl, token) async {
    var fullUrl = gobalUrl + apiUrl;
    print(fullUrl);
    return await http.get(Uri.parse(fullUrl), headers: {
      'Content-Type': 'application/json',
      // charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
  }

  forgetPassword(data, apiUrl) async {
    var fullUrl = gobalUrl + apiUrl;
    print(fullUrl);
    var res = await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        });
    var body = json.decode(res.body);
    if (body['status'] == "success") {
      return body;
    } else {
      return body;
    }
  }

  forgetPasswordVerify(data, apiUrl) async {
    var fullUrl = gobalUrl + apiUrl;
    print(fullUrl);
    var res = await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        });
    var body = json.decode(res.body);
    print(body);
    if (body['status'] == "success") {
      return body;
    } else {
      return body;
    }
  }

  getEditFile(tableName, title) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var data = {
      'table': tableName,
      'column': title,
      'user': localStorage.getString('user').toString()
    };
    var res = await columnTypeData(data, editfileAPI);
    var body = json.decode(res.body);
    return body;
  }

  createRow(data, apiUrl) async {
    var fullUrl = gobalUrl + apiUrl;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token =
        json.decode(localStorage.getString('token').toString()).toString();
    var res =
        await http.post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(res);
    return res;
  }

  deleteRow(apiUrl) async {
    var fullUrl = gobalUrl + apiUrl;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token =
        json.decode(localStorage.getString('token').toString()).toString();
    var res = await http.delete(Uri.parse(fullUrl), headers: {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return res;
  }

  updateRow(data, apiUrl) async {
    var fullUrl = gobalUrl + apiUrl;
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token =
        json.decode(localStorage.getString('token').toString()).toString();
    var res =
        await http.put(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-Type': 'application/json;charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return res;
  }

  dataToJson(String data) {
    List<String> timeList = data
        .toString()
        .replaceAll("{", "")
        .replaceAll("[", "")
        .replaceAll("]", "")
        .split("}");
    timeList.removeLast();
    List JsonDecode_timeList = [];
    for (final row in timeList) {
      Map<String, String> tempRow = {};

      for (var item in row.split(',')) {
        if (item.toString() == "") {
          continue;
        }
        var tempItem = item.toString().split(": ");
        tempRow[tempItem[0].replaceAll(" ", "")] =
            tempItem[1].replaceAll(" ", "");
      }
      JsonDecode_timeList.add(tempRow);
    }
    return JsonDecode_timeList;
  }

  convertDescriptionsToJson(String data) {
    List<String> timeList = data
        .toString()
        .replaceAll("{", "")
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll(".,", "._")
        .replaceAll("。,", "。_")
        .split("}");
    timeList.removeLast();
    List JsonDecode_timeList = [];
    for (final row in timeList) {
      Map<String, String> tempRow = {};
      for (var item in row.split('_')) {
        if (item.toString() == "") {
          continue;
        }
        var tempItem = item.toString().split(": ");
        tempRow[tempItem[0].replaceAll(" ", "")] =
            tempItem[1].replaceAll(" ", "");
      }
      JsonDecode_timeList.add(tempRow);
    }
    return JsonDecode_timeList[0];
  }

  convertLanguageToJson(String data) {
    var row = {};
    try {
      var test = data
          .toString()
          .replaceAll("{", "")
          .replaceAll("[", "")
          .replaceAll("]", "")
          .replaceAll("}", "")
          .split(", tc: ");
      row["en"] = test[0].split("en: ")[1];
      row["tc"] = test[1].split(", sc: ")[0];
      row["sc"] = test[1].split(", sc: ")[1];
    } catch (error) {
      row["en"] = "";
      row["tc"] = "";
      row["sc"] = "";
    }

    return row;
  }

  convertTagToJson(String data, int rowLimit) {
    List<String> timeList = data
        .toString()
        .replaceAll("{", "")
        .replaceAll("[", "")
        .replaceAll("]", "")
        .split("}");
    timeList.removeLast();
    List JsonDecode_timeList = [];

    for (final row in timeList) {
      Map<String, String> tempRow = {};

      for (var item in row.split(',')) {
        if (item.toString() == "") {
          continue;
        }
        var tempItem = item.toString().split(": ");
        tempRow[tempItem[0].replaceAll(" ", "")] =
            tempItem[1].replaceAll(" ", "");
      }
      JsonDecode_timeList.add(tempRow);
    }

    JsonDecode_timeList.remove("{}");
    var tempTimeList = [];
    for (var i = 0; i < JsonDecode_timeList.length; i += rowLimit) {
      var temp = (JsonDecode_timeList.sublist(
          i,
          i + rowLimit > JsonDecode_timeList.length
              ? JsonDecode_timeList.length
              : i + rowLimit));
      tempTimeList.add(temp);
    }
    return tempTimeList;
  }

  listViewCardButton(dataTableManage, index) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String shop_id = "";
    if (dataTableManage.data[index].data['shop_id'] != null) {
      shop_id = dataTableManage.data[index].data['shop_id'].toString();
      print(shop_id);
    } else {
      shop_id =
          json.decode(localStorage.getString('shop_id').toString()).toString();
    }
    String branch_id = dataTableManage.data[index].data['id'].toString();
    print("branch_id:$branch_id");
    String group_id =
        json.decode(localStorage.getString('group_id').toString()).toString();
    String identifier =
        json.decode(localStorage.getString('identifier').toString()).toString();
    String paged =
        json.decode(localStorage.getString('paged').toString()).toString();
    String username =
        json.decode(localStorage.getString('username').toString()).toString();
    String user_id =
        json.decode(localStorage.getString('user_id').toString()).toString();
    // rowData : shop_id+branch_id+group_id+identifier+paged+username+user_id
    var rowData = shop_id +
        "+" +
        branch_id +
        "+" +
        group_id +
        "+" +
        identifier +
        "+" +
        "1" +
        "+" +
        username +
        "+" +
        user_id;

    localStorage.setString('shop_id', json.encode(shop_id));
    localStorage.setString('branch_id', json.encode(branch_id));
    localStorage.setString('rowData', json.encode(rowData));
    // rowData : shop_id+branch_id+group_id+identifier+paged+username+user_id
    print(rowData);
    return rowData;
  }

  getRowData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var rowData = jsonDecode(localStorage.getString("shop_id")!) +
        "+" +
        jsonDecode(localStorage.getString("id")!);
    return rowData;
  }

  onPageChanged(int paged, setting, context) async {
    // rowData : shop_id+branch_id+group_id+identifier+paged+username
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var shop_id =
        json.decode(localStorage.getString('shop_id').toString()).toString();
    var branch_id =
        json.decode(localStorage.getString('branch_id').toString()).toString();
    var group_id =
        json.decode(localStorage.getString('group_id').toString()).toString();
    var identifier =
        json.decode(localStorage.getString('identifier').toString()).toString();
    var username =
        json.decode(localStorage.getString('username').toString()).toString();
    String getDataAPI = setting["API"]["template"]
        .toString()
        .replaceAll("<shop_id>", "$shop_id")
        .replaceAll("<branch_id>", "$branch_id")
        .replaceAll("<group_id>", "$branch_id")
        .replaceAll("<identifier>", "$branch_id")
        .replaceAll("<paged>", "$paged")
        // .replaceAll("<paged>", "1")
        .replaceAll("<username>", "$username");
    List<TableInformation> data = await fetchData(getDataAPI);
    return data;
  }
}
