import 'package:ttrueno_fo827e642a0c4/core/base/base_repository.dart';
import 'package:ttrueno_fo827e642a0c4/modules/message/model/chat_room.dart';
import 'package:ttrueno_fo827e642a0c4/modules/message/model/get_chats_req_param.dart';
import 'package:ttrueno_fo827e642a0c4/modules/message/model/get_messages_param.dart';

import '../../../core/base/success.dart';
import '../../../core/utils/helpers/typedefs.dart';
import '../model/message.dart';
import '../model/send_message_req_param.dart';

abstract base class MessageInterface extends BaseRepository{
  FutureRequest<Success<List<ChatRoom>>> getAllChat(GetChatsParam param);
  
  FutureRequest<Success> sendMessage(SendMessageReqParam param);

  FutureRequest<Success> deleteMessage(String messageId);

  FutureRequest<Success<List<Message>>> getMessages(GetMessagesParam param);

  Stream<Message?> messageStream();

  Stream<ChatRoom?> chatStream();

  void joinRoom(String roomId);

  void leaveRoom(String roomId);
}