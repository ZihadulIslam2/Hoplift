import 'dart:io';

class Attachment {
  final String url;
  final AttachmentType type;

  Attachment({required this.url, required this.type});

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      url: json['url'] ?? '',
      type: AttachmentType.fromString(json['type'] ?? ''),
    );
  }
}


class SendAttachMent {
  final File file;
  final AttachmentType type;

  SendAttachMent({required this.file, required this.type});

  Map<String, dynamic> toJson() {
    return {
      'file': file.path,
      'type': type.name,
    };
  }
}


enum AttachmentType {
  image,
  video,
  audio,
  file,
  unknown;

  static AttachmentType fromString(String type) {
    switch (type) {
      case 'image':
        return AttachmentType.image;
      case 'video':
        return AttachmentType.video;
      case 'audio':
        return AttachmentType.audio;
      case 'file':
        return AttachmentType.file;
      default:
        return AttachmentType.unknown;
    }
  }
}