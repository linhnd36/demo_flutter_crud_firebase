import 'package:flutter/material.dart';

class AddFriendPage extends StatefulWidget {
  @override
  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  String stringDefault = '';
  String avatar = '';
  String name = '';
  String email = '';
  String location = '';
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
    return Column(
      children: <Widget>[
        _entryField("Avatar", Icon(Icons.image)),
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
      onPressed: () {
        // Navigator.of(context).pop();
        print('Avatar: ' +
            avatar +
            ' - Name: ' +
            name +
            ' - Email: ' +
            email +
            ' - Location: ' +
            location);
      },
    );
  }
}
