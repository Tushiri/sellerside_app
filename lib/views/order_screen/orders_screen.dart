// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/orders_controller.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/views/order_screen/order_details.dart';
import 'package:emart_seller/views/widgets/appbar_widget.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  String _getPaymentStatus(QueryDocumentSnapshot<Object?> document) {
    var data = document.data() as Map<String, dynamic>?;

    // Check if 'payment_status' key exists in the document data
    if (data != null && data.containsKey('payment_status')) {
      var paymentStatus = data['payment_status'];
      return paymentStatus == 'paid' ? 'Paid' : 'Unpaid';
    } else {
      // Handle the case where 'payment_status' is not present
      return 'Payment Status N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var controller = Get.put(OrdersController());

    return Scaffold(
      appBar: appbarWidget(orders),
      body: StreamBuilder(
          stream: StoreServices.getOrders(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndicator();
            } else {
              var data = snapshot.data!.docs;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(data.length, (index) {
                      var time = data[index]['order_date'].toDate();
                      return ListTile(
                        onTap: () {
                          Get.to(() => OrderDetails(data: data[index]));
                        },
                        tileColor: textfieldGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: boldText(
                            text: "${data[index]['order_code']}",
                            color: purpleColor),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_month,
                                    color: fontGrey),
                                10.widthBox,
                                boldText(
                                    text: intl.DateFormat()
                                        .add_yMd()
                                        .format(time),
                                    color: fontGrey),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.payment, color: fontGrey),
                                10.widthBox,
                                boldText(
                                    text: _getPaymentStatus(data[index]),
                                    color: red),
                              ],
                            ),
                          ],
                        ),
                        trailing: boldText(
                            text: "P ${data[index]['total_amount']}",
                            color: purpleColor,
                            size: 16.0),
                      )
                          .card
                          .rounded
                          .make()
                          .box
                          .margin(const EdgeInsets.only(bottom: 4))
                          .make();
                    }),
                  ),
                ),
              );
            }
          }),
    );
  }
}
