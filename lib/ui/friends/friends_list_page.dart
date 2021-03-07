import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo_curd_firebase/ui/friends/add_friend_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_curd_firebase/ui/frienddetails/friend_details_page.dart';
import 'package:flutter_demo_curd_firebase/ui/friends/friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'friend.dart';

import 'friend.dart';
import 'friend.dart';

class FriendsListPage extends StatefulWidget {
  @override
  _FriendsListPageState createState() => new _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  List<Friend> _friends = [];
  List<Friend> friends = [];

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection('friends')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  Friend friend = new Friend(doc["avatar"], doc["name"],
                      doc["email"], doc["location"]);
                  _friends.add(friend);
                });
              })
            });
    print(_friends);
  }

  Widget _buildFriendListTile(BuildContext context, int index) {
    var friend = _friends[index];

    return new ListTile(
      onTap: () => _navigateToFriendDetails(friend, index),
      leading: new Hero(
        tag: index,
        child: new CircleAvatar(
          backgroundImage: new NetworkImage(friend.avatar),
        ),
      ),
      title: new Text(friend.name),
      subtitle: new Text(friend.email),
    );
  }

  void _navigateToFriendDetails(Friend friend, Object avatarTag) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new FriendDetailsPage(friend, avatarTag: avatarTag);
        },
      ),
    );
  }

  void findName(String placeName) async {
    List<Friend> friendList = [];
    for (int i = 0; i < friends.length; i++) {
      if (friends[i].name.contains(placeName)) {
        friendList.add(friends[i]);
      }
    }
    print(friendList);
    setState(() {
      _friends = friendList;
    });
  }

  TextEditingController searchEditingController = TextEditingController();
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text("Friends");
  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_friends.isEmpty) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      // content = new ListView.builder(
      //     itemCount: _friends.length,
      //     itemBuilder: _buildFriendListTile,
      // );
      content = StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("friends").snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot) {
          if (querySnapshot.hasError) {
            return Text("Error");
          }
          if (querySnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            final list = querySnapshot.data.docs;

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                Friend currenFriend = new Friend(
                    list[index]["avatar"],
                    list[index]["name"],
                    list[index]["email"],
                    list[index]["location"]);
                return ListTile(
                  onTap: () => _navigateToFriendDetails(currenFriend, index),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (_) => new CupertinoAlertDialog(
                        title: new Text("Delete"),
                        content: new Text("Do you want to delete it?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () {
                              print( list[index]["name"]);
                              print( list[index]["email"]);
                              print( list[index]["location"]);
                              _loadFriends();
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )
                    );
                  },
                  leading: new Hero(
                    tag: index,
                    child: new CircleAvatar(
                      backgroundImage: new NetworkImage(list[index]["avatar"]),
                    ),
                  ),
                  title: new Text(list[index]["name"]),
                  subtitle: new Text(list[index]["email"]),
                );
              },
            );
          }
        },
      );
    }
    return new Scaffold(
      appBar: new AppBar(
        title: cusSearchBar,
        actions: <Widget>[
          IconButton(
              icon: cusIcon,
              onPressed: () {
                setState(() {
                  if (this.cusIcon.icon == Icons.search) {
                    this.cusIcon = Icon(Icons.cancel);
                    this.cusSearchBar = TextField(
                        onChanged: (val) {
                          findName(val);
                        },
                        controller: searchEditingController);
                  } else {
                    this.cusIcon = Icon(Icons.search);
                    this.cusSearchBar = Text("Friends");
                    _loadFriends();
                  }
                });
              })
        ],
      ),
      body: content,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddFriendPage(),
              ));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
