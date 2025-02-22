import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToaster(String? message){
  Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 12.0
  );
}

