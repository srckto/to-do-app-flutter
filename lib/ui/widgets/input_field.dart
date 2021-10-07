import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/ui/size_config.dart';
import 'package:to_do_app/ui/theme.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const InputField({
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: k_titleStyle),
          Container(
            margin: EdgeInsets.only(top: 7),
            padding: EdgeInsets.symmetric(horizontal: 13),
            height: 55,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: k_subTitleStyle,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                widget ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
