import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

final logger = Logger();

enum PaymentStatus {
  unpaid,
  paid,
}

class OrdersController extends GetxController {
  var orders = [];

  var confirmed = false.obs;
  var ondelivery = false.obs;
  var delivered = false.obs;

  getOrders(data) {
    orders.clear();
    for (var item in data['orders']) {
      if (item['vendor_id'] == currentUser!.uid) {
        orders.add(item);
      }
    }
  }

  changeStatus({title, status, docID}) async {
    var store = firestore.collection(ordersCollection).doc(docID);
    await store.set({title: status}, SetOptions(merge: true));
    logger.i('Status updated successfully to: $status');
  }

  changePaymentStatus({required PaymentStatus status, required docID}) async {
    try {
      var store = firestore.collection(ordersCollection).doc(docID);
      await store.update({'payment_status': status.toString().split('.').last});
      logger.i('Payment status updated successfully to: $status');
    } catch (e) {
      logger.e('Error updating payment status: $e');
    }
  }
}
