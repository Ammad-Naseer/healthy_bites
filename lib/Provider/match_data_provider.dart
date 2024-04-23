// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';

class Matchdate extends ChangeNotifier {
  var datestore;

  storeDate(date) {
    datestore = date;
    notifyListeners();
  }
}
