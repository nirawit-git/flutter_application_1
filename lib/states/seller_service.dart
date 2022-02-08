import 'package:flutter/material.dart';
import 'package:flutter_application_1/bodys/show_manage_seller.dart';
import 'package:flutter_application_1/bodys/show_order_seller.dart';
import 'package:flutter_application_1/bodys/show_product_seller.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/widgets/show_signout.dart';
import 'package:flutter_application_1/widgets/show_title.dart';

class SellerService extends StatefulWidget {
  const SellerService({Key? key}) : super(key: key);

  @override
  _SellerServiceState createState() => _SellerServiceState();
}

class _SellerServiceState extends State<SellerService> {
  List<Widget> widgets = [ShowOrderSeller(),ShowManageSeller(),ShowProductSeller()];
  int indexWidget = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            ShowSignOut(),
            Column(
              children: [
                UserAccountsDrawerHeader(accountName: null, accountEmail: null),
                menuShowOrder(),
                menuShowProduct(),
                menuShopManager(),

              ],
            ),
          ],
        ),
      ),
      body: widgets[indexWidget],
    );
  }

  ListTile menuShowOrder() {
    return ListTile(onTap: () async{
      setState(() {
      indexWidget = 0;
      Navigator.pop(context);
      });
    },
      leading: Icon(Icons.filter_2_outlined),
      title: ShowTitle(
        title: 'Order',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'แสดงรายละเอียด order',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile menuShowProduct() {
    return ListTile(onTap: () async{
      setState(() {
        indexWidget = 1;
        Navigator.pop(context);
      });
    },
      leading: Icon(Icons.filter_1_outlined),
      title: ShowTitle(
        title: 'Product',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'แสดงรายละเอียด Product',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile menuShopManager() {
    return ListTile(onTap: () async{
      setState(() {
        indexWidget = 2;
        Navigator.pop(context);
      });
    },
      leading: Icon(Icons.filter_3_outlined),
      title: ShowTitle(
        title: 'Shop Manager',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'แสดงรายละเอียด หน้าร้าน',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

}
