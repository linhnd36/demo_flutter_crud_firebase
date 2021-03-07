import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_curd_firebase/ui/friends/friend.dart';

import '../friends/friend.dart';

class FriendDetailBody extends StatefulWidget {
  FriendDetailBody(this.friend);
  final Friend friend;

  @override
  _FriendDetailBodyState createState() => _FriendDetailBodyState();
}

Future<void> updateFriend(Friend friend) async {
  await Firebase.initializeApp();
  CollectionReference friendDb = FirebaseFirestore.instance.collection('friends');
  return friendDb
      .doc(friend.email)
      .set({
    'name': friend.name,
    'avatar': friend.avatar,
    'location': friend.location,
    'email':friend.email
  })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

class _FriendDetailBodyState extends State<FriendDetailBody> {
  bool flag = false;
  String name, location;
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  Widget _buildLocationInfo(TextTheme textTheme) {
    location = widget.friend.location;
    return new Row(
      children: <Widget>[
        flag
            ? Expanded(
                child: TextFormField(
                cursorColor: Theme.of(context).cursorColor,
                maxLength: 100,
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: "Input location here",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6200EE)),
                  ),
                ),
              ))
            : new Text(
                location,
                style: textTheme.subhead.copyWith(color: Colors.white),
              ),
        new Icon(
          Icons.place,
          color: Colors.white,
          size: 16.0,
        ),
      ],
    );
  }

  Widget _createCircleBadge(IconData iconData, Color color) {
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: new CircleAvatar(
        backgroundColor: color,
        child: new Icon(
          iconData,
          color: Colors.white,
          size: 16.0,
        ),
        radius: 16.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    name = widget.friend.name;
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          children: [
            flag
                ? Expanded(
                    child: TextFormField(
                    cursorColor: Theme.of(context).cursorColor,
                    maxLength: 50,
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nick Name',
                      labelStyle: TextStyle(color: Colors.white),
                      hintText: "Input nick name here",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6200EE)),
                      ),
                    ),
                  ))
                : Text(
                    name,
                    style: textTheme.headline.copyWith(color: Colors.white),
                  ),
            SizedBox(
              width: 5,
            ),
            IconButton(
              icon: flag ? Icon(Icons.check_circle) : Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  flag = !flag;
                  if (nameController.text.trim() != null && locationController.text.trim() != null) {
                    if(nameController.text.trim().isNotEmpty && locationController.text.trim().isNotEmpty) {
                      name = nameController.text.trim();
                      location = locationController.text.trim();
                    }
                  }
                });
                print("name:" + name + " - location:" + location);
              },
            ),
          ],
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: _buildLocationInfo(textTheme),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Text(
            'Lorem Ipsum is simply dummy text of the printing and typesetting '
            'industry. Lorem Ipsum has been the industry\'s standard dummy '
            'text ever since the 1500s.',
            style:
                textTheme.body1.copyWith(color: Colors.white70, fontSize: 16.0),
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: new Row(
            children: <Widget>[
              _createCircleBadge(Icons.beach_access, theme.accentColor),
              _createCircleBadge(Icons.cloud, Colors.white12),
              _createCircleBadge(Icons.shop, Colors.white12),
            ],
          ),
        ),
      ],
    );
  }
}
