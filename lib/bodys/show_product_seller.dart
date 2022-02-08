import 'package:flutter/material.dart';
import 'package:flutter_application_1/utility/my_constant.dart';

class ShowManageSeller extends StatefulWidget {
  const ShowManageSeller({Key? key}) : super(key: key);

  @override
  _ShowManageSellerState createState() => _ShowManageSellerState();
}

class _ShowManageSellerState extends State<ShowManageSeller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('ShowProductSeller'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.routeAddProduct),
        child: Icon(Icons.add,size:36,color: Colors.white,),
      ),
    );
  }
}
