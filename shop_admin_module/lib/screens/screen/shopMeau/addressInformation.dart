import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/components/Screen/dashboardPage.dart';

class AddressInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      '地址信息', //page
      '', //rowData
      'shopUser/views/shopMeau/address', //API
    );
  }
}
