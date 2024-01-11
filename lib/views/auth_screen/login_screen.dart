import 'package:sellerside_app/const/const.dart';
import 'package:sellerside_app/controllers/auth_controller.dart';
import 'package:sellerside_app/views/widgets/loading_indicator.dart';
import 'package:sellerside_app/views/widgets/our_button.dart';
import 'package:sellerside_app/views/widgets/text_style.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              40.heightBox,
              boldText(text: appname, size: 20.0).centered(),
              30.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    icLogo,
                    width: 70,
                    height: 70,
                  )
                      .box
                      .border(color: white)
                      .rounded
                      .padding(const EdgeInsets.all(10))
                      .make(),
                  10.widthBox,
                ],
              ),
              40.heightBox,
              normalText(text: loginTo, size: 18.0, color: lightGrey),
              10.heightBox,
              Obx(
                () => Column(
                  children: [
                    TextFormField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                        fillColor: textfieldGrey,
                        filled: true,
                        prefixIcon: Icon(Icons.email, color: purpleColor),
                        border: InputBorder.none,
                        hintText: emailHint,
                      ),
                    ),
                    10.heightBox,
                    TextFormField(
                      obscureText: true,
                      controller: controller.passwordController,
                      decoration: const InputDecoration(
                        fillColor: textfieldGrey,
                        filled: true,
                        prefixIcon: Icon(Icons.lock, color: purpleColor),
                        border: InputBorder.none,
                        hintText: passwordHint,
                      ),
                    ),
                    10.heightBox,
                    20.heightBox,
                    SizedBox(
                      width: context.screenWidth - 100,
                      child: controller.isloading.value
                          ? loadingIndicator(circleColor: black)
                          : ourButton(
                              title: login,
                              onPress: () async {
                                controller.isloading(true);

                                final currentContext = context;

                                await controller
                                    .loginMethod(context: currentContext)
                                    .then((value) {
                                  if (value != null) {
                                    VxToast.show(currentContext,
                                        msg: "Logged in");
                                    controller.isloading(false);
                                  } else {
                                    controller.isloading(false);
                                  }
                                });
                              },
                            ),
                    ),
                  ],
                )
                    .box
                    .white
                    .rounded
                    .outerShadow
                    .padding(const EdgeInsets.all(8))
                    .make(),
              ),
              10.heightBox,
              Center(child: normalText(text: anyProblem, color: lightGrey)),
              const Spacer(),
              Center(child: boldText(text: credit)),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
