import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/chats_controller.dart';
import 'package:emart_seller/services/store_services.dart';
import 'package:emart_seller/views/messages_screen/components/chat_bubble.dart';
import 'package:emart_seller/views/widgets/loading_indicator.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var controller = Get.put(ChatsController());
  bool showDate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: VxPopupMenu(
          arrowSize: 0.0,
          menuBuilder: () => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red),
                    10.widthBox,
                    const Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ).onTap(() {
                  controller.removeAllChats();
                  VxToast.show(context, msg: "Message Deleted");
                }),
              ),
            ],
          ).box.white.rounded.width(200).make(),
          clickType: VxClickType.singleClick,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "${controller.senderName}".text.color(Colors.black).make(),
              const Icon(
                Icons.more_vert_rounded,
                color: black,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: loadingIndicator(),
                    )
                  : Expanded(
                      child: StreamBuilder(
                        stream: StoreServices.getChatMessages(
                            controller.chatDocId.toString()),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: loadingIndicator(),
                            );
                          } else if (snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: "Send a message..."
                                  .text
                                  .color(fontGrey)
                                  .make(),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data!.docs[index];
                                var previousData = index > 0
                                    ? snapshot.data!.docs[index - 1]
                                    : null;

                                // Check if there is a previous message
                                bool isNewDate = previousData == null ||
                                    (data['created_on']
                                            .toDate()
                                            .difference(
                                                previousData['created_on']
                                                    .toDate())
                                            .inHours >=
                                        24);

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isNewDate) ...[
                                      const SizedBox(height: 8),
                                      _buildDateSeparator(
                                          data['created_on'].toDate()),
                                    ],
                                    Align(
                                      alignment: data['uid'] == currentUser!.uid
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showDate = !showDate;
                                          });
                                        },
                                        child: chatBubble(data, showDate),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
            ),
            10.heightBox,
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.msgController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textfieldGrey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textfieldGrey,
                        ),
                      ),
                      hintText: "Type a message...",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    controller.sendMsg(controller.msgController.text);
                    controller.msgController.clear();
                  },
                  icon: const Icon(Icons.send, color: black),
                ),
              ],
            )
                .box
                .height(80)
                .padding(const EdgeInsets.all(12))
                .margin(const EdgeInsets.only(bottom: 8))
                .make(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSeparator(DateTime date) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 1,
            color: fontGrey.withOpacity(0.5),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            intl.DateFormat("MMM d, y").format(date),
            style: TextStyle(color: fontGrey.withOpacity(0.5)),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 1,
            color: fontGrey.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
