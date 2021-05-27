import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/helpers/msghelper.dart';
import 'package:me_flutting/models/chat.dart';

class ChatItem extends StatefulWidget {
  final Chat chatItem;

  const ChatItem({Key key, this.chatItem}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatItemState(chatItem: chatItem);
}

class ChatItemState extends State<ChatItem> {
  final Chat chatItem;
  String avatarPaths = 'pac.jpg';
  set switchAvatar(bool reset) {
    setState(() {});
    avatarPaths = reset ? 'avatar.png' : 'pac.jpg';
  }

  ChatItemState({Key key, this.chatItem});
  @override
  Widget build(BuildContext context) {
    var lastMsg = getLastMessage(chatItem);

    var isMe = lastMsg.from.id == me.id;
    var isEmpty = lastMsg.body.trim() == '';

    Widget avatarName(String tx, [String av = 'pac.jpg']) {
      return Column(children: [
        Text('$tx:'),
        Padding(padding: EdgeInsets.symmetric(vertical: 2)),
        CircleAvatar(backgroundImage: AssetImage(av))
      ]);
    }

    List<Widget> afterAvatar(String body) {
      return [
        Padding(padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0)),
        Padding(padding: EdgeInsets.only(left: 25.0)),
        Text("${body.length <= 280 ? body : body.substring(0, 280)}")
      ];
    }

    var avatarAndText = <Widget>[];
    avatarAndText.add(avatarName(
        '${lastMsg.from.caption} --> ${lastMsg.chatGroup.caption}',
        avatarPaths));
    avatarAndText.addAll(afterAvatar(lastMsg.body));

    var colorPicked = isEmpty
        ? Colors.white
        : (isMe ? Colors.green.shade100 : Colors.grey.shade300);

    return Card(
      key: ValueKey(chatItem.id),
      color: colorPicked,
      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: Padding(
        child: GestureDetector(
            child: Row(children: avatarAndText),
            onHorizontalDragStart: (d) {
              print('onHorizontalDragStart-> ' + d.kind.toString());
            },
            onHorizontalDragEnd: (d) {
              switchAvatar = false;
              print('onHorizontalDragEnd-> ' +
                  d.velocity.pixelsPerSecond.toString());
            },
            onLongPress: () {
              switchAvatar = true;
              print('onLongPress ');
            }),
        padding: EdgeInsets.all(15.0),
      ),
    );
  }
}
