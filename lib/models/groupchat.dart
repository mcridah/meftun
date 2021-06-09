import 'chat.dart' show Chat;

class GroupChat extends Chat {
  final int maximumParticipants;
  GroupChat(String id, name,
      [String photoURL = 'group_avatar.png', this.maximumParticipants = 10])
      : super(id, name, photoURL);

  @override
  String get caption => name;
}
