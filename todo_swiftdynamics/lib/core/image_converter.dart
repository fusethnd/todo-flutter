import 'dart:convert';
import 'dart:io';

class ImageConverter {
  static Future<String> toBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }
}