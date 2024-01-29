import 'package:sellerside_app/const/const.dart';

import 'package:sellerside_app/controllers/products_controller.dart';

import 'package:sellerside_app/views/widgets/custom_textfield.dart';
import 'package:sellerside_app/views/widgets/loading_indicator.dart';

import 'package:sellerside_app/views/widgets/text_style.dart';
import 'package:get/get.dart';

class EditProduct extends StatelessWidget {
  final Map<String, dynamic> productData;
  final String documentId;

  const EditProduct(
      {Key? key, required this.productData, required this.documentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();

    controller.pnameController.text = productData['p_name'];
    controller.pdescController.text = productData['p_desc'];
    controller.ppriceController.text = productData['p_price'];
    controller.pquantityController.text = productData['p_quantity'];
    return Obx(
      () => Scaffold(
        backgroundColor: black,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: boldText(text: "Edit Product", size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      // ignore: use_build_context_synchronously
                      await controller.updateProduct(context, documentId);
                      controller.isloading(false);
                      Get.back();
                    },
                    child: boldText(text: save, color: white),
                  ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTextField(
                    hint: "eg. BMW",
                    label: "Product name",
                    controller: controller.pnameController,
                    maxCharacters: 16),
                10.heightBox,
                customTextField(
                    hint: "eg. Nice product",
                    label: "Description",
                    isDesc: true,
                    controller: controller.pdescController),
                10.heightBox,
                customTextField(
                    hint: "eg. P100",
                    label: "Price",
                    controller: controller.ppriceController),
                10.heightBox,
                customTextField(
                    hint: "eg. 20",
                    label: "Quantity",
                    controller: controller.pquantityController),
                10.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
