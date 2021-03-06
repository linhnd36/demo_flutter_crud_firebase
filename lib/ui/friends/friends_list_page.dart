import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_demo_curd_firebase/ui/frienddetails/friend_details_page.dart';
import 'package:flutter_demo_curd_firebase/ui/friends/friend.dart';

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
    http.Response response =
        await http.get('https://randomuser.me/api/?results=25');

    setState(() {
      _friends = Friend.allFromResponse(response.body);
      friends = _friends;
    });
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
  void findName(String placeName) async
  {
    _friends = friends;
    List<Friend> friendList = [];
     for (int i = 0; i < _friends.length; i++){
      if (_friends[i].name.contains(placeName)){
        friendList.add(_friends[i]);
      }
    }
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
      content = new ListView.builder(
          itemCount: _friends.length,
          itemBuilder: _buildFriendListTile,
      );
    }
    return new Scaffold(
      appBar: new AppBar(
        title: cusSearchBar,
          actions: <Widget>[
            IconButton(
                icon: cusIcon,
                onPressed: (){
                  setState(() {
                    if(this.cusIcon.icon == Icons.search){
                      this.cusIcon = Icon(Icons.cancel);
                      this.cusSearchBar = TextField(
                          onChanged: (val){
                            findName(val);
                          },
                          controller: searchEditingController
                      );
                    }
                    else{
                      this.cusIcon = Icon(Icons.search);
                      this.cusSearchBar = Text("Friends");
                    }
                  });
                }
            )
          ],
      ),
      body: content
    );
  }
}
