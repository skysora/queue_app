import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_admin_module/screens/components/Screen/dashboardPage.dart';
import 'package:shop_admin_module/screens/components/Screen/dashboardScreen.dart';

class ShopMangementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getShopID(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return DashboardPage(
              '我的商戶',
              snapshot.data!.replaceAll('"', ""),
              'shopUser/views/shopMeau/branch',
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Future<String> getShopID() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return localStorage.getString('shop_id').toString();
  }
}
