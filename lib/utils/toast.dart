import 'package:fluttertoast/fluttertoast.dart';
import 'package:laundromat/state/state.dart';

showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    backgroundColor: interfaceState.palette.background,
    textColor: interfaceState.palette.onBackground,
    fontSize: 12.0,
  );
}
