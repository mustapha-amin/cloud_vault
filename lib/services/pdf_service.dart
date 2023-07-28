import 'dart:io';
import 'package:cloud_vault/views/widgets/error_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

class PDFService {
  
  static Future<String?> loadDocument(BuildContext context, String? url) async {
    try {
      final fileName = _stripAuthParamsFromURL(url!.split('/').last);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      try {
        await Dio().download(url, file.path);
        return file.path;
      } catch (e) {
        showErrorDialog(context, e.toString());
        return null;
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<bool> fileExists(String url) async {
    final fileName = _stripAuthParamsFromURL(url.split('/').last);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    return await file.exists();
  }

  static openLocalFile(String filePath) async {
    await OpenFile.open(filePath);
  }

  static String _stripAuthParamsFromURL(String url) {
    if (url.contains('?')) {
      return url.substring(0, url.indexOf('?'));
    } else {
      return url;
    }
  }

}
