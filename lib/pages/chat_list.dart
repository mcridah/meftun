import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/pages/texting.dart';
import 'package:me_flutting/widget/chatitem.dart';
import '../models/chat.dart';
// import 'package:me_flutting/models/person.dart';
// import 'package:me_flutting/widget/contactitem.dart';

class ChatList extends StatelessWidget {
  final List<Chat> chats;

  ChatList({Key key, this.chats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _col();
  }

  Expanded _expan() {
    return Expanded(
        child: ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: chats.length,
      itemBuilder: (BuildContext context, int index) =>
          _txBut(context, chats[index]),
    ));
  }

  Column _col() {
    return Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 16.0),
      ),
      _expan(),
      //ContactItem(dormantContacts: contacts), // error! :(
    ]);
  }

  TextButton _txBut(BuildContext context, Chat chat) {
    return TextButton(
        onPressed: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TextingPage(selChat: chat),
                ),
              )
            },
        child: ChatItem(chatItem: chat));
  }
}
