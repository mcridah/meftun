// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
// --

// -- model uses
import '../models/msg.dart';
// --

// -- pages
import '../widgets/msg_item.dart';
// --
//

class SavedMessagesList extends StatelessWidget {
  final List<Message> inboxMsgs;

  const SavedMessagesList({Key key, this.inboxMsgs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          child: Text("Saved"),
          padding: EdgeInsets.only(top: 16.0),
        ),
        inboxMsgs.length > 0
            ? Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: inboxMsgs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MessageItem(inboxMsg: inboxMsgs[index]);
                  },
                ),
              )
            : Text("No message saved."),
      ],
    );
  }
}
