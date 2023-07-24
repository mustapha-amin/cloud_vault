import 'dart:developer';
import 'dart:io';
import 'package:cloud_vault/views/widgets/error_dialog.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

class PDFService {
  static Future<String?> loadDocument(BuildContext context, String? url) async {
    try {
      final fileName = _stripAuthParamsFromURL(url!.split('/').last);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      if (await file.exists()) {
        return file.path;
      }
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

  // static loadPDF(String? url) async {
  //   await compute(_loadPDF, url);
  // }

  // static Future<String?> showAndDisplayPdf(
  //     BuildContext context, String url) async {
  //   final result = await loadPdf(url);
  //   if (result != null || result != 'An error occured') {
  //     return result;
  //   } else {
  //     showErrorDialog(context, result);
  //     return 'error';
  //   }
  // }
}
