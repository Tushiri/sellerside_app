import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

Widget chatBubble(DocumentSnapshot data, bool showDate) {
  var t =
      data['created_on'] == null ? DateTime.now() : data['created_on'].toDate();
  var timeFormat = intl.DateFormat("h:mma");
  var dateFormat = intl.DateFormat("MMM d, y");

  var time = timeFormat.format(t);
  var messageDate = dateFormat.format(t);
  var currentTime = DateTime.now();
  t.isBefore(currentTime.subtract(const Duration(days: 1))) ||
      messageDate != dateFormat.format(currentTime);

  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: data['uid'] == currentUser!.uid ? red : fontGrey,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(20),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "${data['msg']}".text.white.size(16).make(),
        10.heightBox,
        time.text.color(white.withOpacity(0.5)).make(),
      ],
    ),
  );
}
