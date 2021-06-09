import '../models/chat.dart' show Chat;
//import '../models/directchat.dart' show DirectChat;
//import '../models/groupchat.dart' show GroupChat;
import '../models/message.dart' show Message;
//import '../models/mbody.dart' show MBody, RawBody;
import 'sql_helper.dart';

class ChatTable extends TableEntity<ChatModel> {
  ChatTable()
      : super(
            'tb_chats',
            'id nvarchar(200) primary key not null,'
                'caption nvarchar(15) not null,'
                'photo_url nvarchar(200) not null,'
                'type integer not null');

  @override
  ChatModel from(Map<String, dynamic> _map) {
    return ChatModel(
      _map['id'],
      _map['caption'],
      _map['photo_url'],
      _map['type'],
    );
  }

  Future<void> insertChat(Chat item) async {
    super.insert(
        ChatModel(item.id, item.caption, item.photoURL, item.type as int));
  }
}

class ChatModel with ModelBase {
  final String id;
  final String caption;
  final String photoURL;
  final int type;
  const ChatModel(this.id, this.caption, this.photoURL, this.type);

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'caption': caption,
        'photo_url': photoURL,
        'type': type,
      };
}

// /// ////

class MessageTable extends TableEntity<MessageModel> {
  MessageTable()
      : super(
            'tb_messages',
            'id nvarchar(200) primary key not null,'
                'body nvarchar(900) not null,'
                'from_id nvarchar(200) not null,'
                'chat_group_id nvarchar(200) not null,'
                'epoch integer not null');

  @override
  MessageModel from(Map<String, dynamic> _map) {
    return MessageModel(
      _map['id'],
      _map['body'],
      _map['from_id'],
      _map['chat_group_id'],
      _map['epoch'],
    );
  }

  Future<void> insertMessage(Message item) async {
    super.insert(MessageModel(item.id, item.body.toString(), item.from.id,
        item.chatGroup.id, item.epoch));
  }
}

class MessageModel with ModelBase {
  final String id;
  final String body;
  final String fromId;
  final String chatGroupId;
  final int epoch;
  const MessageModel(
      this.id, this.body, this.fromId, this.chatGroupId, this.epoch);

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'body': body,
        'from_id': fromId,
        'chat_group_id': chatGroupId,
        'epoch': epoch,
      };
}