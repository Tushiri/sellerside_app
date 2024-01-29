import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: unused_import
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sellerside_app/const/const.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class StoreServices {
  final String serverKey =
      'AAAA7im93nI:APA91bFVkS7yR_ReXHg7ta5NfW6KAcVC_f4JPfRHkURPfm2HynHnSKdBUTSpffZkXGK7TSFfIxZyV1Rs_hUO49Ujlv7eAWJSPFkYODurdz2wM6OpiHdaX9j6CeGYehbwUqtbuX_uH0H0';
  static Future<String> uploadImage(String filePath) async {
    File file = File(filePath);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference storageReference =
        FirebaseStorage.instance.ref().child('chat_images/$fileName');

    UploadTask uploadTask = storageReference.putFile(file);

    await uploadTask.whenComplete(() => null);

    return storageReference.getDownloadURL();
  }

  static getProfile(uid) {
    return firestore
        .collection(vendorsCollection)
        .where('id', isEqualTo: uid)
        .get();
  }

  static getMessages(uid) {
    return firestore
        .collection(chatsCollection)
        .where('toId', isEqualTo: uid)
        .snapshots();
  }

  static getChatMessages(docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messagesCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  static getOrders(uid) {
    return firestore
        .collection(ordersCollection)
        .where('vendors', arrayContains: uid)
        .snapshots();
  }

  static getProducts(uid) {
    return firestore
        .collection(productsCollection)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }

  Future<void> sendOrderStatusNotification(
      String newStatus, String orderId, String userId) async {
    try {
      String? userDeviceToken = await getUserDeviceToken(userId);

      if (userDeviceToken != null && userDeviceToken.isNotEmpty) {
        await sendNotification(
          'Order Status Update',
          'Your order is now $newStatus',
          userId,
          userDeviceToken,
        );
      } else {
        logger.e('Invalid user device token: $userDeviceToken');
      }
    } catch (e) {
      logger.e('Error sending notification: $e');
    }
  }

  // Future<void> sendNotification(String token, String title, String message, type) async{
  //   var headers = {'Content-Type': 'application/json','Authorization': 'key=${Constants.serverKey}'}
  //   var request = http.Request('Post', Uri.parse('https://fcm.googleapis.com/fcm/send'));
  //   request.body = json.encode({
  //     "to": token,
  //     "notification": {"title": title, "body": message},
  //     "data": {"title": title, "body": message, "type": type},
  //   });
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     logger.w("send new sign up response: ${await response.stream.bytesToString()}");

  //   } else {
  //     logger.e("send new sign up error: ${response.reasonPhrase}");
  //   }
  // }
  Future<void> sendNotification(
      String title, String body, String? userId, String deviceToken) async {
    try {
      String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null && userId == null) {
        logger.e('User ID is null. Unable to send notification.');
        return;
      }

      final Uri url = Uri.parse(
          'https://fcm.googleapis.com/v1/projects/your-firebase-project-id/messages:send');

      final Map<String, dynamic> data = {
        'message': {
          'notification': {'title': title, 'body': body},
          'token': deviceToken,
        },
      };

      final String requestBody = jsonEncode(data);

      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKey',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        logger.i('Notification sent successfully');
      } else {
        logger.e(
            'Error sending notification: ${response.statusCode} - ${response.reasonPhrase}');
        logger.d('Request URL: $url');
        logger.d('Request headers: ${response.request?.headers}');
        logger.d('Request body: $requestBody');
        logger.d('Response body: ${response.body}');
      }
    } catch (e) {
      logger.e('Error sending notification: $e');
    }
  }

  Future<String?> getUserDeviceToken(String userId) async {
    try {
      var userDocRef = firestore.collection(vendorsCollection).doc(userId);

      var snapshot = await userDocRef.get();

      if (snapshot.exists) {
        var deviceToken = snapshot.data()?['deviceToken'];
        logger.d('Device token found for user $userId: $deviceToken');
        return deviceToken;
      } else {
        logger.e('User document not found for user $userId');
        return null;
      }
    } catch (e) {
      logger.e('Error getting user device token for user $userId: $e');
      return null;
    }
  }
}
