import 'package:cloud_vault/models/cloudvaultfile.dart';
import 'package:flutter/material.dart';

class FileSelectionProvider extends ChangeNotifier {
  List<CLoudVaultFile> selectedFiles = [];
  bool isLongPressed = false;

  void selectFile(CLoudVaultFile cloudVaultFile) {
    selectedFiles.add(cloudVaultFile);
    notifyListeners();
  }

  void unselectFile(CLoudVaultFile cloudVaultFile) {
    selectedFiles.remove(cloudVaultFile);
    notifyListeners();
  }

  void toggleIsLongedPressed() {
    isLongPressed = !isLongPressed;
    notifyListeners();
  }

  bool containsFile(CLoudVaultFile cloudVaultFile) {
    return selectedFiles.contains(cloudVaultFile);
  }

  void clearSelected(){
    selectedFiles.clear();
    notifyListeners();
  }

 
}
