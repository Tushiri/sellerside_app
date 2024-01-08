import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/home_controller.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatsController extends GetxController {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    getChatId();
    super.onInit();
  }

  var chats = firestore.collection(chatsCollection);

  var senderName = Get.arguments[0];
  var senderId = Get.arguments[1];

  var friendName = Get.find<HomeController>().username;
  var currentId = currentUser!.uid;

  var msgController = TextEditingController();

  dynamic chatDocId;
  var isLoading = false.obs;
  getChatId() async {
    isLoading(true);
    await chats
        .where('users', isEqualTo: {senderId: null, currentId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
          if (snapshot.docs.isNotEmpty) {
            chatDocId = snapshot.docs.single.id;
          } else {
            chats.add({
              'created_on': null,
              'last_msg': '',
              'users': {senderId: null, currentId: null},
              'toId': '',
              'fromId': '',
              'friend_name': friendName,
              'sender_name': senderName,
            }).then((value) {
              chatDocId = value.id;
            });
          }
        });
    isLoading(false);
  }

  // ignore: unused_element
  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      String imageUrl = await StoreServices.uploadImage(image.path);

      sendImage(imageUrl);
    }
  }

  sendImage(String imageUrl) async {
    chats.doc(chatDocId).update({
      'created_on': FieldValue.serverTimestamp(),
      'last_msg': "Sent an Image",
      'fromId': senderId,
      'toId': currentId,
    });

    chats.doc(chatDocId).collection(messagesCollection).doc().set({
      'created_on': FieldValue.serverTimestamp(),
      'msg': imageUrl,
      'uid': currentId,
      'is_image': true,
    });
  }

  sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      chats.doc(chatDocId).collection(messagesCollection).add({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
      });

      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'fromId': senderId,
        'toId': currentId,
      });
    }
  }

  Future<void> removeAllChats() async {
    await firestore
        .collection(chatsCollection)
        .doc(chatDocId)
        .collection(messagesCollection)
        .get()
        .then((QuerySnapshot messageSnapshot) {
      for (QueryDocumentSnapshot messageDocument in messageSnapshot.docs) {
        messageDocument.reference.delete();
      }
    });
    await firestore.collection(chatsCollection).doc(chatDocId).delete();
    Get.back();
  }
}
