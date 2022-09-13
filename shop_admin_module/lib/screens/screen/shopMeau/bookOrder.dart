import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/components/Screen/dashboardPage.dart';

class BookOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      '預約訂單',
      '', //rowData
      'shopUser/views/shopMeau/bookOrder', //API
    );
  }
}
