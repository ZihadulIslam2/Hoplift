import 'dart:io';

import 'package:dio/dio.dart';


class SendMessageReqParam {
  final String chatId;
  final String? message;
  final String contentType;
  final String? replyTo;
  final List<File>? files;

  SendMessageReqParam({
    required this.chatId,
    this.message,
    this.contentType = 'text',
    this.files,
    this.replyTo
  });

  Map<String, dynamic> toMap() => {
        'chatId': chatId,
        'message': message,
        'contentType': contentType,
        'files': files,
      };

  Future<FormData> toFormData() async{
    final FormData formData = FormData();
    formData.fields.addAll([
      MapEntry('chatId', chatId),
      MapEntry('message', message ?? ''),
      MapEntry('contentType', contentType),
      MapEntry('replyTo', replyTo ?? ''),
    ]);
    if(files != null){
      for(var file in files!){
        formData.files.add(MapEntry('files', await MultipartFile.fromFile(file.path)));
      }
    }
    return formData;
  }

  @override
  String toString() =>
      'SendMessageParams(chatId: $chatId, content: $message, contentType: $contentType, files: ${files?.length})';
}