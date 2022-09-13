import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/components/Screen/dashboardPage.dart';

class ShopInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      '商戶資訊',
      '', //rowData
      'shopUser/views/shopMeau/branchDetail', //API
    );
  }
}
