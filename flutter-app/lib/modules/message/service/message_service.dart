import 'package:flutter/rendering.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/success.dart';
import 'package:ttrueno_fo827e642a0c4/core/constants/api_endpoints.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/typedefs.dart';
import 'package:ttrueno_fo827e642a0c4/core/services/app_pigeon/app_pigeon.dart';
import 'package:ttrueno_fo827e642a0c4/modules/message/interface/message_interface.dart';
import 'package:ttrueno_fo827e642a0c4/modules/message/model/chat_room.dart';
import 'package:ttrueno_fo827e642a0c4/modules/message/model/message.dart';
import 'package:ttrueno_fo827e642a0c4/modules/message/model/send_message_req_param.dart';
import '../../../core/utils/helpers/format_response_data.dart';
import '../model/get_chats_req_param.dart';
import '../model/get_messages_param.dart';

base class MessageService extends MessageInterface{
  final AppPigeon appPigeon;

  MessageService(this.appPigeon);

  @override
  FutureRequest<Success<List<Message>>> getMessages(GetMessagesParam param) async {
    return await asyncTryCatch(
      tryFunc: () async{
        final response = await appPigeon.get(ApiEndpoints.getMessages(param.chatId), query: param.toMap());
        debugPrint("Get messages response: ${extractBodyData(response)["messages"]}");
        final messages = (extractBodyData(response)["messages"] as List<dynamic>).map((e) => Message.fromJson(e)).toList();
        return Success(message: extractSuccessMessage(response), data: messages);
      },
    );
  }

  @override
  Stream<Message?> messageStream() {
    return appPigeon.listen("newMessage").map((e) {
      try {
        debugPrint("New message: $e");
        final message = Message.fromJson(e);
        debugPrint("Parsed new message: $message");
        return message;
      } catch (e) {
        return null;
      }
    });
  }

  @override
  FutureRequest<Success> sendMessage(SendMessageReqParam param) async{
    return await asyncTryCatch(
      tryFunc: () async{
        debugPrint(( param.toMap()).toString());
        final response = await appPigeon.post(
          ApiEndpoints.sendMessage(param.chatId),
          data: param.toMap(),
        );
        return Success(message: extractSuccessMessage(response));
      },
    );
  }
  
  @override
  FutureRequest<Success> deleteMessage(String messageId) async{
    return asyncTryCatch(
      tryFunc: () async{
        final response = await appPigeon.delete(ApiEndpoints.deleteMessage(messageId));
        return Success(message: extractSuccessMessage(response));
      },
    );
  }

  @override
  FutureRequest<Success<List<ChatRoom>>> getAllChat(GetChatsParam param) async{
    return await asyncTryCatch(
      tryFunc: () async{
        final response = await appPigeon.get(ApiEndpoints.getAllChat, query: param.toMap());
        debugPrint("Get all chat response: ${extractBodyData(response)}");
        final chatRooms = (extractBodyData(response) as List<dynamic>).map((e) => ChatRoom.fromJson(e)).toList();
        return Success(message: extractSuccessMessage(response), data: chatRooms);
      },
    );
  }
  
  @override
  void joinRoom(String roomId) {
    appPigeon.emit("joinRoom", roomId);
  }

  @override
  void leaveRoom(String roomId) {
    appPigeon.emit("leaveRoom", roomId);
  }
  
  @override
  Stream<ChatRoom?> chatStream() {
    return appPigeon.listen("roomCreated").map((e) {
      try {
        final chatRoom = ChatRoom.fromJson(e);
        return chatRoom;
      } catch (e) {
        return null;
      }
    });
  }
}
