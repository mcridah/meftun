import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../helpers/msghelper.dart' show MessageFactory;
import '../models/directchat.dart' show DirectChat;

class ProfilePage extends StatelessWidget {
  final MessageFactory messageFactory;

  const ProfilePage(this.messageFactory, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Text('Profile/${messageFactory.chatItem.caption}'),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 180,
                    height: 290,
                    child: Image.asset(messageFactory.chatItem.photoURL)),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                      messageFactory.chatItem.name ??
                          messageFactory.chatItem.caption,
                      style: TextStyle(fontSize: 25)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text(messageFactory.chatItem is DirectChat ? '' : '(Group)',
                      style: TextStyle(fontSize: 15)),
                ])
              ],
            )));
  }
}