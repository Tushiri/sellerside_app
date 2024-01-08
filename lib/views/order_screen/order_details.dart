import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/orders_controller.dart';
import 'package:emart_seller/views/order_screen/components/order_place.dart';
import 'package:emart_seller/views/widgets/our_button.dart';
import 'package:emart_seller/views/widgets/text_style.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class OrderDetails extends StatefulWidget {
  final dynamic data;
  const OrderDetails({super.key, this.data});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var controller = Get.find<OrdersController>();

  String _getDeliveryStatusText() {
    if (controller.delivered.value) {
      return "Order Delivered";
    } else if (controller.ondelivery.value) {
      return "Order is on Delivery";
    } else if (controller.confirmed.value) {
      return "Order Confirmed";
    } else {
      return "Order Placed";
    }
  }

  @override
  void initState() {
    super.initState();

    controller.getOrders(widget.data);
    controller.confirmed.value = widget.data['order_confirmed'] ?? false;
    controller.ondelivery.value = widget.data['order_on_delivery'] ?? false;
    controller.delivered.value = widget.data['order_delivered'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back, color: darkGrey)),
          title: boldText(text: "Order details", color: fontGrey, size: 16.0),
        ),
        bottomNavigationBar: Visibility(
          visible: !controller.confirmed.value,
          child: SizedBox(
            height: 60,
            width: context.screenWidth,
            child: ourButton(
              color: green,
              onPress: () async {
                PaymentStatus paymentStatus = PaymentStatus.unpaid;
                if (widget.data['payment_method'] == 'G Cash' ||
                    widget.data['payment_method'] == 'PayMaya') {
                  paymentStatus = PaymentStatus.paid;
                }

                await controller.changePaymentStatus(
                  status: paymentStatus,
                  docID: widget.data.id,
                );

                controller.confirmed(true);
                controller.changeStatus(
                  title: "order_confirmed",
                  status: true,
                  docID: widget.data.id,
                );
              },
              title: "Confirm Order",
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                //order delivery status section
                Visibility(
                  visible: controller.confirmed.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      boldText(
                        text: "Order Status:",
                        color: fontGrey,
                        size: 16.0,
                      ),
                      SwitchListTile(
                        activeColor: green,
                        value: true,
                        onChanged: (value) {},
                        title: boldText(text: "Placed", color: fontGrey),
                      ),
                      SwitchListTile(
                        activeColor: green,
                        value: controller.confirmed.value,
                        onChanged: (value) async {
                          if (value) {
                            await controller.changeStatus(
                              title: "order_confirmed",
                              status: true,
                              docID: widget.data.id,
                            );
                          } else {
                            await controller.changeStatus(
                              title: "order_confirmed",
                              status: false,
                              docID: widget.data.id,
                            );
                          }
                        },
                        title: boldText(text: "Confirmed", color: fontGrey),
                      ),
                      SwitchListTile(
                        activeColor: green,
                        value: controller.ondelivery.value,
                        onChanged: (value) async {
                          if (value) {
                            await controller.changeStatus(
                              title: "order_on_delivery",
                              status: true,
                              docID: widget.data.id,
                            );
                          } else {
                            await controller.changeStatus(
                              title: "order_on_delivery",
                              status: false,
                              docID: widget.data.id,
                            );

                            controller.delivered.value = false;
                          }
                        },
                        title: boldText(text: "on Delivery", color: fontGrey),
                      ),
                      SwitchListTile(
                        activeColor: green,
                        value: controller.delivered.value,
                        onChanged: (value) async {
                          if (value) {
                            await controller.changeStatus(
                              title: "order_delivered",
                              status: true,
                              docID: widget.data.id,
                            );

                            controller.ondelivery.value = true;
                          } else {
                            await controller.changeStatus(
                              title: "order_delivered",
                              status: false,
                              docID: widget.data.id,
                            );
                          }
                        },
                        title: boldText(text: "Delivered", color: fontGrey),
                      ),
                    ],
                  )
                      .box
                      .outerShadowMd
                      .white
                      .border(color: lightGrey)
                      .roundedSM
                      .make(),
                ),

                //order details section
                Column(
                  children: [
                    orderPlaceDetail(
                      d1: "${widget.data['order_code']}",
                      d2: "${widget.data['shipping_method']}",
                      title1: "Order Code",
                      title2: "Shipping Method",
                    ),
                    orderPlaceDetail(
                      d1: intl.DateFormat()
                          .add_yMd()
                          .format((widget.data['order_date'].toDate())),
                      d2: "${widget.data['payment_method']}",
                      title1: "Order Date",
                      title2: "Payment Method",
                    ),
                    orderPlaceDetail(
                      d1: (widget.data['payment_method'] == 'G Cash' ||
                              widget.data['payment_method'] == 'PayMaya')
                          ? "Paid"
                          : "Unpaid",
                      d2: _getDeliveryStatusText(),
                      title1: "Payment Status",
                      title2: "Delivery Status",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              boldText(
                                  text: "Shipping Address", color: purpleColor),
                              "${widget.data['order_by_name']}".text.make(),
                              "${widget.data['order_by_email']}".text.make(),
                              "${widget.data['order_by_street']}".text.make(),
                              "${widget.data['order_by_subdivi']}".text.make(),
                              "${widget.data['order_by_city']}".text.make(),
                              "${widget.data['order_by_phonenumber']}"
                                  .text
                                  .make(),
                              "${widget.data['order_by_postalcode']}"
                                  .text
                                  .make(),
                            ],
                          ),
                          SizedBox(
                            width: 130,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                boldText(
                                    text: "Total Amount", color: purpleColor),
                                boldText(
                                    text: "P ${widget.data['total_amount']}",
                                    color: red,
                                    size: 16.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    .box
                    .outerShadowMd
                    .white
                    .border(color: lightGrey)
                    .roundedSM
                    .make(),
                const Divider(),
                10.heightBox,
                boldText(text: "Ordered Products", color: fontGrey, size: 16.0),
                10.heightBox,
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(controller.orders.length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        orderPlaceDetail(
                            title1: "${controller.orders[index]['title']}",
                            title2: "P ${controller.orders[index]['tprice']}",
                            d1: "${controller.orders[index]['qty']}x",
                            d2: "Refundable"),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: 30,
                            height: 20,
                            color: Color(controller.orders[index]['color']),
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  }).toList(),
                )
                    .box
                    .outerShadowMd
                    .white
                    .margin(const EdgeInsets.only(bottom: 4))
                    .make(),
                20.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
