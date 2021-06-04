import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/models/chat.dart' show Chat;
import '../helpers/msghelper.dart' show MessageFactory;
import '../pages/texting.dart' show TextingPage;
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatItem extends StatefulWidget {
  final MessageFactory messageFactory;
  final void Function(String) onMsgSent;

  const ChatItem(this.messageFactory, this.onMsgSent, [Key key])
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ChatItemState();
}

class ChatItemState extends State<ChatItem> {
  static const PAD_AV_AR = 30.0;

  @override
  Widget build(BuildContext context) {
    final lastMsg = widget.messageFactory.lastMessage;
    final meOrCaption = (Chat _) =>
        _ == widget.messageFactory.chatFactory.owner ? '[YOU]' : _.caption;
    final from = meOrCaption(lastMsg.from);
    final to = meOrCaption(lastMsg.chatGroup);
    final dt = lastMsg.epochToTimeString();
    final fromAv = lastMsg.from.photoURL;
    final toAv = lastMsg.chatGroup.photoURL;
    final msgStat =
        lastMsg.epoch % 2 == 0 ? Colors.grey.shade700 : Colors.blue.shade300;

    final _av = (String whois, String avAss) => Column(
          children: [
            _wrapInGd(CircleAvatar(backgroundImage: AssetImage(avAss))),
            Text(whois)
          ],
        );

    final _ar = Column(
      children: [
        Icon(Icons.arrow_forward, color: msgStat),
        Padding(padding: EdgeInsets.symmetric(horizontal: PAD_AV_AR)),
        Text(dt, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
      ],
    );

    final _avarettin = [_av(from, fromAv), _ar, _av(to, toAv)];

    return _sl(_frame(Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(children: _avarettin)),
            _midSect(lastMsg.body),
          ],
        ))));
  }

  Widget _midSect(String lastMsg) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(lastMsg.length > 20 ? '${lastMsg.substring(0, 20)}...' : lastMsg,
              style: TextStyle(fontSize: 14)),
        ],
      );

  Padding _lrAvatar(String avFrom, String avTo, String whoFrom, String whoTo,
      Color msgStatColor, String dt, bool isleft) {}

  Widget _frame(Widget _inner) => TextButton(
      onPressed: () async => TextingPage.letTheGameBegin(
          context, widget.onMsgSent, widget.messageFactory),
      child: Card(
        key: ValueKey(widget.messageFactory.chatItem.id),
        child: _inner,
      ));

  GestureDetector _wrapInGd(Widget item) =>
      GestureDetector(onLongPress: () => null, child: item);

// //

  Slidable _sl(Widget _inner) => Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.125,
        child: _inner,
        actions: _sl_acts,
        secondaryActions: _sl_acts,
      );

  List<IconSlideAction> get _sl_acts => [
        IconSlideAction(
          //caption:'Profile',
          color: Colors.blue.shade100,
          icon: Icons.person_remove,
          onTap: () => null,
        ),
        IconSlideAction(
          //caption: 'Delete\nChat',
          color: Colors.yellow.shade100,
          icon: Icons.delete,
          onTap: () => null,
        ),
      ];
}
