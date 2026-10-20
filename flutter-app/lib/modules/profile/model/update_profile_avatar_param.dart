import 'dart:typed_data';

import 'package:dio/dio.dart';

class UploadProfileAvatarParam {
  final String userId;
  final String fileName;
  final Uint8List bytes;

  UploadProfileAvatarParam({
    required this.userId,
    required this.fileName,
    required this.bytes,
  });

  Future<FormData> toFormData() async {
    final formData = FormData.fromMap({
      'profileImage': MultipartFile.fromBytes(bytes, filename: fileName),
    });
    return formData;
  }
}