import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/utility/my_dialog.dart';
import 'package:flutter_application_1/widgets/show_imgae.dart';
import 'package:flutter_application_1/widgets/show_progress.dart';
import 'package:flutter_application_1/widgets/show_title.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String? typeUser;
  String avatar='';
  File? image;
  double? lat, lng;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();
  }

  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print("Geolocator is Open");

      locationPermission = await Geolocator.checkPermission();
      // ตรวจสอบว่า อนุญาต ไหม
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'คุณไม่อนุญาตแชร์ Location', 'โปรดแชร์ Location');
        } else {
          // Find LatLng
          findLatLng();
        }
      } else {
        // ตรวจสอบว่า ไม่อนุญาต ไหม
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'คุณไม่อนุญาตแชร์ Location', 'โปรดแชร์ Location');
        } else {
          // Find LatLng
          findLatLng();
        }
      }
    } else {
      print("Geolocator is Close");
      MyDialog().alertLocationService(context, 'Location Service ปิดอยู่ ?',
          'กรุณาเปิด Location Service ด้วยคะ');
    }
  }

  Future<Null> findLatLng() async {
    print('find latlng');
    Position? position = await findPostion();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
      print('lat:${lat} - lng:${lng}');
    });
  }

  Future<Position?> findPostion() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double iSize = MediaQuery.of(context).size.width * 0.7;
    return Scaffold(
      appBar: AppBar(
        actions: [
          buildCreateNewAccount()
        ],
        title: Text('Create New Account'),
        backgroundColor: MyConstant.primary,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
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
                buildTitle('แสดงพิกัดที่อยู่คุณ'),
                buildMap(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconButton buildCreateNewAccount() {
    return IconButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              if(typeUser == null){
                print('ไม่เลือกประเภท');
                MyDialog().normalDialog(context, 'คุณยังไม่ได้เลือก ประเภท', 'กรุณาเลือก ประเภท ที่ต้องการ');
              }else{
                print('Process Insert to DB');
                uploadPictureAndInsertData();
              }
            }
          },
          icon: Icon(Icons.cloud_upload),
        );
  }

  Future<Null> uploadPictureAndInsertData() async{
    String name = nameController.text;
    String address = addressController.text;
    String phone = phoneController.text;
    String user = userController.text;
    String password = passwordController.text;
    print('## name = ${name}, address = ${address}, phone = ${phone}, user = ${user}, password = ${password}');

    String path = '${MyConstant.domain}/getUserWhereUser.php?isAdd=true&user=${user}';
    await Dio().get(path).then((value) async{

      print('## => ${value}');
      if(value.toString() == 'null'){
        print('## user ok');
        if(image==null){
          // No Avartar
          // Map data = {'name':name,'address':address,'phone':phone,'user':user,'password':password};
          processInsertMySql(name:name,address:address,phone:phone,user: user,password:password);
        }else{
          // Have Avartar
          print('Avartar Upload');
          String nameAvatar = 'avatar${Random().nextInt(1000000)}.jpg';
          Map<String,dynamic> map = Map();
          map['file'] = await MultipartFile.fromFile(image!.path,filename: nameAvatar);
          FormData data = FormData.fromMap(map);
          await Dio().post('${MyConstant.domain}/saveAvatar.php',data: data).then((value) {
            avatar = '/shoppingmall-api/avatar/${nameAvatar}';
            processInsertMySql(name:name,address:address,phone:phone,user: user,password:password);
          });
        }
      }else{
        MyDialog().normalDialog(context,'เกิดข้อผิดพลาด','กรุณาทำรายการใหม่');
      }
    });
  }

  Future processInsertMySql({String? name,String? address,String? phone,String? user,String? password}) async{
    String urlApi = '${MyConstant.domain}/insertUser.php?isAdd=true&name=$name&type=$typeUser&address=$address&phone=$phone&user=$user&password=$password&avatar=$avatar&lat=$lat&lng=$lng';
    await Dio().get(urlApi).then((value) {
      // print(value);
      if(value.toString() == 'true'){
        Navigator.pop(context);
      }else{
        MyDialog().normalDialog(context, 'เกิดข้อผิดพลาด', 'กรุณาลองใหม่อีกครั้ง');
      }
    });
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(lat!, lng!),
          infoWindow: InfoWindow(
              title: 'คุณอยู่ที่นี่',
              snippet: 'ละติจูด = ${lat} , ลองติจูด = ${lng}'),
        ),
      ].toSet();

  Container buildMap() => Container(
      width: double.infinity,
      height: 300,
      child: lat == null
          ? ShowProgress()
          : GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: LatLng(lat!, lng!), zoom: 16),
              onMapCreated: (controller) {},
              markers: setMarker(),
            ));

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      // final imagePermanent = await saveImagePermanently(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  // Future<File> saveImagePermanently(String imagePath) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final name = basename(imagePath);
  //   final image = File('${directory.path}/$name');

  //   return File(imagePath).copy(image.path);
  // }

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
              controller: nameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอก Name ด้วยค่ะ!';
                } else {}
              },
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
              controller: addressController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอก Address ด้วยค่ะ!';
                } else {}
              },
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
              controller: phoneController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอก Phone ด้วยค่ะ!';
                } else {}
              },
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
              controller: userController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอก User ด้วยค่ะ!';
                } else {}
              },
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
              controller: passwordController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอก Password ด้วยค่ะ!';
                } else {}
              },
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
