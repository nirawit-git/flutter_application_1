import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/utility/my_dialog.dart';
import 'package:flutter_application_1/widgets/show_imgae.dart';
import 'package:flutter_application_1/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool stateRedEye = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double iSize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                buildImage(iSize),
                buildAppName(),
                buildUser(iSize),
                buildPassword(iSize),
                buildLogin(iSize),
                buildCreateAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildCreateAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: 'Non Account ?',
          textStyle: MyConstant().txtStyle(),
        ),
        TextButton(
          onPressed: () =>
              Navigator.pushNamed(context, MyConstant.routeCreateAccount),
          child: Text('Create Account'),
        ),
      ],
    );
  }

  Row buildLogin(double iSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: iSize * 0.6,
          // height: 50,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () {
              if (formKey.currentState!.validate() && passwordController.text.isEmpty!=true) {
                String user = userController.text;
                String password = passwordController.text;
                print('## user = $user,password = $password');
                checkAuthen(user, password);
              }
            },
            child: Text('Login'),
          ),
        ),
      ],
    );
  }

  Future<Null> checkAuthen(String? user, String? password) async {
    String apiUrl =
        '${MyConstant.domain}/getUserWhereUser.php?isAdd=true&user=$user&password=$password';
    await Dio().get(apiUrl).then((value) async{
      print('## value API = ==> $value');
      if (value.toString() == 'null') {
        MyDialog()
            .normalDialog(context, 'User False', 'ไม่พบ $user ในฐานข้อมูล');
      } else {
        for (var item in json.decode(value.data)) {
          UserModel model = UserModel.fromMap(item);
          if (password == model.password) {
            // Auth Success
            String type = model.type;
            print('Auth Success');
            print('### Login by TYPE = $type');

            SharedPreferences preferences = await SharedPreferences.getInstance();
            preferences.setString('type', type);
            preferences.setString('user', model.user);

            switch (type) {
              case 'buyer':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeBuyerService, (route) => false);
                break;
              case 'seller':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeSellerService, (route) => false);
                break;
              case 'rider':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeRiderService, (route) => false);
                break;
              default:
            }
          } else {
            //Auth False
            MyDialog().normalDialog(
                context, 'รหัสผ่านผิดพลาด', 'กรุณาลองใหม่าอีกครั้ง!');
          }
        }
      }
    });
  }

  Row buildUser(double iSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(top: 16),
            width: iSize * 0.6,
            child: TextFormField(
              controller: userController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอก User ด้วยคะ';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                  labelStyle: MyConstant().h3Style(),
                  labelText: 'User : ',
                  prefixIcon: Icon(Icons.account_circle_outlined,
                      color: MyConstant.dark),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyConstant.dark),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyConstant.light),
                    borderRadius: BorderRadius.circular(30),
                  ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            )),
      ],
    );
  }

  Row buildPassword(double iSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: iSize * 0.6,
          child: TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก Password ด้วยคะ';
              } else {
                return null;
              }
            },
            obscureText: stateRedEye,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    stateRedEye = !stateRedEye;
                  });
                },
                icon: stateRedEye
                    ? Icon(Icons.visibility, color: MyConstant.dark)
                    : Icon(Icons.visibility_off, color: MyConstant.dark),
              ),
              labelStyle: MyConstant().h3Style(),
              labelText: 'Password : ',
              prefixIcon: Icon(Icons.lock_outline, color: MyConstant.dark),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.dark),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyConstant.light),
                borderRadius: BorderRadius.circular(30),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(title: MyConstant.appName, textStyle: MyConstant().h1Style()),
      ],
    );
  }

  Row buildImage(double iSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: iSize * 0.7, child: ShowImage(path: MyConstant.image3)),
      ],
    );
  }
}
