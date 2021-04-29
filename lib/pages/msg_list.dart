// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
// --

// -- model uses
import '../models/msg.dart';
import '../models/mock_repo.dart';
// --

// -- pages
import 'create_msg.dart';
// --
//

class MessagesPage extends StatefulWidget {
  MessagesPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage> {
  List<Message> newMessages;
  List<Message> savedMessages;

  @override
  void initState() {
    super.initState();

    newMessages = [];
    savedMessages = [];
    loadMessages();
  }

  void loadMessages() {
    newMessages.addAll(mockNewMessages);
    savedMessages.addAll(mockSavedMessages);
  }

  static MessagesPageState of(BuildContext context) {
    return context.findAncestorStateOfType<MessagesPageState>();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("<name_here>'s Message Board"),
          backgroundColor: Colors.grey,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              _buildCategoryTab("Inbox"),
              _buildCategoryTab("Saved"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MessagesList(title: "Inbox", inboxMsgs: newMessages),
            MessagesList(title: "Saved", inboxMsgs: savedMessages),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreateMessagePage(
                  buddys: mocklocalUsers,
                ),
              ),
            );
          },
          tooltip: 'Post a message.',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String title) {
    return Tab(
      child: Text(title),
    );
  }

  void ignore(Message inboxMsg) {
    setState(() {
      if (inboxMsg.isSaved) {
        savedMessages.remove(inboxMsg);
      } else {
        newMessages.remove(inboxMsg);
      }
    });
  }

  void save(Message inboxMsg) {
    setState(() {
      newMessages.remove(inboxMsg);
      savedMessages.add(inboxMsg.copyWith(
        saved: true,
      ));
    });
  }
}

class MessagesList extends StatelessWidget {
  final String title;
  final List<Message> inboxMsgs;

  const MessagesList({Key key, this.title, this.inboxMsgs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          child: Text(title),
          padding: EdgeInsets.only(top: 16.0),
        ),
        inboxMsgs.length > 0
            ? Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: inboxMsgs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _MessageCardItem(inboxMsg: inboxMsgs[index]);
                  },
                ),
              )
            : Text("horaay, we have no new message here!"),
      ],
    );
  }
}

class _MessageCardItem extends StatelessWidget {
  final Message inboxMsg;

  const _MessageCardItem({Key key, this.inboxMsg}) : super(key: key);

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
              MessagesPageState.of(context).save(inboxMsg);
            },
          ),
          TextButton(
            child: Text("Ignore"),
            onPressed: () {
              MessagesPageState.of(context).ignore(inboxMsg);
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
