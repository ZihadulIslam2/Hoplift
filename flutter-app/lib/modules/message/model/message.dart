import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/attachment.dart';
import 'package:ttrueno_fo827e642a0c4/modules/profile/model/user_profile.dart';

enum MessageType{
  system,
  reply,
  unknown;

  static MessageType fromString(String type){
    switch(type){
      case 'system':
        return MessageType.system;
      case 'reply':
        return MessageType.reply;
      default:
        return MessageType.unknown;
    }
  }
}

class Message {
  final String id;
  final String chatId;
  final UserProfile sender;
  final String message;
  final MessageType type;
  /// Message id
  final String? replyTo;
  final List<String> readBy;
  final List<Attachment> attachMents;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.chatId,
    required this.sender,
    required this.message,
    required this.type,
    required this.replyTo,
    required this.readBy,
    required this.attachMents,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      chatId: json['chatRoom'],
      sender: UserProfile.fromJson(json['sender']),
      message: json['message'],
      type: MessageType.fromString(json['type']),
      replyTo: json['replyTo'],
      readBy: List<String>.from(json['readBy']),
      attachMents: List<Attachment>.from((json['attachments'] as List<dynamic>).map((x) => Attachment.fromJson(x))),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  
}