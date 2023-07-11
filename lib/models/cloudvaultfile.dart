import 'package:cloud_firestore/cloud_firestore.dart';

class CLoudVaultFile {
  String? id;
  String? path;
  DateTime? uploadDateTime;
  int? size;

  CLoudVaultFile({this.id, this.path, this.uploadDateTime, this.size});

  factory CLoudVaultFile.fromFirestore(Map<String, dynamic> json) {
    return CLoudVaultFile(
      id: json['id'],
      path: json['path'],
      uploadDateTime: (json['uploadDateTime'] as Timestamp).toDate(),
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'uploadDateTime': uploadDateTime,
      'size': size,
    };
  }
}

