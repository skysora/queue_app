import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/components/Screen/dashboardPage.dart';

class CouponManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      '優惠卷管理',
      '', //rowData
      'shopUser/views/shopMeau/couponManagement', //API
    );
  }
}
