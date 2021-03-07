import 'dart:async';
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
  List<Friend> _searchResult = [];

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
              Friend friend = new Friend(doc["avatar"], doc["name"], doc["email"], doc["location"]);
              _friends.add(friend);
            });
    })
    });
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

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    print("Size lsit friend:"+_friends.length.toString());
    _friends.forEach((friend) {
      if (friend.name.contains(text) || friend.email.contains(text))
        _searchResult.add(friend);
    });
    print("Size search:"+_searchResult.length.toString());
    setState(() {});
  }


  TextEditingController searchEditingController = TextEditingController();
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text("Friends");
  @override
  Widget build(BuildContext context) {
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
                          onChanged: onSearchTextChanged,
                          controller: searchEditingController
                      );
                    }
                    else{
                      this.cusIcon = Icon(Icons.search);
                      this.cusSearchBar = Text("Friends");
                      searchEditingController.clear();
                      onSearchTextChanged('');
                    }
                  });
                }
            )
          ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddFriendPage(),));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),

      body: _searchResult.length != 0 || searchEditingController.text.isNotEmpty
        ? new ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, index){
                Friend currenFriend = new Friend(_searchResult[index].avatar, _searchResult[index].name, _searchResult[index].email, _searchResult[index].location);
                return ListTile(
                  onTap: () => _navigateToFriendDetails(currenFriend, index),
                  leading: new Hero(
                    tag: index,
                    child: new CircleAvatar(
                      backgroundImage: new NetworkImage(_searchResult[index].avatar),
                    ),
                  ),
                  title: new Text(_searchResult[index].name),
                  subtitle: new Text(_searchResult[index].email),
                );
              },
          )
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("friends").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> querySnapshot){
          if(querySnapshot.hasError){
            return Text("Error");
          }
          if(querySnapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          }else{

            final list = querySnapshot.data.docs;
            _friends.clear();
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context,index){
                Friend currenFriend = new Friend(list[index]["avatar"], list[index]["name"], list[index]["email"], list[index]["location"]);
                _friends.add(currenFriend);
                return ListTile(
                  onTap: () => _navigateToFriendDetails(currenFriend, index),
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
      ),
    );
  }
}
