import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Models/colors.dart';

class Utils {
  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: MyColors.darkGreen,
        textColor: Colors.white);
  }
}
