import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

import 'donor.dart';

class AppState extends ChangeNotifier {
  List<String> _officeNames = new List<String>();
  String _ipReference;
  Set<String> _availableDonorsByOffice = new Set<String>();

  AppState(String ip) {
    _ipReference = ip;
    setOfficeNames();
  }

  void setOfficeNames() async {
    var request = await http.get("http://${_ipReference}:8080/api/office");
    var parsedJson = json.decode(request.body);
    for (var office in parsedJson) {
      _officeNames.add(office['name']);
    }
    notifyListeners();
  }

  /*
  Future<void> setAvailableDonorsByOffice(String officeName) async {
    var request = await http.get(
        "http://${_ipReference}:8080/api/donor/office/$officeName/available");
    var parsedJson = json.decode(request.body);
    for (var office in parsedJson) {
      Donor donor =
          new Donor(office['mail'], office['officePoint'], office['canDonate']);
      _availableDonorsByOffice.add(donor);
    }
    notifyListeners();
  }
  */

  Future<void> setAvailableDonorsByOffice(String officeName) async {
    var request = await http.get(
        "http://${_ipReference}:8080/api/donor/office/$officeName/available");
    var parsedJson = json.decode(request.body);
    for (var office in parsedJson) {
      _availableDonorsByOffice.add(office['mail']);
    }
    notifyListeners();
  }

  List<String> getOfficeNames() {
    return _officeNames;
  }

  Set<String> getAvailableDonorsByOffice() {
    return _availableDonorsByOffice;
  }

  void showFlushbar(
      String title, String message, bool isGood, BuildContext context) {
    Flushbar(
      margin: EdgeInsets.all(8),
      borderRadius: 26,
      shouldIconPulse: true,
      title: title,
      icon: isGood
          ? Icon(
              Icons.check,
              size: 28.0,
              color: Colors.green[600],
            )
          : Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.red[600],
            ),
      message: message,
      duration: Duration(
        seconds: 6,
      ),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    ).show(context);
  }
}
