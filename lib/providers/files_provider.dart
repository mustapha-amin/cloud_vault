import 'package:cloud_vault/models/cloudvaultfile.dart';
import 'package:cloud_vault/services/database.dart';
import 'package:flutter/material.dart';

class FileProvider extends ChangeNotifier {
  bool isLoading = false;
  bool newImageUploaded = false;
  bool newVideoUploaded = false;
  bool newaudioUploaded = false;
  bool newdocumentUploaded = false;
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

  void toggleNewFileUploaded(bool val) {
    val = !val;
    notifyListeners();
  }

  Future<void> loadFiles(List<CLoudVaultFile> fileList, String? fileType,
      {bool? newFileupladed}) async {
    if (fileList.isEmpty || newFileupladed!) {
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

      toggleNewFileUploaded(newFileupladed!);
    }
  }

  Future<void> deleteFile(
      String? fileType, String? fileName, List<CLoudVaultFile> fileList) async {
    startLoading();
    await DatabaseService().deleteFile(fileType, fileName);
    fileList.removeWhere((item) => item.file!.name == fileName);
    stopLoading();
  }

  void clearList(List<CLoudVaultFile> files) {
    files.clear();
    notifyListeners();
  }
}
