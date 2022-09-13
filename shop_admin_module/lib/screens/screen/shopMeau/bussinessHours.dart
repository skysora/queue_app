import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/components/Screen/dashboardPage.dart';

class BussinessHours extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      '營業時間',
      '', //rowData
      'shopUser/views/shopMeau/time', //API
    );
  }
}
