import 'package:cloud_vault/models/cloudvaultfile.dart';
import 'package:cloud_vault/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FileProvider extends ChangeNotifier {
  bool isLoading = false;
  bool newFileUploaded = false;
  List<CLoudVaultFile> images = [];
  List<CLoudVaultFile> videos = [];
  List<CLoudVaultFile> audios = [];
  List<CLoudVaultFile> documents = [];

  void startLoading() {
    isLoading = true;
  }

  void stoploading() {
    isLoading = false;
  }

  toggleNewFileUploaded() {
    newFileUploaded = !newFileUploaded;
    notifyListeners();
  }

  void loadFiles(List<CLoudVaultFile> cloudFile, String? fileType) async {
    if (cloudFile.isEmpty) {
      startLoading();
      notifyListeners();
      final data = await DatabaseService().getFiles(fileType);
      // ignore: avoid_function_literals_in_foreach_calls
      data.forEach((file) async => cloudFile.add(CLoudVaultFile(
            file: file,
            url: await file.getDownloadURL(),
          )));

      stoploading();
      notifyListeners();
    } else {
      if (newFileUploaded) {
        final data = await DatabaseService().getFiles(fileType);
        // ignore: avoid_function_literals_in_foreach_calls
        data.forEach(
            (file) async => cloudFile.any((element) => element.file == file)
                ? null
                : cloudFile.add(CLoudVaultFile(
                    file: file,
                    url: await file.getDownloadURL(),
                  )));

        toggleNewFileUploaded();
      }
    }
  }
}
