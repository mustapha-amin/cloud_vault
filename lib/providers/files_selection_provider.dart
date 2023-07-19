import 'package:cloud_vault/models/cloudvaultfile.dart';
import 'package:flutter/material.dart';

class FileSelectionProvider extends ChangeNotifier {
  List<CLoudVaultFile> selectedFiles = [];

  void selectFile(CLoudVaultFile cLoudVaultFile) {
    selectedFiles.add(cLoudVaultFile);
    notifyListeners();
  }

  void unselectFile(int index) {
    selectedFiles.removeAt(index);
    notifyListeners();
  }
}
