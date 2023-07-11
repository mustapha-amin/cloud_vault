extension SizeFormat on int {
  String get formatFileSize {
    if (this < 1024) {
      return '$this B';
    } else if (this < 1024 * 1024) {
      double kilobytes = this / 1024;
      return '${kilobytes.toStringAsFixed(2)} KB';
    } else if (this < 1024 * 1024 * 1024) {
      double megabytes = this / (1024 * 1024);
      return '${megabytes.toStringAsFixed(2)} MB';
    } else {
      double gigabytes = this / (1024 * 1024 * 1024);
      return '${gigabytes.toStringAsFixed(2)} GB';
    }
  }
}
