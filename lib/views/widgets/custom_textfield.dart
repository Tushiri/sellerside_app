import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:flutter/services.dart';

Widget customTextField({label, hint, controller, isDesc = false}) {
  return TextField(
    inputFormatters: [
      LengthLimitingTextInputFormatter(20),
    ],
    style: const TextStyle(color: white),
    controller: controller,
    maxLines: isDesc ? 4 : 1,
    decoration: InputDecoration(
        isDense: true,
        label: boldText(text: label),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: white,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: white,
            )),
        hintText: hint,
        hintStyle: const TextStyle(color: lightGrey)),
  );
}
