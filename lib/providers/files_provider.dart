
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
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  void toggleNewFileUploaded() {
    newFileUploaded = !newFileUploaded;
    notifyListeners();
  }

  Future<void> loadFiles(List<CLoudVaultFile> fileList, String? fileType) async {
    if (fileList.isEmpty || newFileUploaded) {
      startLoading();

      final data = await DatabaseService().getFiles(fileType);
      final urls = await Future.wait(data.map((file) => file.getDownloadURL()));

      final newFiles = data.map((file) {
        final url = urls[data.indexOf(file)];
        return CLoudVaultFile(file: file, url: url);
      }).toList();

      fileList.clear();
      fileList.addAll(newFiles);

      stopLoading();
      toggleNewFileUploaded();
    }
  }
}
