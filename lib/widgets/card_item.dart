// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
// --

// -- model uses
import '../models/msg.dart';
// --

// -- pages
import '../board.dart';
// --
//

class MessageCardItem extends StatelessWidget {
  final Message inboxMsg;

  const MessageCardItem({Key key, this.inboxMsg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(inboxMsg.uuid),
      color: Colors.lightGreen.shade100,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Padding(
        child: Column(
          children: <Widget>[
            _itemHeader(inboxMsg),
            Text(this.inboxMsg.body),
            _itemFooter(context, inboxMsg)
          ],
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  Widget _itemFooter(BuildContext context, Message inboxMsg) {
    if (inboxMsg.isSaved) {
      return Container(
        margin: EdgeInsets.only(top: 8.0),
        alignment: Alignment.centerRight,
        child: Chip(
          label: Text("Saved."),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextButton(
            child: Text("Save"),
            onPressed: () {
              BoardPageState.of(context).save(inboxMsg);
            },
          ),
          TextButton(
            child: Text("Ignore"),
            onPressed: () {
              BoardPageState.of(context).ignore(inboxMsg);
            },
          )
        ],
      );
    }
  }

  Widget _itemHeader(Message inboxMsg) {
    ImageProvider<Object> iPv = AssetImage("avatar.png");

    if (inboxMsg.from.photoURL.startsWith("http")) {
      iPv = NetworkImage(
        inboxMsg.from.photoURL,
      );
    } else if (inboxMsg.from.photoURL != "") {
      iPv = AssetImage("${inboxMsg.from.photoURL}.jpg");
    }

    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: iPv,
        ),
        Expanded(
          child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("${inboxMsg.from.name} says: ")),
        )
      ],
    );
  }
}
