//universal package
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';
import 'dart:convert'; // will covert the byte to 64  

//file pdf & excel
Future<void> saveAndLaunchFile(List<int> bytes, String fileName,BuildContext context) async {
  AnchorElement(
      href:
          "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
    ..setAttribute("download", fileName)
    ..click();
}

