import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';

Future<void> _checkPermission() async {

  final permissionStatus = await Permission.manageExternalStorage.status;
  if (permissionStatus != PermissionStatus.granted) {
    await Permission.manageExternalStorage.request();
  }
}

Future<void> saveAndLaunchFile(List<int> bytes, String fileName, BuildContext context) async {
  String _localPath = (await ExternalPath.getExternalStoragePublicDirectory(
         ExternalPath.DIRECTORY_DOWNLOADS));

  await _checkPermission();
 
  final directory = await getExternalStorageDirectory();
  if (directory == null) {
    // Handle the case where the directory is null
     
     // Display an error message to the user and return
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content:const Text('Could not find external storage directory.'),
        actions: [
          TextButton(
            child:const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
    return;
  }
  
  File file = File('$_localPath/$fileName');
  await file.writeAsBytes(bytes, flush: true);

   final exists = await file.exists();
   if (exists) {
    // Open the file using the OpenFile package
   OpenFile.open('$_localPath/$fileName');
  } else {
    // Handle the case where the file does not exist
    print('File does not exist at $_localPath/$fileName');
  }
  print('$_localPath/$fileName'); // to check the location of path 
}

