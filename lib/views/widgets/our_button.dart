import 'package:sellerside_app/const/const.dart';
import 'package:sellerside_app/views/widgets/text_style.dart';

Widget ourButton({title, color = black, onPress}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: color,
        padding: const EdgeInsets.all(12),
      ),
      onPressed: onPress,
      child: normalText(
        text: title,
        size: 16.0,
      ));
}
