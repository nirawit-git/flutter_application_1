import 'package:flutter/material.dart';
import 'package:flutter_application_1/utility/my_constant.dart';

class ShowTitle extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;
  const ShowTitle({Key? key, required this.title, required this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: textStyle == null ? MyConstant().h3Style() : textStyle);
  }
}
