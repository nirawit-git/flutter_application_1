import 'package:flutter/material.dart';
import 'package:flutter_application_1/states/add_product.dart';
import 'package:flutter_application_1/states/authen.dart';
import 'package:flutter_application_1/states/create_account.dart';
import 'package:flutter_application_1/states/buyer_service.dart';
import 'package:flutter_application_1/states/seller_service.dart';
import 'package:flutter_application_1/states/rider_service.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/buyerService': (BuildContext context) => BuyerService(),
  '/sellerService': (BuildContext context) => SellerService(),
  '/riderService': (BuildContext context) => RiderService(),
  '/addProduct':(BuildContext context) => AddProduct(),
};

// set null = ?
String? initalRoute;

// void main(){
//   initalRoute = MyConstant.routeAuthen;
//   runApp(MyApp());
// }

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? type = preferences.getString('type');
  print('#TYPE => $type');
  if (type?.isEmpty ?? true) {
    initalRoute = MyConstant.routeAuthen;
    runApp(MyApp());
  } else {
    switch (type) {
      case 'buyer':
        initalRoute = MyConstant.routeBuyerService;
        runApp(MyApp());
        break;
      case 'seller':
        initalRoute = MyConstant.routeSellerService;
        runApp(MyApp());
        break;
      case 'rider':
        initalRoute = MyConstant.routeRiderService;
        runApp(MyApp());
        break;
      default:
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor = MaterialColor(0xff750020, MyConstant().mapMaterialColor);
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initalRoute,
      theme: ThemeData(primarySwatch: materialColor),
    );
  }
}
