import 'package:flutter/material.dart';

class MyConstant {
  //Genernal
  static String appName = "Shoppping Mall";
  static String domain = 'https://8afc-184-22-38-191.ngrok.io/shoppingmall-api';

  //Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeBuyerService = '/buyerService';
  static String routeSellerService = '/sellerService';
  static String routeRiderService = '/riderService';
  static String routeAddProduct = '/addProduct';

  //Image
  static String image1 = 'images/img1.png';
  static String image2 = 'images/img2.png';
  static String image3 = 'images/img3.png';
  static String avatar = 'images/avatar.png';
  static String cameraPhoto = 'images/image_icon.png';

  // Color
  static Color primary = Color(0xff8c4aff);
  static Color dark = Color(0xff5316cb);
  static Color light = Color(0xffc37aff);

  Map<int, Color> mapMaterialColor = {
    50: Color.fromRGBO(255, 117, 0, 0.1),
    100: Color.fromRGBO(255, 117, 0, 0.2),
    200: Color.fromRGBO(255, 117, 0, 0.3),
    300: Color.fromRGBO(255, 117, 0, 0.4),
    400: Color.fromRGBO(255, 117, 0, 0.5),
    500: Color.fromRGBO(255, 117, 0, 0.6),
    600: Color.fromRGBO(255, 117, 0, 0.7),
    700: Color.fromRGBO(255, 117, 0, 0.8),
    800: Color.fromRGBO(255, 117, 0, 0.9),
    900: Color.fromRGBO(255, 117, 0, 1.0),
  };

  // Style
  TextStyle h1Style() =>
      TextStyle(fontSize: 28, color: dark, fontWeight: FontWeight.bold);
  TextStyle h2Style() =>
      TextStyle(fontSize: 24, color: dark, fontWeight: FontWeight.w700);
  TextStyle h2WhiteStyle() =>
      TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w700);
  TextStyle h3Style() =>
      TextStyle(fontSize: 18, color: dark, fontWeight: FontWeight.normal);
  TextStyle h3WhiteStyle() => TextStyle(
      fontSize: 18, color: Colors.white, fontWeight: FontWeight.normal);
  TextStyle txtStyle() =>
      TextStyle(fontSize: 16, color: dark, fontWeight: FontWeight.normal);

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
}
