import '../models/chat.dart' show Chat;
import '../models/directchat.dart' show DirectChat;
import '../models/groupchat.dart' show GroupChat;
import '../models/message.dart' show Message;
import '../models/mbody.dart' show MBody, RawBody, ImageBody;
import 'sql_helper.dart';

class ChatTable extends TableEntity<ChatModel> {
  ChatTable() : super('tb_chats');

  @override
  ChatModel from(Map<String, dynamic> _map) {
    return ChatModel(
      _map['id'],
      _map['user_name'],
      _map['name'],
      _map['photo_url'],
      _map['_type'],
    );
  }

  Future<void> insertChat(Chat item) async {
    super.insert(ChatModel(item.id, item.caption, item.name, item.photoURL,
        item is DirectChat ? 0 : 1));
  }
}

class ChatModel with ModelBase {
  final String id;
  final String userName;
  final String name;
  final String photoURL;
  final int type;
  const ChatModel(this.id, this.userName, this.name, this.photoURL, this.type);

  @override
  String get getId => id;

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'user_name': userName,
        'name': name,
        'photo_url': photoURL,
        '_type': type,
      };

  Chat toChat() {
    if (type == 0)
      return DirectChat(id, userName, name, photoURL);
    else
      return GroupChat(id, name, photoURL);
  }
}

// /// ////

class MessageTable extends TableEntity<MessageModel> {
  MessageTable() : super('tb_messages');

  @override
  MessageModel from(Map<String, dynamic> _map) {
    return MessageModel(
      _map['id'],
      _map['body'],
      _map['from_id'],
      _map['chat_group_id'],
      _map['epoch'],
      _map['mbody_type'],
    );
  }

  Future<void> insertMessage(Message item) async {
    super.insert(MessageModel(item.id, item.body.toString(), item.from.id,
        item.chatGroup.id, item.epoch, item.body.bodyType));
  }

  Future<Message> getMessageDetails(
      bool Function(MessageModel) predicate) async {
    final chatSource = context.tableEntityOf<ChatTable>();
    final msgModel = await super.single(predicate);
    final from = await chatSource.single((m) => m.id == msgModel.fromId);
    final to = await chatSource.single((m) => m.id == msgModel.chatGroupId);
    final bodyObj = (String bt, String mb) {
      switch (bt) {
        case MBody.IMAGE_MESSAGE:
          return ImageBody(mb);
        case MBody.FILE_MESSAGE:
        case MBody.JSON_MESSAGE:
        case MBody.RAW_MESSAGE:
        default:
          return RawBody(mb);
      }
    };
    return Message(msgModel.id, bodyObj(msgModel.mbodyType, msgModel.body),
        from.toChat(), to.toChat(), msgModel.epoch);
  }
}

class MessageModel with ModelBase {
  final String id;
  final String body;
  final String fromId;
  final String chatGroupId;
  final int epoch;
  final String mbodyType;
  const MessageModel(this.id, this.body, this.fromId, this.chatGroupId,
      this.epoch, this.mbodyType);

  @override
  String get getId => id;

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'body': body,
        'from_id': fromId,
        'chat_group_id': chatGroupId,
        'epoch': epoch,
        'mbody_type': mbodyType,
      };
}
