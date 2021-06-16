import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '/pages/main.dart' show MainPage;
import '/models/directchat.dart' show DirectChat;
import '/helpers/table_helper.dart' show ChatTable, MessageTable;

//import '/models/groupchat.dart' show GroupChat;
import '/models/botchat.dart' show BotChat;
//import '/models/mbody.dart' show RawBody;
//import '/models/message.dart' show Message;

void main() {
  final botEfendi = BotChat('5', meSession, 'efendi', name: 'Bot Efendi');
  final apiBot = BotChat('6', botEfendi, 'api', name: 'API helper bot');
  final sqlBot = BotChat('7', botEfendi, 'sql', name: 'SQLite helper bot');

  chatTable.deleteChat(meSession);
  chatTable.deleteChat(botEfendi);
  chatTable.deleteChat(apiBot);
  chatTable.deleteChat(sqlBot);

  chatTable.insertChat(meSession);
  chatTable.insertChat(botEfendi);
  chatTable.insertChat(apiBot);
  chatTable.insertChat(sqlBot);
  /*
   
  final pac = DirectChat('2', 'pac', name: 'Tupac Shakur', photoURL: 'pac.jpg');
  final thugs = GroupChat('3', 'THUGS');
  final big = DirectChat('4', 'big', name: 'Notorious BIG', photoURL: 'big.jpg');
  final ali = DirectChat('8', 'ali');
   
  chatTable.insertChat(pac);
  chatTable.insertChat(thugs);
  chatTable.insertChat(big);
  chatTable.insertChat(ali);

  messageTable.insertMessage(
      Message('4', RawBody('maan, f this sh.'), meSession, big, 1542450000000));
  messageTable.insertMessage(
      Message('1', RawBody('whutsup bro?'), pac, pac, 1042342000000));
  messageTable.insertMessage(
      Message('3', RawBody('yeah, indeed.'), big, thugs, 1622450000000));
  messageTable.insertMessage(
      Message('2', RawBody('thug 4 life!'), pac, thugs, 1027675000000));
  messageTable.insertMessage(Message('5', RawBody('heyoooo'), ali, ali,
      DateTime.now().millisecondsSinceEpoch));
*/
  runApp(Builder(
      builder: (_) => MaterialApp(
            theme: ThemeData(primarySwatch: Colors.indigo),
            title: APP_TITLE,
            home: MainPage(),
          )));
}

const APP_TITLE = 'Meftune';
final meSession =
    DirectChat('1', 'mcan', name: 'Mustafa Can', photoURL: 'can.jpg');
final ChatTable chatTable = ChatTable();
final MessageTable messageTable = MessageTable();
