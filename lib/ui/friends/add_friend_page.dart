
import 'dart:io';
import 'package:flutter_demo_curd_firebase/ui/dialog/progressDialog.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

Future<void> addFriend(String name,String avatar, String location,String email) async{
  await Firebase.initializeApp();
  CollectionReference friend = FirebaseFirestore.instance.collection('friends');
  // Call the user's CollectionReference to add a new user
  return friend.doc(email)
      .set({
    'name': name,
    'avatar': avatar,
    'location': location,
    'email': email
    })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

Future<String> uploadFile(String filePath) async {
  File file = File(filePath);
  String fileName = DateTime.now().toString();
  String urlFileImage;
  try {
    UploadTask task = FirebaseStorage.instance
        .ref("uploads/" + fileName)
        .putFile(file);

    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');
      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      print(task.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });

    // We can still optionally use the Future alongside the stream.
    try {
      await task;
      print('Upload complete.');
      Fluttertoast.showToast(
          msg: "Add New Friends Successfull !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      urlFileImage = await FirebaseStorage.instance
          .ref("uploads/" + fileName)
          .getDownloadURL();
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
      // ...
    }
  }catch (e) {
  }
  return urlFileImage;
}

class _AddFriendPageState extends State<AddFriendPage> {
  String stringDefault = '';
  String avatar = '';
  String name = '';
  String email = '';
  String location = '';

  File _image;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Add new friend'),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: EdgeInsets.only(top: 30.0),
          width: screenSize.width * 0.9,
          child: Column(
            children: <Widget>[
              _emailPasswordWidget(),
              SizedBox(
                height: 10.0,
              ),
              _submitButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _entryField(String title, Icon icon, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                switch(title) {
                  case 'Avatar' : avatar = value;
                  break;
                  case 'Name' : name = value;
                  break;
                  case 'Email' : email = value;
                  break;
                  case 'Location' : location = value;
                  break;
                }
              });
            },
            
            obscureText: isPassword,
            decoration: InputDecoration(
                labelText: title,
                prefixIcon: icon,
                border: OutlineInputBorder(),
                fillColor: Color(0xfff3f3f4),
                filled: true),
          ),
        ],
      ),
    );
  }

  Widget _emailPasswordWidget() {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Color(0xff476cfb),
                child: ClipOval(
                  child: new SizedBox(
                    width: 180.0,
                    height: 180.0,
                    child: (_image!=null)?Image.file(
                      _image,
                      fit: BoxFit.fill,
                    ):Image.network(
                      "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 60.0),
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.camera,
                  size: 30.0,
                ),
                onPressed: () {
                  getImage();
                },
              ),
            ),
          ],
        ),
        _entryField("Name", Icon(Icons.account_box)),
        _entryField("Email", Icon(Icons.email)),
        _entryField("Location", Icon(Icons.location_on_outlined)),
      ],
    );
  }

  Widget _submitButton(
    BuildContext context,
  ) {
    final screenSize = MediaQuery.of(context).size;
    return FlatButton(
      child: Container(
        width: screenSize.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).accentColor
                ])),
        child: Text(
          'Add new',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) => ProgressDialog(messages: "Upload Image, wait....",),
        );
        String urlImage = await uploadFile(_image.path);
        Navigator.of(context).pop();
        addFriend(name,urlImage,location,email);
        Navigator.of(context).pop();
      },
    );
  }
}
