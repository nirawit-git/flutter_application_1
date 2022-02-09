import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utility/my_constant.dart';
import 'package:flutter_application_1/utility/my_dialog.dart';
import 'package:flutter_application_1/widgets/show_imgae.dart';
import 'package:flutter_application_1/widgets/show_title.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final formKey = GlobalKey<FormState>();
  List<File?> files = [];
  File? file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialFile();
  }

  void initialFile() {
    for (var i = 0; i < 4; i++) {
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        actions: [
          IconButton(
              onPressed: () => processAddProduct(),
              icon: Icon(Icons.cloud_upload))
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    buildProductName(constraints),
                    buildProductPrice(constraints),
                    buildProductDetail(constraints),
                    buildImage(constraints),
                    addProductButton(constraints)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container addProductButton(BoxConstraints constraints) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      width: constraints.maxWidth * 0.7,
      child: ElevatedButton(
        onPressed: () {
          processAddProduct();
        },
        child: Text('Add Product'),
        style: MyConstant().myButtonStyle(),
      ),
    );
  }

  Future<Null> processAddProduct() async {
    if (formKey.currentState!.validate()) {
      bool checkFile = true;
      for (var i in files) {
        if (i == null) {
          checkFile = false;
        }
      }
      if (checkFile) {
        print('File 4 image ##seccess');
        String urlApi = '${MyConstant.domain}/saveProduct.php';

        for (var item in files) {
          int i = Random().nextInt(10000000);
          String nameFile = 'product${i}.jpg';
          Map<String, dynamic> map = {};
          map['file'] =
              await MultipartFile.fromFile(item!.path, filename: nameFile);
          FormData data = FormData.fromMap(map);
          await Dio()
              .post(urlApi, data: data)
              .then((value) => print('upload success'));
        }
      } else {
        MyDialog().normalDialog(
            context, 'ข้อความแจ้งเตือน', 'กรุณาเลือกรูปภาพ ให้ครบด้วยคะ!');
      }
    }
  }

  Future<Null> processImagePicker(ImageSource source, int index) async {
    try {
      var result = await ImagePicker()
          .pickImage(source: source, maxWidth: 800, maxHeight: 800);

      setState(() {
        file = File(result!.path);
        files[index] = file;
      });
    } catch (e) {}
  }

  Future<Null> chooseSourceImageDialog(int index) async {
    print('Click From index =>>> $index');
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: ListTile(
                title: ShowTitle(
                  title: 'เลือกรูปภาพที่ ${index + 1}',
                  textStyle: MyConstant().h2Style(),
                ),
                subtitle: ShowTitle(
                    title: 'กรุณาเลือกรูป หรือ ถ่ายภาพ',
                    textStyle: MyConstant().h3Style()),
                leading: files[index] == null
                    ? Image.asset(MyConstant.cameraPhoto)
                    : Image.file(
                        files[index]!,
                        fit: BoxFit.cover,
                      ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      icon: Icon(Icons.camera_alt),
                      label: Text('Camera'),
                      onPressed: () {
                        Navigator.pop(context);
                        processImagePicker(ImageSource.camera, index);
                      },
                    ),
                    TextButton.icon(
                      icon: Icon(Icons.drive_folder_upload),
                      label: Text('Gallery'),
                      onPressed: () {
                        Navigator.pop(context);
                        processImagePicker(ImageSource.gallery, index);
                      },
                    ),
                  ],
                ),
              ],
            ));
  }

  Column buildImage(BoxConstraints constraints) {
    return Column(
      children: [
        Container(
          width: constraints.maxWidth * 0.9,
          height: constraints.maxHeight * 0.7,
          child: file == null
              ? Image.asset(MyConstant.cameraPhoto)
              : Image.file(file!),
        ),
        Container(
          width: constraints.maxWidth * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(0),
                  child: files[0] == null
                      ? Image.asset(MyConstant.cameraPhoto)
                      : Image.file(
                          files[0]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(1),
                  child: files[1] == null
                      ? Image.asset(MyConstant.cameraPhoto)
                      : Image.file(
                          files[1]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(2),
                  child: files[2] == null
                      ? Image.asset(MyConstant.cameraPhoto)
                      : Image.file(
                          files[2]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  onTap: () => chooseSourceImageDialog(3),
                  child: files[3] == null
                      ? Image.asset(MyConstant.cameraPhoto)
                      : Image.file(
                          files[3]!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProductName(BoxConstraints constraints) {
    return Container(
        width: constraints.maxWidth * 0.8,
        margin: EdgeInsets.only(top: 16),
        // width: iSize * 0.6,
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอก ชื่อสินค้า ด้วยคะ';
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              labelStyle: MyConstant().h3Style(),
              labelText: 'Product Name: ',
              prefixIcon: Icon(Icons.production_quantity_limits_sharp,
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
              )),
        ));
  }

  Widget buildProductPrice(BoxConstraints constraints) {
    return Container(
        width: constraints.maxWidth * 0.8,
        margin: EdgeInsets.only(top: 16),
        // width: iSize * 0.6,
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอก ราคาสินค้า ด้วยคะ';
            } else {
              return null;
            }
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelStyle: MyConstant().h3Style(),
            labelText: 'Product Price: ',
            prefixIcon: Icon(Icons.attach_money, color: MyConstant.dark),
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
        ));
  }

  Widget buildProductDetail(BoxConstraints constraints) {
    return Container(
        width: constraints.maxWidth * 0.8,
        margin: EdgeInsets.only(top: 16),
        // width: iSize * 0.6,
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'กรุณากรอก รายละเอียดสินค้า ด้วยคะ';
            } else {
              return null;
            }
          },
          maxLines: 5,
          decoration: InputDecoration(
            labelStyle: MyConstant().h3Style(),
            hintText: 'Product Detail: ',
            prefixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
              child: Icon(Icons.details_outlined, color: MyConstant.dark),
            ),
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
        ));
  }
}
