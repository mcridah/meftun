import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/models/chat.dart';
import 'package:me_flutting/pages/texting.dart';

import '../main.dart';

class ChatItem extends StatefulWidget {
  final Chat chatItem;
  final void Function(String) onMsgSent;

  const ChatItem(this.chatItem, this.onMsgSent, [Key key]) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatItemState();
}

class ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    var lastMsg = msgFactory.getLastMessage(widget.chatItem);

    if (lastMsg.body == null) {
      return Row();
    }

    Widget avatarName(String tx, String av) {
      return Column(children: [
        Text('$tx'),
        Padding(padding: EdgeInsets.symmetric(vertical: 3)),
        CircleAvatar(backgroundImage: AssetImage(av))
      ]);
    }

    List<Widget> afterAvatar(String body) {
      return [
        Padding(padding: EdgeInsets.symmetric(horizontal: 11.0)),
        Padding(padding: EdgeInsets.only(left: 15.0)),
        Text("${body.length <= 280 ? body : body.substring(0, 280)}")
      ];
    }

    var avatarAndText = <Widget>[];
    avatarAndText.add(avatarName(
        '${lastMsg.from == msgFactory.owner ? 'YOU' : lastMsg.from.caption}',
        lastMsg.from.photoURL));

    avatarAndText.add(Text('    ->    '));

    avatarAndText.add(avatarName(
        '${lastMsg.chatGroup == msgFactory.owner ? 'YOU' : lastMsg.chatGroup.caption}',
        lastMsg.chatGroup.photoURL));

    avatarAndText.add(Padding(padding: EdgeInsets.symmetric(horizontal: 20.0)));

    avatarAndText.addAll(afterAvatar('"${lastMsg.body}"'));

    var dt = DateTime.fromMillisecondsSinceEpoch(lastMsg.epoch);
    avatarAndText.addAll([
      Padding(padding: EdgeInsets.only(left: 15.0)),
      Text(
          '(${dt.day == DateTime.now().day && dt.month == DateTime.now().month && dt.year == DateTime.now().year ? 'Today' : dt.month} ${dt.hour}:${dt.minute})',
          style: TextStyle(color: Colors.grey.shade700, fontSize: 12))
    ]);

    var card = Card(
      key: ValueKey(widget.chatItem.id),
      child: Padding(
        child: GestureDetector(
            child: Row(children: avatarAndText),
            onLongPress: () {
              print('onLongPress ');
            }),
        padding: EdgeInsets.symmetric(vertical: 10.0),
      ),
    );

    return TextButton(
        onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      TextingPage(widget.chatItem, widget.onMsgSent),
                ),
              )
            },
        child: card);
  }
}
