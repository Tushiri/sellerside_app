import 'package:emart_seller/const/const.dart';

Widget loadingIndicator({circleColor = white}) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(circleColor),
    ),
  );
}
