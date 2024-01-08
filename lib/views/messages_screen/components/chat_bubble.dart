import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

Widget chatBubble(QueryDocumentSnapshot<Object?> document) {
  var data = document.data() as Map<String, dynamic>;

  var t =
      data['created_on'] == null ? DateTime.now() : data['created_on'].toDate();
  var time = intl.DateFormat("h:mma").format(t);
  var messageDate = intl.DateFormat("MMM d, y").format(t);

  void openFullscreenImage(String imageUrl) {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) {
        return SizedBox(
          height: Get.height,
          width: Get.width,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }

  return Directionality(
    textDirection:
        data['uid'] == currentUser!.uid ? TextDirection.ltr : TextDirection.ltr,
    child: Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: data['uid'] == currentUser!.uid ? red : darkGrey,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data['is_image'] == true)
            GestureDetector(
              onTap: () {
                openFullscreenImage(data['msg']);
              },
              child: Image.network(
                data['msg'],
                width: 150,
                height: 150,
              ),
            )
          else
            "${data['msg']}".text.white.size(16).make(),
          10.heightBox,
          // Display date only if it's a new date
          if (messageDate != intl.DateFormat("MMM d, y").format(DateTime.now()))
            messageDate.text.color(white.withOpacity(0.5)).make(),
          time.text.color(white.withOpacity(0.5)).make(),
        ],
      ),
    ),
  );
}
