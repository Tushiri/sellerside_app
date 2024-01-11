import 'package:sellerside_app/const/const.dart';

Widget loadingIndicator({circleColor = white}) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(circleColor),
    ),
  );
}
