import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/utility/my_dialog.dart';
import 'package:flutter_application_1/widgets/show_imgae.dart';
import 'package:flutter_application_1/widgets/show_title.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String? typeUser;
  File? image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print("Geolocator is Open");

      // locationPermission = await Geolocator.checkPermission();
      // if (locationPermission == LocationPermission.denied) {
      //   locationPermission = await Geolocator.requestPermission();
      //   if (locationPermission == LocationPermission.denied) {
      //     // Permissions are denied, next time you could try
      //     // requesting permissions again (this is also where
      //     // Android's shouldShowRequestPermissionRationale
      //     // returned true. According to Android guidelines
      //     // your App should show an explanatory UI now.
      //     return Future.error('Location permissions are denied');
      //   }
      // }
    } else {
      print("Geolocator is Close");
      MyDialog().alertLocationService(context, 'Location Service ปิดอยู่ ?',
          'กรุณาเปิด Location Service ด้วยคะ');
    }
  }

  @override
  Widget build(BuildContext context) {
    double iSize = MediaQuery.of(context).size.width * 0.7;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Account'),
        backgroundColor: MyConstant.primary,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: ListView(
          padding: EdgeInsets.all(14),
          children: [
            buildTitle('ข้อมูลทั่วไป'),
            buildName(iSize),
            buildTitle('ชนิดของ User :'),
            buildRadioBuyer(iSize),
            buildRadioSeller(iSize),
            buildRadioRider(iSize),
            buildTitle('ข้อมูลพื้นฐาน'),
            buildAddress(iSize),
            buildPhone(iSize),
            buildUser(iSize),
            buildPassword(iSize),
            buildTitle('รูปภาพ'),
            buildSubTitle(),
            buildAvatar(iSize),
          ],
        ),
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      // final imageTemporary = File(image.path);
      final imagePermanent = await saveImagePermanently(image.path);
      setState(() => this.image = imagePermanent);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  Row buildAvatar(double iSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => pickImage(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: iSize * 0.6,
          child: image != null
              ? ClipOval(
                  child: Image.file(
                    image!,
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                )
              : ShowImage(path: MyConstant.avatar),
        ),
        IconButton(
          onPressed: () => pickImage(ImageSource.gallery),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
      ],
    );
  }

  ShowTitle buildSubTitle() {
    return ShowTitle(
      title: 'เป็นรูปภาพ ที่แสดงเป็นตัวตนของผู้ใช้งาน',
      textStyle: MyConstant().txtStyle(),
    );
  }

  Row buildName(double iSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(top: 16),
            width: iSize,
            child: TextFormField(
              decoration: InputDecoration(
                  labelStyle: MyConstant().h3Style(),
                  labelText: 'ชื่อผุ้ใช้ ',
                  prefixIcon: Icon(Icons.fingerprint, color: MyConstant.dark),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyConstant.dark),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyConstant.light),
                    borderRadius: BorderRadius.circular(30),
                  )),
            )),
      ],
    );
  }

  Row buildRadioBuyer(double iSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: iSize,
          child: RadioListTile(
            value: 'buyer',
            groupValue: typeUser,
            onChanged: (value) {
              setState(() {
                typeUser = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ผุ้ซื้อ (Buyer)',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildRadioSeller(double iSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: iSize,
          child: RadioListTile(
            value: 'seller',
            groupValue: typeUser,
            onChanged: (value) {
              setState(() {
                typeUser = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ผุ้ขาย (Seller)',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRadioRider(double iSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: iSize,
          child: RadioListTile(
            value: 'rider',
            groupValue: typeUser,
            onChanged: (value) {
              setState(() {
                typeUser = value as String?;
              });
            },
            title: ShowTitle(
              title: 'ผุ้ส่ง (Rider)',
              textStyle: MyConstant().h3Style(),
            ),
          ),
        ),
      ],
    );
  }

  Container buildTitle(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ShowTitle(
        title: title,
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  Row buildAddress(double iSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(top: 16),
            width: iSize,
            child: TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                  // labelStyle: MyConstant().h3Style(),
                  // labelText: 'Address ',
                  hintText: 'Address',
                  hintStyle: MyConstant().h3Style(),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: Icon(Icons.home, color: MyConstant.dark),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyConstant.dark),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyConstant.light),
                    borderRadius: BorderRadius.circular(30),
                  )),
            )),
      ],
    );
  }

  Row buildPhone(double iSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(top: 16),
            width: iSize,
            child: TextFormField(
              decoration: InputDecoration(
                  labelStyle: MyConstant().h3Style(),
                  labelText: 'Phone :',
                  prefixIcon: Icon(Icons.phone, color: MyConstant.dark),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyConstant.dark),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyConstant.light),
                    borderRadius: BorderRadius.circular(30),
                  )),
            )),
      ],
    );
  }

  Row buildUser(double iSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(top: 16),
            width: iSize,
            child: TextFormField(
              decoration: InputDecoration(
                  labelStyle: MyConstant().h3Style(),
                  labelText: 'User :',
                  prefixIcon: Icon(Icons.person, color: MyConstant.dark),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyConstant.dark),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyConstant.light),
                    borderRadius: BorderRadius.circular(30),
                  )),
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
            width: iSize,
            child: TextFormField(
              decoration: InputDecoration(
                  labelStyle: MyConstant().h3Style(),
                  labelText: 'Password :',
                  prefixIcon: Icon(Icons.lock_outline, color: MyConstant.dark),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyConstant.dark),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyConstant.light),
                    borderRadius: BorderRadius.circular(30),
                  )),
            )),
      ],
    );
  }
}
