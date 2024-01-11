import 'package:sellerside_app/const/const.dart';
import 'package:sellerside_app/views/widgets/text_style.dart';
import 'package:flutter/services.dart';

Widget customTextField(
    {label, hint, controller, isDesc = false, maxCharacters}) {
  return TextField(
    style: const TextStyle(color: white),
    controller: controller,
    maxLines: isDesc ? 4 : 1,
    inputFormatters:
        isDesc ? null : [LengthLimitingTextInputFormatter(maxCharacters)],
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
