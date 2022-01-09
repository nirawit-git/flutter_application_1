import 'package:flutter/material.dart';

class MyConstant {
  //Genernal
  static String appName = "Shoppping Mall";

  //Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeBuyerService = '/buyerService';
  static String routeSalerService = '/salerService';
  static String routeRiderService = '/riderService';

  //Image
  static String image1 = 'images/img1.png';
  static String image2 = 'images/img2.png';
  static String image3 = 'images/img3.png';
  static String avatar = 'images/avatar.png';

  // Color
  static Color primary = Color(0xffaa1247);
  static Color dark = Color(0xff750020);
  static Color light = Color(0xffe14f72);

  // Style
  TextStyle h1Style() =>
      TextStyle(fontSize: 28, color: dark, fontWeight: FontWeight.bold);
  TextStyle h2Style() =>
      TextStyle(fontSize: 24, color: dark, fontWeight: FontWeight.w700);
  TextStyle h3Style() =>
      TextStyle(fontSize: 18, color: dark, fontWeight: FontWeight.normal);
  TextStyle txtStyle() =>
      TextStyle(fontSize: 16, color: dark, fontWeight: FontWeight.normal);

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
}
